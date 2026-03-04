// lib/screens/personal_info_screen.dart
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

import '../services/api_client.dart';
import '../state/auth_state.dart';
import '../localization/strings_ext.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _nameCtrl = TextEditingController();
  final _oldPassCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();

  bool _savingName = false;
  bool _savingPass = false;
  bool _uploadingPhoto = false;
  bool _deletingAccount = false;

  String? _msg;

  static const Color _brandGold = Color(0xFFD4AF37);
  static const Color _darkBg = Color(0xFF2F2F2F);
  static const Color _cardBg = Color(0xFF3A3A3A);

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthState>();
    _nameCtrl.text = auth.name ?? '';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _oldPassCtrl.dispose();
    _newPassCtrl.dispose();
    super.dispose();
  }

  void _setMsg(String? m) => setState(() => _msg = m);

  void _toast(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _cardBg,
        behavior: SnackBarBehavior.floating,
        content: Text(
          msg,
          style: TextStyle(
            color: isError ? Colors.redAccent : Colors.white,
          ),
        ),
      ),
    );
  }

  // ---------- PROFILE: NAME ----------
  Future<void> _saveName() async {
    final s = context.stringsRead;

    final newName = _nameCtrl.text.trim();
    if (newName.isEmpty) return;

    setState(() {
      _savingName = true;
      _msg = null;
    });

    try {
      final api = context.read<ApiClient>();
      final res = await api.put('/api/auth/me', body: {'name': newName});

      if (res.statusCode != 200) {
        throw Exception('${res.statusCode} ${res.body}');
      }

      context.read<AuthState>().setNameLocal(newName);

      _setMsg(s.nameUpdated);
      _toast(s.nameUpdated);
    } catch (e) {
      final msg = '${s.errorPrefix}: $e';
      _setMsg(msg);
      _toast(msg, isError: true);
    } finally {
      if (mounted) setState(() => _savingName = false);
    }
  }

  // ---------- PROFILE: PASSWORD ----------
  Future<void> _changePassword() async {
    final s = context.stringsRead;

    final oldPass = _oldPassCtrl.text.trim();
    final newPass = _newPassCtrl.text.trim();
    if (oldPass.isEmpty || newPass.isEmpty) return;

    setState(() {
      _savingPass = true;
      _msg = null;
    });

    try {
      final api = context.read<ApiClient>();
      final res = await api.put('/api/auth/change-password', body: {
        'oldPassword': oldPass,
        'newPassword': newPass,
      });

      if (res.statusCode != 200) {
        throw Exception('${res.statusCode} ${res.body}');
      }

      _oldPassCtrl.clear();
      _newPassCtrl.clear();

      _setMsg(s.passwordChanged);
      _toast(s.passwordChanged);
    } catch (e) {
      final msg = '${s.errorPrefix}: $e';
      _setMsg(msg);
      _toast(msg, isError: true);
    } finally {
      if (mounted) setState(() => _savingPass = false);
    }
  }

  // ---------- FIREBASE STORAGE HELPERS ----------
  Future<String> _uploadToFirebaseStorage({
    required String userId,
    required File file,
  }) async {
    // نثبت الامتداد (وبنسمي الملف ثابت)
    final ext = p.extension(file.path).toLowerCase();
    final safeExt = (ext == '.png') ? '.png' : '.jpg';

    final ref = FirebaseStorage.instance
        .ref()
        .child('avatars')
        .child(userId)
        .child('avatar$safeExt');

    await ref.putFile(
      file,
      SettableMetadata(
        contentType: safeExt == '.png' ? 'image/png' : 'image/jpeg',
        cacheControl: 'public,max-age=3600',
      ),
    );

    return await ref.getDownloadURL();
  }

  Future<void> _deleteAvatarFromStorage(String userId) async {
    // محاولة حذف png و jpg (لأنه ممكن المستخدم رفع نوع مختلف)
    Future<void> tryDelete(String name) async {
      try {
        await FirebaseStorage.instance
            .ref()
            .child('avatars')
            .child(userId)
            .child(name)
            .delete();
      } catch (_) {
        // تجاهل: إذا الملف غير موجود
      }
    }

    await tryDelete('avatar.jpg');
    await tryDelete('avatar.png');
  }

  // ---------- PROFILE: PHOTO (NEW FLOW) ----------
  Future<void> _pickAndUploadPhoto() async {
    final s = context.stringsRead;

    setState(() {
      _uploadingPhoto = true;
      _msg = null;
    });

    try {
      final auth = context.read<AuthState>();
      final api = context.read<ApiClient>();

      // ✅ لازم هيك مو toString()
      final uid = auth.userId;
      if (uid == null || uid.isEmpty) {
        _toast(s.sessionExpiredPleaseRelogin, isError: true);
        return;
      }

      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (picked == null) return;

      final file = File(picked.path);

      // 1) Upload to Firebase Storage
      final url = await _uploadToFirebaseStorage(userId: uid, file: file);

      // ✅ 2) Save in backend: ابعتي name كمان حتى ما يرجع 400
      final currentName = (auth.name ?? '').trim();
      if (currentName.isEmpty) {
        _toast(s.nameRequiredSaveFirst, isError: true);
        return;
      }

      final res = await api.put('/api/auth/me', body: {
        'name': currentName,
        'avatarUrl': url,
      });

      if (res.statusCode != 200) {
        throw Exception('${res.statusCode} ${res.body}');
      }

      // 3) Update local state (cache buster)
      final displayUrl = '$url?t=${DateTime.now().millisecondsSinceEpoch}';
      await auth.setAvatarUrl(displayUrl);

      if (mounted) setState(() {});
      _setMsg(s.photoUpdated);
      _toast(s.photoUpdated);
    }catch (e) {
      final msg = '${s.errorPrefix}: $e';
      _setMsg(msg);
      _toast(msg, isError: true);
    } finally {
      if (mounted) setState(() => _uploadingPhoto = false);
    }
  }

  // ---------- DELETE ACCOUNT ----------
  Future<void> _confirmDeleteAccount() async {
    if (_deletingAccount) return;

    final s = context.stringsRead;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          s.deleteAccountDialogTitle,
          style: const TextStyle(color: _brandGold, letterSpacing: 1.1),
        ),
        content: Text(
          s.deleteAccountDialogBody,
          style: TextStyle(color: Colors.white.withOpacity(0.75)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              s.cancelBtn,
              style: TextStyle(
                color: Colors.white.withOpacity(0.75),
                letterSpacing: 1.0,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              s.deleteBtn,
              style: const TextStyle(
                color: Colors.redAccent,
                letterSpacing: 1.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (ok == true) {
      await _deleteAccount();
    }
  }

  Future<void> _deleteAccount() async {
    final s = context.stringsRead;

    setState(() {
      _deletingAccount = true;
      _msg = null;
    });

    try {
      final api = context.read<ApiClient>();
      final auth = context.read<AuthState>();
      final uid = auth.userId;
      if (uid == null || uid.isEmpty) {
        _toast('Session expired. Please re-login.', isError: true);
        return;
      }
      await _deleteAvatarFromStorage(uid);


      final res = await api.delete('/api/auth/me');
      if (res.statusCode != 200 && res.statusCode != 204) {
        throw Exception('${res.statusCode} ${res.body}');
      }

      await auth.logout(clearAvatar: true);

      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);

      _toast(s.accountDeleted);
    } catch (e) {
      final msg = '${s.errorPrefix}: $e';
      _setMsg(msg);
      _toast(s.errorDeletingAccount, isError: true);
    } finally {
      if (mounted) setState(() => _deletingAccount = false);
    }
  }

  // ---------- UI HELPERS ----------
  InputDecoration _dec({
    required String label,
    String? hint,
    IconData? icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.55)),
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.35)),
      prefixIcon: icon == null ? null : Icon(icon, color: _brandGold, size: 18),
      filled: true,
      fillColor: Colors.white.withOpacity(0.06),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.10)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _brandGold),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }

  ButtonStyle _goldButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: _brandGold,
      foregroundColor: _darkBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 14),
    );
  }

  ButtonStyle _dangerButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.redAccent.withOpacity(0.95),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final s = context.strings;

    final avatarUrl = auth.avatarUrl;
    final initials = (auth.name?.trim().isNotEmpty ?? false)
        ? auth.name!.trim().characters.first.toUpperCase()
        : s.unknownUserInitial;

    return Scaffold(
      backgroundColor: _darkBg,
      appBar: AppBar(
        backgroundColor: _darkBg,
        elevation: 0,
        centerTitle: true,
        title: Text(
          s.personalInfoTitle,
          style: const TextStyle(color: _brandGold, letterSpacing: 1.2),
        ),
        iconTheme: IconThemeData(color: Colors.white.withOpacity(0.85)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_msg != null)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _msg!.startsWith(s.errorPrefix)
                    ? Colors.red.withOpacity(0.12)
                    : Colors.green.withOpacity(0.10),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _msg!.startsWith(s.errorPrefix)
                      ? Colors.red.withOpacity(0.25)
                      : Colors.green.withOpacity(0.20),
                ),
              ),
              child: Text(
                _msg!,
                style: TextStyle(
                  color: _msg!.startsWith(s.errorPrefix)
                      ? Colors.redAccent
                      : Colors.white.withOpacity(0.9),
                ),
              ),
            ),

          // PHOTO CARD
          Container(
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                InkWell(
                  onTap: _uploadingPhoto ? null : _pickAndUploadPhoto,
                  borderRadius: BorderRadius.circular(999),
                  child: CircleAvatar(
                    radius: 34,
                    backgroundColor: Colors.white.withOpacity(0.06),
                    backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                        ? NetworkImage(avatarUrl)
                        : null,
                    child: (avatarUrl == null || avatarUrl.isEmpty)
                        ? Text(
                      initials,
                      style: const TextStyle(
                        fontSize: 22,
                        color: _brandGold,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                        : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _uploadingPhoto ? null : _pickAndUploadPhoto,
                      style: _goldButtonStyle(),
                      icon: const Icon(Icons.photo_camera),
                      label:
                      Text(_uploadingPhoto ? s.uploading : s.changePhoto),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // NAME CARD
          Container(
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.nameSectionTitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 11,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration:
                  _dec(label: s.yourNameLabel, icon: Icons.badge_outlined),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _savingName ? null : _saveName,
                    style: _goldButtonStyle(),
                    child: _savingName
                        ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : Text(
                      s.saveNameBtn,
                      style: const TextStyle(
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // EMAIL CARD
          Container(
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: ListTile(
              leading: const Icon(Icons.email_outlined, color: _brandGold),
              title: Text(
                s.emailLabel,
                style: TextStyle(color: Colors.white.withOpacity(0.85)),
              ),
              subtitle: Text(
                auth.email ?? '-',
                style: TextStyle(color: Colors.white.withOpacity(0.55)),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // PASSWORD CARD
          Container(
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.changePasswordSectionTitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 11,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _oldPassCtrl,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration:
                  _dec(label: s.oldPasswordLabel, icon: Icons.lock_outline),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _newPassCtrl,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration:
                  _dec(label: s.newPasswordLabel, icon: Icons.lock_reset),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _savingPass ? null : _changePassword,
                    style: _goldButtonStyle(),
                    child: _savingPass
                        ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : Text(
                      s.updatePasswordBtn,
                      style: const TextStyle(
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // DELETE ACCOUNT CARD
          Container(
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.dangerZoneTitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 11,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  s.deletePermanentHint,
                  style: TextStyle(color: Colors.white.withOpacity(0.55)),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _deletingAccount ? null : _confirmDeleteAccount,
                    style: _dangerButtonStyle(),
                    icon: _deletingAccount
                        ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Icon(Icons.delete_forever),
                    label: Text(
                      _deletingAccount ? s.deleting : s.deleteAccountBtn,
                      style: const TextStyle(
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

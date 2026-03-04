// lib/screens/profile_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/global_state.dart';
import 'personal_info_screen.dart';
import '../state/auth_state.dart';
import '../state/task_state.dart';
import '../localization/app_strings.dart';
import '../localization/strings_ext.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color _brandGold = Color(0xFFD4AF37);
  static const Color _darkBg = Color(0xFF2F2F2F);
  static const Color _cardBg = Color(0xFF3A3A3A);

  String _cacheBust(String url) {
    final sep = url.contains('?') ? '&' : '?';
    return '$url${sep}t=${DateTime.now().millisecondsSinceEpoch}';
  }

  ImageProvider? _buildAvatarProvider(AuthState auth) {
    final avatarUrl = auth.avatarUrl;
    final localPath = auth.profileImagePath;

    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      // مهم مع Firebase: إذا بدنا نكسر الكاش، نضيف &t بدل ما نكسر ?token
      return NetworkImage(_cacheBust(avatarUrl));
    }

    if (localPath != null &&
        localPath.isNotEmpty &&
        File(localPath).existsSync()) {
      return FileImage(File(localPath));
    }

    return null;
  }

  String _initials(AuthState auth, dynamic s) {
    return (auth.name?.trim().isNotEmpty ?? false)
        ? auth.name!.trim().characters.first.toUpperCase()
        : s.unknownUserInitial;
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    final gs = context.watch<GlobalState>();
    final s = context.strings;

    final initials = _initials(auth, s);
    final avatarProvider = _buildAvatarProvider(auth);

    return Scaffold(
      backgroundColor: _darkBg,

      // ✅ AppBar خاص في ProfileScreen: هيك بتضمني الصورة فوق يمين
      appBar: AppBar(
        backgroundColor: _darkBg,
        elevation: 0,
        centerTitle: true,
        title: Text(
          s.titleProfile, // لازم يكون موجود عندك بالترجمة
          style: const TextStyle(color: _brandGold, letterSpacing: 1.2),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PersonalInfoScreen()),
                );
              },
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white.withOpacity(0.08),
                backgroundImage: avatarProvider,
                child: avatarProvider == null
                    ? Text(
                  (auth.name?.trim().isNotEmpty ?? false)
                      ? auth.name!.trim().characters.first.toUpperCase()
                      : s.unknownUserInitial,
                  style: const TextStyle(color: _brandGold, fontWeight: FontWeight.w700),
                )
                    : null,
              ),
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ===== USER INFO =====
            Container(
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PersonalInfoScreen()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white.withOpacity(0.06),
                        backgroundImage: avatarProvider,
                        child: avatarProvider == null
                            ? Text(
                          initials,
                          style: const TextStyle(
                            fontSize: 20,
                            color: _brandGold,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              auth.name ?? s.noName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              auth.email ?? s.noEmail,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.55),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right,
                          color: Colors.white.withOpacity(0.6)),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            // ===== SETTINGS TITLE =====
            Text(
              s.settingsTitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 11,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),

            // ===== SETTINGS CARD =====
            Container(
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.language, color: _brandGold),
                    title: Text(s.languageTitle,
                        style: const TextStyle(color: Colors.white)),
                    subtitle: Text(
                      _langLabel(gs.currentLang, s),
                      style: TextStyle(color: Colors.white.withOpacity(0.55)),
                    ),
                    trailing: Icon(Icons.chevron_right,
                        color: Colors.white.withOpacity(0.6)),
                    onTap: () => _showLanguageDialog(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // ===== LOGOUT =====
            Container(
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: Text(
                  s.logout,
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () async {
                  await auth.logout(clearAvatar: false);
                  if (!context.mounted) return;
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/login', (r) => false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final gs = context.read<GlobalState>();

    showDialog(
      context: context,
      builder: (ctx) {
        final s = ctx.stringsRead;

        return AlertDialog(
          backgroundColor: _darkBg,
          title: Text(s.chooseLanguageTitle,
              style: const TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _langTile(ctx, gs, AppLang.en, s.langEnglish),
              _langTile(ctx, gs, AppLang.de, s.langGerman),
              _langTile(ctx, gs, AppLang.ar, s.langArabic),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                s.closeBtn,
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _langTile(BuildContext ctx, GlobalState gs, AppLang lang, String label) {
    return Theme(
      data: Theme.of(ctx).copyWith(
        unselectedWidgetColor: Colors.white.withOpacity(0.6),
      ),
      child: RadioListTile<AppLang>(
        activeColor: _brandGold,
        value: lang,
        groupValue: gs.currentLang,
        title: Text(label, style: const TextStyle(color: Colors.white)),
        onChanged: (v) {
          if (v == null) return;
          gs.setLang(v);
          Navigator.pop(ctx);
        },
      ),
    );
  }


  String _langLabel(AppLang lang, dynamic s) {
    switch (lang) {
      case AppLang.de:
        return s.langGerman;
      case AppLang.ar:
        return s.langArabic;
      default:
        return s.langEnglish;
    }
  }
}

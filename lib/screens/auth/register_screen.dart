import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_api.dart';
import '../../state/auth_state.dart';
import '../main_shell.dart';

import '../../localization/strings_ext.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();

  final _familyCodeCtrl = TextEditingController();
  final _familyNameCtrl = TextEditingController();

  bool _isLoading = false;
  String? _error;

  // نفس هوية Login
  final Color _brandGold = const Color(0xFFD4AF37);
  final Color _darkBg = const Color(0xFF2F2F2F);
  final Color _fieldBg = const Color(0xFF3A3A3A);

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final code = _familyCodeCtrl.text.trim();
      final familyName = _familyNameCtrl.text.trim();

      if (code.isNotEmpty && familyName.isNotEmpty) {
        setState(() {
          _error = context.stringsRead.chooseOnlyOneFamilyCodeOrName;
          _isLoading = false;
        });
        return;
      }

      final result = await AuthApi.register(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
        name: _nameCtrl.text.trim(),
        inviteCode: code.isEmpty ? null : code,
        familyName: familyName.isEmpty ? null : familyName,
      );


      final authState = context.read<AuthState>();
      await authState.setUser(
        id: result.userId.toString(),
        email: result.email,
        name: result.name,
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
        groups: result.groups,
      );

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    } catch (e) {
      if (!mounted) return;
      final msg = e.toString();
      final cleaned = msg.contains('Email already in use')
          ? 'Email already in use'
          : msg;

      setState(() => _error = '${context.stringsRead.registerFailedPrefix} $cleaned');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _nameCtrl.dispose();
    _familyCodeCtrl.dispose();
    _familyNameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.strings;

    return Scaffold(
      backgroundColor: _darkBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // زر رجوع بسيط بنفس الستايل
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ),

                  // Logo header (نفس Login)
                  Image.asset('assets/Duline_logo.png', height: 110),
                  const SizedBox(height: 12),
                  Text(
                    'DULINE',
                    style: TextStyle(
                      color: _brandGold,
                      fontSize: 26,
                      letterSpacing: 6,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'by HASKI',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 11,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 34),

                  if (_error != null)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 18),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.red.withOpacity(0.35)),
                      ),
                      child: Text(
                        _error!,
                        style: const TextStyle(color: Colors.redAccent),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  _label(s.nameLabel),
                  _input(
                    controller: _nameCtrl,
                    icon: Icons.person_outline,
                    validator: (v) =>
                    (v == null || v.trim().isEmpty) ? s.nameRequired : null,
                  ),

                  const SizedBox(height: 18),

                  _label(s.emailAddressLabel),
                  _input(
                    controller: _emailCtrl,
                    icon: Icons.email_outlined,
                    validator: (v) =>
                    (v != null && v.contains('@')) ? null : s.emailInvalid,
                  ),

                  const SizedBox(height: 18),

                  _label(s.passwordLabel),
                  _input(
                    controller: _passwordCtrl,
                    icon: Icons.lock_outline,
                    obscure: true,
                    validator: (v) =>
                    (v != null && v.length >= 6) ? null : s.passwordMinChars
                  ),

                  const SizedBox(height: 22),

                  // Family section (بنفس ألوان الصفحة)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.familySectionTitle,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 11,
                            letterSpacing: 1.8,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),

                        _label(s.familyCodeOptionalLabel),
                        _input(
                          controller: _familyCodeCtrl,
                          icon: Icons.key_outlined,
                          hint: s.familyCodeHint,
                        ),

                        const SizedBox(height: 14),

                        Center(
                          child: Text(
                            s.orLabel,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.35),
                              letterSpacing: 3,
                              fontSize: 11,
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        _label(s.familyNameOptionalLabel),
                        _input(
                          controller: _familyNameCtrl,
                          icon: Icons.group_outlined,
                          hint: s.familyNameHint,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _brandGold,
                        foregroundColor: _darkBg,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : Text(
                        s.createAccountBtn,
                        style: const TextStyle(
                          letterSpacing: 1.4,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  Text(
                    'HASKI TECH SOLUTIONS',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.15),
                      fontSize: 10,
                      letterSpacing: 3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.6),
          fontSize: 11,
          letterSpacing: 1.5,
        ),
      ),
    ),
  );

  Widget _input({
    required TextEditingController controller,
    required IconData icon,
    bool obscure = false,
    String? hint,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.35)),
        prefixIcon: Icon(icon, color: _brandGold, size: 18),
        filled: true,
        fillColor: _fieldBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

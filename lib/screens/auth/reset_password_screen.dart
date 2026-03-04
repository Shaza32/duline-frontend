import 'package:flutter/material.dart';
import '../../services/auth_api.dart';
import 'login_screen.dart';

import '../../localization/strings_ext.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String resetSessionToken;

  const ResetPasswordScreen({
    super.key,
    required this.resetSessionToken,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _loading = false;
  String? _error;

  // نفس ألوان اللوغين
  final Color _brandGold = const Color(0xFFD4AF37);
  final Color _darkBg = const Color(0xFF2F2F2F);
  final Color _fieldBg = const Color(0xFF3A3A3A);

  @override
  void dispose() {
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _reset() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await AuthApi.resetPassword(
        widget.resetSessionToken,
        _passCtrl.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.stringsRead.passwordChangedSuccess)),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
      );
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = context.stringsRead.resetFailedExpired;
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
                  // زر رجوع
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

                  // Logo
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

                  const SizedBox(height: 32),

                  Text(
                    s.resetPasswordTitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 22),

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

                  _label(s.newPasswordLabel),
                  _input(
                    controller: _passCtrl,
                    icon: Icons.lock_outline,
                    obscure: true,
                    validator: (v) {
                      final value = (v ?? '').trim();
                      if (value.isEmpty) return s.passwordRequired;
                      if (value.length < 6) return s.passwordMin6;
                      return null;
                    },
                  ),

                  const SizedBox(height: 18),

                  _label(s.confirmPasswordLabel),
                  _input(
                    controller: _confirmCtrl,
                    icon: Icons.lock_reset,
                    obscure: true,
                    validator: (v) {
                      final value = (v ?? '').trim();
                      if (value.isEmpty) return s.confirmRequired;
                      if (value != _passCtrl.text.trim()) {
                        return s.passwordsDoNotMatch;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 26),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _reset,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _brandGold,
                        foregroundColor: _darkBg,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: _loading
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : Text(
                        s.resetPasswordBtn,
                        style: const TextStyle(
                          letterSpacing: 1.4,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

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
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,

      // 🔒 تحديد صريح لحقل كلمة مرور (يمنع كيبورد الأرقام)
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      enableSuggestions: false,
      autocorrect: false,
      autofillHints: obscure
          ? const [AutofillHints.newPassword]
          : null,

      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
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

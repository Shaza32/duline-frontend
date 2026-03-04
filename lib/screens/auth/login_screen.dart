import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'forgot_password_screen.dart';

import '../../services/auth_api.dart';
import '../../state/auth_state.dart';
import '../main_shell.dart';
import 'register_screen.dart';

import '../../localization/strings_ext.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _showPassword = false;

  bool _isLoading = false;
  String? _error;

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
      final result = await AuthApi.login(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = context.stringsRead.loginInvalidCredentials);
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // LOGO
                  Image.asset('assets/Duline_logo.png', height: 250),
                  const SizedBox(height: 12),


                  if (_error != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _error!,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    ),

                  _label(s.emailAddressLabel),
                  _input(
                    controller: _emailCtrl,
                    icon: Icons.person_outline,
                    validator: (v) =>
                    (v != null && v.contains('@')) ? null : s.emailInvalid,
                  ),

                  const SizedBox(height: 20),

                  _label(s.passwordLabel),
                  _input(
                    controller: _passwordCtrl,
                    icon: Icons.lock_outline,
                    obscure: !_showPassword,
                    showToggle: true,
                    onToggle: () =>
                        setState(() => _showPassword = !_showPassword),
                    validator: (v) =>
                    (v != null && v.isNotEmpty) ? null : s.requiredField,
                  ),

                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        s.forgotPassword,
                        style: TextStyle(color: _brandGold),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

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
                          ? const CircularProgressIndicator()
                          : Text(
                        s.signInBtn,
                        style: const TextStyle(
                          letterSpacing: 1.4,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        s.noAccount,
                        style: TextStyle(color: Colors.white.withOpacity(0.5)),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: Text(
                          s.createNest,
                          style: TextStyle(
                            color: _brandGold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 60),

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
    bool showToggle = false,
    VoidCallback? onToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: _brandGold, size: 18),
        suffixIcon: showToggle
            ? IconButton(
          onPressed: onToggle,
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.white.withOpacity(0.7),
            size: 20,
          ),
        )
            : null,
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

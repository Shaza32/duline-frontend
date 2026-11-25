import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'forgot_password_screen.dart';
import 'register_screen.dart';
import '../main_shell.dart';

import '../../services/auth_api.dart';
import '../../state/auth_state.dart';
import '../../localization/strings_ext.dart';
import '../../theme/app_gradients.dart';

import '../../theme/app_colors.dart';
import '../../widgets/gold_button.dart';
import '../../widgets/app_background.dart';

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

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  // LOGIN LOGIC

  Future<void> _submit() async {
    if (_isLoading) return;
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authState = context.read<AuthState>();

      final result = await AuthApi.login(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
      );

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
        MaterialPageRoute(
          builder: (_) => const MainShell(),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _error = context.stringsRead.loginInvalidCredentials;
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // LOGIN DESIGN

  @override
  Widget build(BuildContext context) {
    final s = context.strings;

    return Scaffold(
      backgroundColor: AppColors.background,

      body: AppBackground(
        dimOpacity: 0.30,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 24,
              ),

              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 420,
                ),

                child: Form(
                  key: _formKey,

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      // LOGO

                      Image.asset(
                        'assets/duline_logo_new.png',
                        width: 300,
                        height: 200,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: 4),

                      ShaderMask(
                        shaderCallback: (bounds) {
                          return AppGradients.gold.createShader(bounds);
                        },
                        child: const Text(
                          'DULINE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      Text(
                        s.appTagline,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFFD4AF37),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 36),

                      // ERROR MESSAGE

                      if (_error != null)
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(
                            bottom: 20,
                          ),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(
                              alpha: 0.10,
                            ),
                            borderRadius:
                            BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.error.withValues(
                                alpha: 0.35,
                              ),
                            ),
                          ),
                          child: Text(
                            _error!,
                            style: const TextStyle(
                              color: AppColors.error,
                            ),
                          ),
                        ),

                      // EMAIL

                      _label(s.emailAddressLabel),

                      _input(
                        controller: _emailCtrl,
                        icon: Icons.mail_outline,
                        keyboardType:
                        TextInputType.emailAddress,
                        autofillHints: const [
                          AutofillHints.email,
                        ],
                        validator: (v) =>
                        (v != null && v.contains('@'))
                            ? null
                            : s.emailInvalid,
                      ),

                      const SizedBox(height: 22),

                      // PASSWORD

                      _label(s.passwordLabel),

                      _input(
                        controller: _passwordCtrl,
                        icon: Icons.lock_outline,
                        obscure: !_showPassword,
                        showToggle: true,
                        autofillHints: const [
                          AutofillHints.password,
                        ],
                        onToggle: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                        validator: (v) =>
                        (v != null && v.isNotEmpty)
                            ? null
                            : s.requiredField,
                      ),

                      const SizedBox(height: 8),

                      // FORGOT PASSWORD

                      Align(
                        alignment:
                        AlignmentDirectional.centerEnd,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                const ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: Text(
                            s.forgotPassword,
                            style: const TextStyle(
                              color: AppColors.gold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      // GOLD LOGIN BUTTON

                      GoldButton(
                        text: s.signInBtn,
                        onPressed: _submit,
                        isLoading: _isLoading,
                      ),

                      const SizedBox(height: 32),

                      // REGISTER

                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment:
                        WrapCrossAlignment.center,
                        spacing: 6,
                        children: [
                          Text(
                            s.noAccount,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),

                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                  const RegisterScreen(),
                                ),
                              );
                            },
                            child: Text(
                              s.createNest,
                              style: const TextStyle(
                                color: AppColors.gold,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // COMPANY

                      const Text(
                        'by HASKI',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // INPUT LABEL

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }

  // INPUT FIELD

  Widget _input({
    required TextEditingController controller,
    required IconData icon,
    bool obscure = false,
    bool showToggle = false,
    VoidCallback? onToggle,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    Iterable<String>? autofillHints,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      cursorColor: AppColors.gold,

      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 15,
      ),

      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.surface,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 19,
        ),

        prefixIcon: Icon(
          icon,
          color: AppColors.gold,
          size: 21,
        ),

        suffixIcon: showToggle
            ? IconButton(
          onPressed: onToggle,
          icon: Icon(
            obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.textSecondary,
            size: 20,
          ),
        )
            : null,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.border,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.border,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.gold,
            width: 1.4,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.error,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1.4,
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/auth_api.dart';
import '../../localization/strings_ext.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_gradients.dart';

import '../../widgets/gold_button.dart';
import '../../widgets/app_background.dart';

import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String resetSessionToken;

  const ResetPasswordScreen({
    super.key,
    required this.resetSessionToken,
  });

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState
    extends State<ResetPasswordScreen> {

  final _formKey = GlobalKey<FormState>();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _loading = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  String? _error;

  @override
  void dispose() {
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  // RESET PASSWORD

  Future<void> _reset() async {
    if (_loading) return;
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

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
        SnackBar(
          content: Text(
            context.stringsRead.passwordChangedSuccess,
            style: const TextStyle(
              color: AppColors.textPrimary,
            ),
          ),
          backgroundColor: AppColors.surface,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(
              color: AppColors.success,
            ),
          ),
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
            (route) => false,
      );

    } catch (_) {
      if (!mounted) return;

      setState(() {
        _error = context.stringsRead.resetFailedExpired;
      });

    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  // RESET PASSWORD SCREEN

  @override
  Widget build(BuildContext context) {
    final s = context.strings;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,

      child: Scaffold(
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

                        // BACK BUTTON

                        Align(
                          alignment:
                          AlignmentDirectional.centerStart,
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const BackButtonIcon(),
                            color: AppColors.gold,
                          ),
                        ),

                        // LOGO

                        Image.asset(
                          'assets/duline_logo_new.png',
                          width: 260,
                          height: 140,
                          fit: BoxFit.contain,
                        ),

                        const SizedBox(height: 4),

                        // BRAND NAME

                        ShaderMask(
                          shaderCallback: (bounds) {
                            return AppGradients.gold
                                .createShader(bounds);
                          },

                          child: const Text(
                            'DULINE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 7,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // TAGLINE

                        Text(
                          s.appTagline,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.gold,
                            fontSize: 13,
                            letterSpacing: 0.5,
                          ),
                        ),

                        const SizedBox(height: 28),

                        // SECURITY ICON

                        Container(
                          width: 64,
                          height: 64,

                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.gold.withValues(
                                alpha: 0.35,
                              ),
                            ),
                          ),

                          child: const Icon(
                            Icons.lock_reset_outlined,
                            color: AppColors.gold,
                            size: 32,
                          ),
                        ),

                        const SizedBox(height: 18),

                        // SCREEN TITLE

                        Text(
                          s.resetPasswordTitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ERROR MESSAGE

                        if (_error != null)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(
                              bottom: 18,
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
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.error,
                              ),
                            ),
                          ),

                        // NEW PASSWORD

                        _label(s.newPasswordLabel),

                        _passwordInput(
                          controller: _passCtrl,
                          icon: Icons.lock_outline,
                          obscure: !_showPassword,

                          textInputAction:
                          TextInputAction.next,

                          onToggle: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },

                          validator: (v) {
                            final value = (v ?? '').trim();

                            if (value.isEmpty) {
                              return s.passwordRequired;
                            }

                            if (value.length < 6) {
                              return s.passwordMin6;
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 22),

                        // CONFIRM PASSWORD

                        _label(s.confirmPasswordLabel),

                        _passwordInput(
                          controller: _confirmCtrl,
                          icon: Icons.lock_reset_outlined,
                          obscure: !_showConfirmPassword,

                          textInputAction:
                          TextInputAction.done,

                          onToggle: () {
                            setState(() {
                              _showConfirmPassword =
                              !_showConfirmPassword;
                            });
                          },

                          validator: (v) {
                            final value = (v ?? '').trim();

                            if (value.isEmpty) {
                              return s.confirmRequired;
                            }

                            if (value != _passCtrl.text.trim()) {
                              return s.passwordsDoNotMatch;
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 30),

                        // RESET PASSWORD BUTTON

                        GoldButton(
                          text: s.resetPasswordBtn,
                          onPressed: _reset,
                          isLoading: _loading,
                        ),

                        const SizedBox(height: 36),

                        // COMPANY BRANDING

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
      ),
    );
  }

  // FIELD LABEL

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

  // PASSWORD INPUT

  Widget _passwordInput({
    required TextEditingController controller,
    required IconData icon,
    required bool obscure,
    required VoidCallback onToggle,
    required TextInputAction textInputAction,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,

      keyboardType: TextInputType.visiblePassword,
      textInputAction: textInputAction,

      enableSuggestions: false,
      autocorrect: false,

      autofillHints: const [
        AutofillHints.newPassword,
      ],

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

        suffixIcon: IconButton(
          onPressed: onToggle,

          icon: Icon(
            obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,

            color: AppColors.textSecondary,
            size: 21,
          ),
        ),

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
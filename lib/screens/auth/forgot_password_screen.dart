import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/auth_api.dart';
import '../../localization/strings_ext.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_gradients.dart';

import '../../widgets/gold_button.dart';
import '../../widgets/app_background.dart';

import 'verify_code_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {

  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  // SEND VERIFICATION CODE

  Future<void> _sendCode() async {
    if (_loading) return;
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final email =
      _emailCtrl.text.trim().toLowerCase();

      await AuthApi.forgotPassword(email);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VerifyCodeScreen(
            email: email,
          ),
        ),
      );
    } catch (e) {
      debugPrint('FORGOT PASSWORD ERROR: $e');

      if (!mounted) return;

      setState(() {
        _error = context.stringsRead.failedToSendCode;
      });
    }finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  // FORGOT PASSWORD DESIGN

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
                          height: 160,
                          fit: BoxFit.contain,
                        ),

                        const SizedBox(height: 4),

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

                        Text(
                          s.appTagline,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.gold,
                            fontSize: 13,
                            letterSpacing: 0.5,
                          ),
                        ),

                        const SizedBox(height: 36),

                        // PASSWORD RECOVERY ICON

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
                          s.forgotPassword,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // INSTRUCTIONS

                        Text(
                          s.forgotPasswordHint,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                            height: 1.6,
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

                        // EMAIL LABEL

                        Align(
                          alignment:
                          AlignmentDirectional.centerStart,
                          child: Text(
                            s.emailAddressLabel,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),

                        const SizedBox(height: 9),

                        // EMAIL INPUT

                        TextFormField(
                          controller: _emailCtrl,

                          keyboardType:
                          TextInputType.emailAddress,

                          autofillHints: const [
                            AutofillHints.email,
                          ],

                          cursorColor: AppColors.gold,

                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                          ),

                          validator: (v) {
                            final value = (v ?? '').trim();

                            if (value.isEmpty) {
                              return s.emailRequired;
                            }

                            if (!value.contains('@')) {
                              return s.emailInvalid;
                            }

                            return null;
                          },

                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.surface,

                            contentPadding:
                            const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 19,
                            ),

                            prefixIcon: const Icon(
                              Icons.mail_outline,
                              color: AppColors.gold,
                              size: 21,
                            ),

                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: AppColors.border,
                              ),
                            ),

                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: AppColors.border,
                              ),
                            ),

                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: AppColors.gold,
                                width: 1.4,
                              ),
                            ),

                            errorBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: AppColors.error,
                              ),
                            ),

                            focusedErrorBorder:
                            OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: AppColors.error,
                                width: 1.4,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // SEND CODE BUTTON

                        GoldButton(
                          text: s.sendCodeBtn,
                          onPressed: _sendCode,
                          isLoading: _loading,
                        ),

                        const SizedBox(height: 40),

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
}
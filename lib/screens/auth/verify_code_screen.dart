import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/auth_api.dart';
import '../../localization/strings_ext.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_gradients.dart';

import '../../widgets/gold_button.dart';
import '../../widgets/app_background.dart';

import 'reset_password_screen.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String email;

  const VerifyCodeScreen({
    super.key,
    required this.email,
  });

  @override
  State<VerifyCodeScreen> createState() =>
      _VerifyCodeScreenState();
}

class _VerifyCodeScreenState
    extends State<VerifyCodeScreen> {

  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();

  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  // VERIFY RESET CODE

  Future<void> _verify() async {
    if (_loading) return;
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final token = await AuthApi.verifyResetCode(
        widget.email,
        _codeCtrl.text.trim(),
      );

      if (token.isEmpty) {
        throw Exception('empty token');
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(
            resetSessionToken: token,
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _error = context.stringsRead.invalidOrExpiredCode;
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  // VERIFICATION SCREEN DESIGN

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

                        // VERIFICATION ICON

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
                            Icons.verified_user_outlined,
                            color: AppColors.gold,
                            size: 32,
                          ),
                        ),

                        const SizedBox(height: 18),

                        // VERIFICATION INSTRUCTIONS

                        Text(
                          s.verifyCodeHint,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.6,
                          ),
                        ),

                        const SizedBox(height: 10),

                        // EMAIL ADDRESS

                        Text(
                          widget.email,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.ltr,
                          style: const TextStyle(
                            color: AppColors.gold,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 30),

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

                        // CODE LABEL

                        Align(
                          alignment:
                          AlignmentDirectional.centerStart,
                          child: Text(
                            s.codeLabel,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // VERIFICATION CODE INPUT

                        TextFormField(
                          controller: _codeCtrl,

                          keyboardType: TextInputType.number,

                          textAlign: TextAlign.center,

                          textDirection: TextDirection.ltr,

                          maxLength: 6,

                          autofillHints: const [
                            AutofillHints.oneTimeCode,
                          ],

                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],

                          cursorColor: AppColors.gold,

                          style: const TextStyle(
                            color: AppColors.gold,
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 12,
                          ),

                          validator: (v) {
                            final value = (v ?? '').trim();

                            if (value.isEmpty) {
                              return s.codeRequired;
                            }

                            if (!RegExp(r'^[0-9]{6}$')
                                .hasMatch(value)) {
                              return s.codeMustBe6Digits;
                            }

                            return null;
                          },

                          decoration: InputDecoration(
                            counterText: '',

                            hintText: '000000',

                            hintStyle: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 26,
                              letterSpacing: 12,
                            ),

                            filled: true,
                            fillColor: AppColors.surface,

                            contentPadding:
                            const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 22,
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

                        // VERIFY BUTTON

                        GoldButton(
                          text: s.verifyBtn,
                          onPressed: _verify,
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
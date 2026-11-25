import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../services/auth_api.dart';
import '../../state/auth_state.dart';
import '../main_shell.dart';

import '../../localization/strings_ext.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_gradients.dart';
import '../../widgets/gold_button.dart';
import '../../widgets/app_background.dart';

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
  bool _showPassword = false;
  String? _error;

  // REGISTRATION LOGIC

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

      final code = _familyCodeCtrl.text.trim();
      final familyName = _familyNameCtrl.text.trim();

      if (code.isNotEmpty && familyName.isNotEmpty) {
        setState(() {
          _error =
              context.stringsRead.chooseOnlyOneFamilyCodeOrName;
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
        MaterialPageRoute(
          builder: (_) => const MainShell(),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      final msg = e.toString();

      final cleaned = msg.contains('Email already in use')
          ? 'Email already in use'
          : msg;

      setState(() {
        _error =
        '${context.stringsRead.registerFailedPrefix} $cleaned';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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

  // REGISTRATION DESIGN

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
                  vertical: 16,
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
                          width: 220,
                          height: 125,
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
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 6,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          s.appTagline,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.gold,
                            fontSize: 12,
                            letterSpacing: 0.5,
                          ),
                        ),

                        const SizedBox(height: 26),

                        // ERROR MESSAGE

                        if (_error != null)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(
                              bottom: 18,
                            ),
                            padding: const EdgeInsets.all(12),
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

                        // FULL NAME

                        _label(s.nameLabel),

                        _input(
                          controller: _nameCtrl,
                          icon: Icons.person_outline,
                          keyboardType: TextInputType.name,
                          autofillHints: const [
                            AutofillHints.name,
                          ],
                          validator: (v) =>
                          (v == null || v.trim().isEmpty)
                              ? s.nameRequired
                              : null,
                        ),

                        const SizedBox(height: 18),

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

                        const SizedBox(height: 18),

                        // PASSWORD

                        _label(s.passwordLabel),

                        _input(
                          controller: _passwordCtrl,
                          icon: Icons.lock_outline,
                          obscure: !_showPassword,
                          showToggle: true,
                          autofillHints: const [
                            AutofillHints.newPassword,
                          ],
                          onToggle: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                          validator: (v) =>
                          (v != null && v.length >= 6)
                              ? null
                              : s.passwordMinChars,
                        ),

                        const SizedBox(height: 24),

                        // OPTIONAL FAMILY SECTION

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),

                          decoration: BoxDecoration(
                            color: AppColors.surface.withValues(
                              alpha: 0.92,
                            ),
                            borderRadius:
                            BorderRadius.circular(18),
                            border: Border.all(
                              color: AppColors.gold.withValues(
                                alpha: 0.30,
                              ),
                            ),
                          ),

                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [

                              Row(
                                children: [
                                  const Icon(
                                    Icons.groups_outlined,
                                    color: AppColors.gold,
                                    size: 23,
                                  ),

                                  const SizedBox(width: 10),

                                  Expanded(
                                    child: Text(
                                      s.familySectionTitle,
                                      style: const TextStyle(
                                        color: AppColors.gold,
                                        fontSize: 13,
                                        fontWeight:
                                        FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 18),

                              // JOIN EXISTING GROUP

                              _label(
                                s.familyCodeOptionalLabel,
                              ),

                              _input(
                                controller: _familyCodeCtrl,
                                icon: Icons.key_outlined,
                                hint: s.familyCodeHint,
                              ),

                              const SizedBox(height: 14),

                              // OR DIVIDER

                              Row(
                                children: [
                                  const Expanded(
                                    child: Divider(
                                      color: AppColors.border,
                                    ),
                                  ),

                                  Padding(
                                    padding:
                                    const EdgeInsets.symmetric(
                                      horizontal: 14,
                                    ),
                                    child: Text(
                                      s.orLabel,
                                      style: const TextStyle(
                                        color:
                                        AppColors.textSecondary,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),

                                  const Expanded(
                                    child: Divider(
                                      color: AppColors.border,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 14),

                              // CREATE NEW GROUP

                              _label(
                                s.familyNameOptionalLabel,
                              ),

                              _input(
                                controller: _familyNameCtrl,
                                icon: Icons.group_outlined,
                                hint: s.familyNameHint,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // CREATE ACCOUNT BUTTON

                        GoldButton(
                          text: s.createAccountBtn,
                          onPressed: _submit,
                          isLoading: _isLoading,
                        ),

                        const SizedBox(height: 30),

                        // COMPANY BRANDING

                        const Text(
                          'by HASKI',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            letterSpacing: 3,
                          ),
                        ),

                        const SizedBox(height: 12),
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
    String? hint,
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
        hintText: hint,

        hintStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
        ),

        filled: true,
        fillColor: AppColors.surface,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 17,
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
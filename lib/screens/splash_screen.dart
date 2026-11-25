import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../state/auth_state.dart';
import '../localization/strings_ext.dart';

import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';
import '../widgets/app_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scale = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();

    // Check authentication and navigate

    Future.delayed(
      const Duration(milliseconds: 3000),
          () {
        if (!mounted) return;

        final auth = context.read<AuthState>();

        Navigator.of(context).pushReplacementNamed(
          auth.isLoggedIn ? '/setup' : '/login',
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.strings;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,

      child: Scaffold(
        backgroundColor: AppColors.background,

        body: AppBackground(
          child: SafeArea(
            child: Stack(
              children: [

                // Animated brand logo

                Center(
                  child: FadeTransition(
                    opacity: _fade,

                    child: ScaleTransition(
                      scale: _scale,

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          Image.asset(
                            'assets/duline_logo_new.png',
                            width: 300,
                            height: 200,
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
                                fontSize: 36,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Company branding

                Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,

                  child: FadeTransition(
                    opacity: _fade,

                    child: Text(
                      s.byHaski,
                      textAlign: TextAlign.center,

                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
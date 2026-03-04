import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'firebase_options.dart'; // ✅ إذا موجود عندك
import 'localization/app_strings.dart';

import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/main_shell.dart';
import 'screens/profile_screen.dart';

import 'state/auth_state.dart';
import 'state/group_state.dart';
import 'state/task_state.dart';
import 'state/global_state.dart';

import 'services/api_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ الأفضل تمرير الخيارات (حسب مشروعك)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final auth = AuthState();
  await auth.autoLogin();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: auth),

        // ✅ اللغة لازم تكون GlobalState
        ChangeNotifierProvider(create: (_) => GlobalState()),

        ProxyProvider<AuthState, ApiClient>(
          update: (_, authState, __) => ApiClient(auth: authState),
        ),

        ChangeNotifierProxyProvider<ApiClient, TaskState>(
          create: (context) => TaskState(apiClient: context.read<ApiClient>()),
          update: (_, api, state) => state!..updateApi(api),
        ),

        ChangeNotifierProxyProvider<ApiClient, GroupState>(
          create: (context) => GroupState(apiClient: context.read<ApiClient>()),
          update: (_, api, state) => state!..updateApi(api),
        ),
      ],
      child: const FamilyApp(),
    ),
  );
}

class FamilyApp extends StatelessWidget {
  const FamilyApp({super.key});

  Locale _localeFrom(AppLang lang) {
    switch (lang) {
      case AppLang.de:
        return const Locale('de');
      case AppLang.ar:
        return const Locale('ar');
      case AppLang.en:
      default:
        return const Locale('en');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalState>(
      builder: (_, gs, __) {
        final locale = _localeFrom(gs.currentLang);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'DULINE',
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.teal,
          ),

          // ✅ اللغة
          locale: locale,
          supportedLocales: const [
            Locale('en'),
            Locale('de'),
            Locale('ar'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          initialRoute: '/',
          routes: {
            '/': (_) => const SplashScreen(),
            '/login': (_) => const LoginScreen(),
            '/register': (_) => const RegisterScreen(),
            '/setup': (_) => const MainShell(),
            '/home': (_) => const MainShell(),
            '/profile': (_) => const ProfileScreen(),
          },
        );
      },
    );
  }
}

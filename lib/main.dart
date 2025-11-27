import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shagf/core/app_routes.dart'; 
import 'package:shagf/core/app_theme.dart';
import 'package:shagf/data/services/auth_service.dart'; 
import 'package:shagf/firebase_options.dart';
import 'package:shagf/l10n/app_localizations.dart';
import 'package:shagf/presentation/screens/auth/sign_in_screen.dart';
import 'package:shagf/presentation/screens/home_screen.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        StreamProvider<User?>(
          create: (context) => context.read<AuthService>().user,
          initialData: null,
        ),
      ],
      child: const ShaghafApp(),
    ),
  );
}

class ShaghafApp extends StatelessWidget {
  const ShaghafApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shaghaf',
      theme: AppTheme.lightTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      
        routes: AppRoutes.routes, 
        onGenerateRoute: AppRoutes.onGenerateRoute, 

    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();

    if (user != null) {
      return const HomeScreen();
    } else {
      return const SignInScreen();
    }
  }
}

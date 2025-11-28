import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shagf/core/app_routes.dart';
import 'package:shagf/core/app_theme.dart';
import 'package:shagf/core/locale_provider.dart';
import 'package:shagf/core/theme_provider.dart';
import 'package:shagf/data/services/auth_service.dart';
import 'package:shagf/firebase_options.dart';
import 'package:shagf/l10n/app_localizations.dart' as GenL10n;
import 'package:shagf/presentation/screens/auth/sign_in_screen.dart';
import 'package:shagf/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider<AuthService>(create: (_) => AuthService()),
      ],
      child: const ShaghafApp(),
    ),
  );
}

class ShaghafApp extends StatelessWidget {
  const ShaghafApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shaghaf',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      locale: localeProvider.locale,
      localizationsDelegates: GenL10n.AppLocalizations.localizationsDelegates,
      supportedLocales: GenL10n.AppLocalizations.supportedLocales,
      home: const AuthWrapper(), // ✅ This handles login/logout
      routes: AppRoutes.routes,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}

// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }

//         // If user is null → SignInScreen
//         if (!snapshot.hasData || snapshot.data == null) {
//           return const SignInScreen();
//         }

//         // User is logged in → HomeScreen, pass User as parameter
//         return HomeScreen(user: snapshot.data!);
//       },
//     );
//   }
// }

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;

        if (user == null) {
          return const SignInScreen();
        }

        return HomeScreen(user: user);
      },
    );
  }
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shagf/presentation/screens/auth/NewPasswordScreen.dart';
import 'package:shagf/presentation/screens/auth/reset_password_screen.dart';
import 'package:shagf/presentation/screens/auth/sign_in_screen.dart';
import 'package:shagf/presentation/screens/auth/sign_up_screen.dart';
import 'package:shagf/presentation/screens/auth/verification_screen.dart';
import 'package:shagf/presentation/screens/home/home.dart';

class AppRoutes {
  static const String signIn = '/signIn';
  static const String signUp = '/signUp';
  static const String verification = '/verification';
  static const String resetPassword = '/resetPassword';
  static const String newPassword = '/newPassword';
  static const String home = '/home';

  static final Map<String, WidgetBuilder> routes = {
    signIn: (context) => const SignInScreen(),
    signUp: (context) => const SignUpScreen(),
    resetPassword: (context) => const ResetPasswordScreen(),
    newPassword: (context) => const NewPasswordScreen(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        User? user = settings.arguments as User?;
        user ??= FirebaseAuth.instance.currentUser;
        if (user != null) {
          return MaterialPageRoute(
            builder: (context) => HomeScreen(user: user!),

          );
        }
        return MaterialPageRoute(builder: (_) => const SignInScreen());

      case verification:
        final String? phoneNumber = settings.arguments as String?;
        if (phoneNumber != null) {
          return MaterialPageRoute(
            builder: (context) => VerificationScreen(phoneNumber: phoneNumber, verificationId: ''),
          );
        }
        return _errorRoute(message: 'Phone number was not provided to the verification route.');

      default:
        final builder = routes[settings.name];
        if (builder != null) {
          return MaterialPageRoute(builder: builder);
        }
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute({String message = 'Route not found.'}) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Navigation Error'),
        ),
        body: Center(
          child: Text(message),
        ),
      );
    });
  }
}

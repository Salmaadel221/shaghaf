import 'package:flutter/material.dart';
import 'package:shagf/presentation/screens/auth/NewPasswordScreen.dart';
import 'package:shagf/presentation/screens/auth/reset_password_screen.dart';
import 'package:shagf/presentation/screens/auth/sign_in_screen.dart';
import 'package:shagf/presentation/screens/auth/sign_up_screen.dart';
import 'package:shagf/presentation/screens/auth/verification_screen.dart';
// import 'package:shagf/presentation/screens/home_screen.dart';

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
    // home: (context) => const HomeScreen(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case verification:
        final String? phoneNumber = settings.arguments as String?;
                if (phoneNumber != null) {
          return MaterialPageRoute(
            builder: (context) => VerificationScreen(phoneNumber: phoneNumber, verificationId: '',),
          );
        }
        return _errorRoute(); 

      default:
        return null;
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Something went wrong with the navigation.'),
        ),
      );
    });
  }
}

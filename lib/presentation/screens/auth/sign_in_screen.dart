import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shagf/core/app_routes.dart';
import 'package:shagf/data/services/auth_service.dart';
import 'package:shagf/l10n/app_localizations.dart';
import 'package:shagf/presentation/widgets/custom_button.dart';
import 'package:shagf/presentation/widgets/custom_text_field.dart';
import 'package:shagf/presentation/widgets/remember_me_switch.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

 Future<void> _signIn() async {
  final l10n = AppLocalizations.of(context)!;
  if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.errorEmptyFields),
        backgroundColor: Colors.orange,
      ),
    );
    return;
  }

  if (mounted) setState(() => _isLoading = true);

  try {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = await authService.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    // Debug
    print('DEBUG signIn returned user: $user');
    print('DEBUG Firebase currentUser: ${FirebaseAuth.instance.currentUser}');

    final effectiveUser = user ?? FirebaseAuth.instance.currentUser;

    if (effectiveUser != null) {
      // Navigate to Home and remove all previous routes, pass the User as argument
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
        arguments: effectiveUser,
      );
      print('DEBUG NAVIGATED to HOME with user: ${effectiveUser.uid}');
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign-in succeeded but user is null. Please try again.')),
        );
      }
    }
  } on FirebaseAuthException catch (e) {
    if (!mounted) return;
    String errorMessage;
    switch (e.code) {
      case 'invalid-credential':
        errorMessage = l10n.errorInvalidCredential;
        break;
      case 'invalid-email':
        errorMessage = l10n.errorInvalidEmail;
        break;
      case 'user-disabled':
        errorMessage = l10n.errorUserDisabled;
        break;
      case 'user-not-found':
        errorMessage = l10n.errorInvalidEmail;
        break;
      case 'wrong-password':
        errorMessage = l10n.errorInvalidCredential;
        break;
      default:
        errorMessage = l10n.errorUnexpected;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
    );
  } catch (e) {
    if (!mounted) return;
    print('DEBUG signIn error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.errorNetwork), backgroundColor: Colors.red),
    );
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}



  Future<void> _signInWithGoogle() async {
  if (mounted) setState(() => _isLoading = true);
  try {
    final authService = Provider.of<AuthService>(context, listen: false);
    final User? user = await authService.signInWithGoogle();

    // debug
    print('DEBUG signInWithGoogle returned user: $user');
    print('DEBUG Firebase currentUser: ${FirebaseAuth.instance.currentUser}');

    if (mounted && user != null) {
      // Navigate to home and remove all previous routes, pass the user
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
        arguments: user,
      );
      print('DEBUG NAVIGATED to HOME with google user: ${user.uid}');
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google sign-in cancelled or failed')),
        );
      }
    }
  } catch (e, st) {
    print('ERROR _signInWithGoogle: $e');
    print(st);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google sign-in failed: $e')),
      );
    }
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Image.asset('assets/logo_shagf.png', height: 150),
              const SizedBox(height: 40),
              Text(l10n.signIn, style: textTheme.bodyLarge),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _emailController,
                hintText: l10n.email,
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                hintText: l10n.password,
                prefixIcon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RememberMeSwitch(label: l10n.rememberMe),
                  GestureDetector(
                    onTap: () {
  final email = _emailController.text.trim();

  if (email.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter your email first.'),
        backgroundColor: Colors.orange,
      ),
    );
    return;
  }

  Navigator.pushNamed(
    context,
    AppRoutes.resetPassword,
    arguments: email,
  );
},

                    child: Text(
                      l10n.forgotPassword,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              CustomButton(
                onPressed: _isLoading ? null : _signIn,
                text: '',
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                      )
                    : Text(l10n.signIn.toUpperCase()),
              ),
              const SizedBox(height: 24),
              _buildOrSeparator(context),
              const SizedBox(height: 24),
              _buildGoogleLoginButton(context),
              const SizedBox(height: 32),
              _buildSignUpLink(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrSeparator(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(l10n.or, style: TextStyle(color: Theme.of(context).hintColor)),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildGoogleLoginButton(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return OutlinedButton.icon(
      onPressed: _isLoading ? null : _signInWithGoogle,
      icon: Image.asset('assets/google-tile.png', height: 20),
      label: Text(l10n.loginWithGoogle),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Theme.of(context).hintColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSignUpLink(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(l10n.dontHaveAnAccount, style: Theme.of(context).textTheme.bodyMedium),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRoutes.signUp),
          child: Text(
            l10n.signUp,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

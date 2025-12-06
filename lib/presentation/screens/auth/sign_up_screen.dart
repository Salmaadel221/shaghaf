import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shagf/core/app_routes.dart';
import 'package:shagf/data/services/auth_service.dart';
import 'package:shagf/l10n/app_localizations.dart';
import 'package:shagf/presentation/widgets/custom_button.dart';
import 'package:shagf/presentation/widgets/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
  final l10n = AppLocalizations.of(context)!;

  if (_fullNameController.text.trim().isEmpty ||
      _emailController.text.trim().isEmpty ||
      _passwordController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.errorEmptyFields),
        backgroundColor: Colors.orange,
      ),
    );
    return;
  }

  if (mounted) setState(() => _isLoading = true);

  final email = _emailController.text.trim();
  final password = _passwordController.text.trim();

  try {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = await authService.signUp(
      email: email,
      password: password,
      fullName: _fullNameController.text.trim(),
    );

    print('DEBUG signUp returned user: $user');
    print('DEBUG Firebase currentUser after signUp: ${FirebaseAuth.instance.currentUser}');

    // If Firebase didn't sign-in automatically, try sign-in now
    if (FirebaseAuth.instance.currentUser == null) {
      print('DEBUG: currentUser null after signUp — attempting signIn automatically');
      await authService.signIn(email: email, password: password);
      print('DEBUG Firebase currentUser after auto signIn: ${FirebaseAuth.instance.currentUser}');
    }

    final effectiveUser = FirebaseAuth.instance.currentUser;

    if (effectiveUser != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully!')),
        );
        // Navigate to Home (clean stack) and pass user as argument
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.home,
          (route) => false,
          arguments: effectiveUser,
        );
        print('DEBUG NAVIGATED to HOME after signUp with user: ${effectiveUser.uid}');
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created but sign-in failed. Please sign in manually.')),
        );
      }
    }
  } on FirebaseAuthException catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.message ?? l10n.errorUnexpected),
        backgroundColor: Colors.red,
      ),
    );
  } catch (e) {
    print('DEBUG signUp error: $e');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.errorUnexpected),
          backgroundColor: Colors.red,
        ),
      );
    }
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}



Future<void> _signUpWithGoogle() async {
  if (mounted) setState(() => _isLoading = true);
  try {
    final authService = Provider.of<AuthService>(context, listen: false);
    final User? user = await authService.signInWithGoogle();

    print('DEBUG signUpWithGoogle returned user: $user');
    print('DEBUG Firebase currentUser: ${FirebaseAuth.instance.currentUser}');

    if (mounted && user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google login successful!')),
      );
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
        arguments: user,
      );
      print('DEBUG NAVIGATED to HOME (google sign-up) with user: ${user.uid}');
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google sign-in cancelled or failed')),
        );
      }
    }
  } catch (e, st) {
    print('ERROR _signUpWithGoogle: $e');
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
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.signUp, style: textTheme.titleLarge),
            const SizedBox(height: 32),
            CustomTextField(
              controller: _fullNameController,
              hintText: l10n.fullName,
              prefixIcon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 32),
            CustomButton(
              onPressed: _isLoading ? null : _signUp,
              text: '',
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5),
                    )
                  : Text(l10n.signUp.toUpperCase()),
            ),
            const SizedBox(height: 24),
            _buildOrSeparator(context),
            const SizedBox(height: 24),
            _buildGoogleLoginButton(context),
            const SizedBox(height: 32),
            _buildSignInLink(context),
            const SizedBox(height: 24),
          ],
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
      onPressed: _isLoading ? null : _signUpWithGoogle,
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

  Widget _buildSignInLink(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(l10n.alreadyHaveAnAccount, style: Theme.of(context).textTheme.bodyMedium),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Text(
            l10n.signIn,
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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shagf/core/app_routes.dart';
import 'package:shagf/data/services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSigningOut = false;

  Future<void> _handleSignOut() async {
    if (_isSigningOut) return;
    setState(() => _isSigningOut = true);

    try {
      final authService = context.read<AuthService>();
      await authService.signOut();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.signIn, (route) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing out: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSigningOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayName = widget.user.displayName ?? 'No display name';
    final email = widget.user.email ?? 'No email';
    final photoURL = widget.user.photoURL;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home - Test'),
        actions: [
          IconButton(
            icon: _isSigningOut ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.logout),
            onPressed: _isSigningOut ? null : _handleSignOut,
            tooltip: 'Sign out',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (photoURL != null)
              CircleAvatar(radius: 60, backgroundImage: NetworkImage(photoURL))
            else
              CircleAvatar(
                radius: 60,
                child: Text(
                  displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U',
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
            const SizedBox(height: 24),
            Text(displayName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(email, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

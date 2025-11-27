import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shagf/core/app_routes.dart';
import 'package:shagf/data/services/auth_service.dart';

class PhoneInputScreen extends StatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final phoneController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Phone Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: "Phone Number",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading
                  ? null
                  : () {
                      _sendOTP();
                    },
              child: loading ? const CircularProgressIndicator() : const Text("Send OTP"),
            )
          ],
        ),
      ),
    );
  }

  void _sendOTP() async {
    setState(() => loading = true);

    final auth = Provider.of<AuthService>(context, listen: false);

    await auth.sendOTP(
      phone: phoneController.text.trim(),
      onCodeSent: (verificationId) {
        setState(() => loading = false);

        Navigator.pushNamed(
          context,
          AppRoutes.verification,
          arguments: verificationId,
        );
      },
      onError: (err) {
        setState(() => loading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err)),
        );
      },
    );
  }
}

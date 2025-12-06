import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shagf/core/app_routes.dart';
import 'package:shagf/l10n/app_localizations.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();

  PhoneNumber _number = PhoneNumber(isoCode: 'EG');
  String? _fullPhoneNumber;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _goToVerification() {
    final l10n = AppLocalizations.of(context)!;

    if (_fullPhoneNumber == null || _fullPhoneNumber!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.errorInvalidPhoneNumber),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      AppRoutes.verification,
      arguments: _fullPhoneNumber!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.resetPassword),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  _fullPhoneNumber = number.phoneNumber;
                },
                selectorConfig: const SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  useBottomSheetSafeArea: true,
                ),
                autoValidateMode: AutovalidateMode.disabled,
                initialValue: _number,
                textFieldController: _phoneController,
                keyboardType: TextInputType.phone,
                inputBorder: const OutlineInputBorder(),
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _goToVerification,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  l10n.sendOTP,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shagf/core/app_routes.dart';
import 'package:shagf/data/services/auth_service.dart';

class VerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const VerificationScreen({Key? key, required this.phoneNumber, required String verificationId}) : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isSendingOTP = true;
  bool _isVerifyingOTP = false;
  String? _verificationId;

  // --- التعديل الأول: اجعل الـ Timer قابلاً للـ null ---
  Timer? _timer; 
  int _start = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _sendOTP();
    // لا داعي لاستدعاء _startTimer هنا، لأن _sendOTP تقوم بذلك بالفعل
  }

  void _startTimer() {
    // إذا كان هناك مؤقت قديم، قم بإلغائه أولاً
    _timer?.cancel();

    setState(() {
      _canResend = false;
      _start = 60;
    });

    // قم بإنشاء مؤقت جديد
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        if (mounted) {
          setState(() {
            _canResend = true;
            timer.cancel();
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _start--;
          });
        }
      }
    });
  }

  void _sendOTP() {
    if (mounted) {
      setState(() {
        _isSendingOTP = true;
      });
    }
    
    // ابدأ العداد مباشرة
    _startTimer(); 

    final authService = Provider.of<AuthService>(context, listen: false);
    authService.sendOTP(
      phone: widget.phoneNumber,
      onCodeSent: (verificationId) {
        if (mounted) {
          setState(() {
            _isSendingOTP = false;
            _verificationId = verificationId;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("OTP sent successfully!"), backgroundColor: Colors.green),
          );
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _isSendingOTP = false;
            _timer?.cancel(); // ألغِ المؤقت عند حدوث خطأ
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error), backgroundColor: Colors.red),
          );
          Navigator.of(context).pop();
        }
      },
    );
  }

  void _verifyOTP() async {
    // ... (باقي هذه الدالة كما هي بدون تغيير)
    if (_verificationId == null || _otpController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the OTP"), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isVerifyingOTP = true);
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.verifyOTP(
        verificationId: _verificationId!,
        smsCode: _otpController.text.trim(),
      );

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.newPassword,
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid or expired OTP"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isVerifyingOTP = false);
      }
    }
  }

  @override
  void dispose() {
    // --- التعديل الثاني: استخدم `?.` للتأكد من أن المؤقت ليس null ---
    _timer?.cancel(); 
    _otpController.dispose();
    super.dispose();
  }

  // ... (دالة build تبقى كما هي بدون تغيير)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter Verification Code")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "We've sent a 6-digit code to\n${widget.phoneNumber}",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.grey.shade700, height: 1.5),
            ),
            const SizedBox(height: 40),
            if (_isSendingOTP)
              const Center(child: CircularProgressIndicator())
            else
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 6,
                style: const TextStyle(fontSize: 24, letterSpacing: 10),
                decoration: const InputDecoration(
                  counterText: "",
                  hintText: "------",
                  border: OutlineInputBorder(),
                ),
              ),
            const SizedBox(height: 20),
            _canResend
                ? TextButton(
                    onPressed: _sendOTP,
                    child: const Text("Resend Code"),
                  )
                : Text(
                    "Resend code in 0:${_start.toString().padLeft(2, '0')}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onPressed: (_isSendingOTP || _isVerifyingOTP) ? null : _verifyOTP,
              child: _isVerifyingOTP
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                    )
                  : const Text("Verify & Proceed"),
            ),
          ],
        ),
      ),
    );
  }
}

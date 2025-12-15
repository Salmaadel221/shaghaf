
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shagf/presentation/screens/booking/booking_selection.dart';

class PaymentMethodsScreen extends StatefulWidget {
  final String branchId;
  final double totalAmount;
  final List<BookingSelection> bookings;
  final List<String> roomIds;

  const PaymentMethodsScreen({
    super.key,
    required this.branchId,
    required this.totalAmount,
    required this.bookings,
    required this.roomIds,
  });

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _instaPayImage;
  File? _vodafoneCashImage;

  Future<void> _pickImage(String paymentMethod) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          if (paymentMethod == 'instapay') {
            _instaPayImage = File(image.path);
          } else if (paymentMethod == 'vodafone') {
            _vodafoneCashImage = File(image.path);
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في اختيار الصورة: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _payWithInstaPay() {
    if (_instaPayImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء رفع صورة إيصال الدفع أولاً'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إرسال إيصال الدفع بنجاح! في انتظار التأكيد'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).popUntil((route) => route.isFirst);
    });
  }

  void _payWithVodafoneCash() {
    if (_vodafoneCashImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء رفع صورة إيصال الدفع أولاً'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إرسال إيصال الدفع بنجاح! في انتظار التأكيد'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).popUntil((route) => route.isFirst);
    });
  }

  void _copyPhoneNumber() {
    Clipboard.setData(const ClipboardData(text: '+20106090879'));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نسخ رقم الهاتف'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5C7363),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),

                      // Phone Number Section
                      _buildPhoneNumberSection(),

                      const SizedBox(height: 20),

                      // InstaPay Card
                      _buildPaymentCard(
                        title: 'InstaPay',
                        subtitle: 'Mobile payment',
                        logoWidget: _buildInstaPayLogo(),
                        uploadedImage: _instaPayImage,
                        onUploadPressed: () => _pickImage('instapay'),
                        onPayPressed: _payWithInstaPay,
                        buttonText: 'Pay with InstaPay',
                      ),

                      const SizedBox(height: 20),

                      // Vodafone Cash Card
                      _buildPaymentCard(
                        title: 'Vodafone Cash',
                        subtitle: 'Mobile payment',
                        logoWidget: _buildVodafoneLogo(),
                        uploadedImage: _vodafoneCashImage,
                        onUploadPressed: () => _pickImage('vodafone'),
                        onPayPressed: _payWithVodafoneCash,
                        buttonText: 'Pay with Vodafone Cash',
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          // زر الرجوع
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFF1D4036),
              size: 24,
            ),
          ),

          const SizedBox(width: 10),

          // العنوان
          const Expanded(
            child: Text(
              'Payment Methods',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D4036),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneNumberSection() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF1D4036),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Pay Via  ',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              color: Color(0xFFF2F0D9),
            ),
          ),
          const Text(
            '+20106090879',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              color: Color(0xFF5669FF),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _copyPhoneNumber,
            child: const Icon(Icons.copy, color: Color(0xFFF2F0D9), size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard({
    required String title,
    required String subtitle,
    required Widget logoWidget,
    required File? uploadedImage,
    required VoidCallback onUploadPressed,
    required VoidCallback onPayPressed,
    required String buttonText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1D4036),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          // Header with Logo and Title
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                // Logo Container
                Container(
                  width: 47,
                  height: 49,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.17),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Center(child: logoWidget),
                ),
                const SizedBox(width: 15),
                // Title and Subtitle
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 24,
                        color: Color(0xFFF2F0D9),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        color: Color(0xFFF2F0D9),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Upload Area
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: GestureDetector(
              onTap: onUploadPressed,
              child: Container(
                height: 103,
                decoration: BoxDecoration(
                  color: uploadedImage == null
                      ? Colors.white.withOpacity(0.17)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: uploadedImage == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Cloud Upload Icon
                          Icon(
                            Icons.cloud_upload_outlined,
                            size: 50,
                            color: const Color(0xFFF2F0D9).withOpacity(0.8),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Upload photo here',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15,
                              color: Color(0xFFF2F0D9),
                            ),
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: Image.file(
                          uploadedImage,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          // Pay Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: SizedBox(
              width: double.infinity,
              height: 35,
              child: ElevatedButton(
                onPressed: onPayPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5C7363),
                  foregroundColor: const Color(0xFFF2F0D9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(fontFamily: 'Inter', fontSize: 15),
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _buildInstaPayLogo() {
    return Container(
      padding: const EdgeInsets.all(6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // IP Text
          const Text(
            'IP',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF2F0D9),
            ),
          ),
          // Lines below
          Container(width: 20, height: 2, color: const Color(0xFFF2F0D9)),
        ],
      ),
    );
  }

  Widget _buildVodafoneLogo() {
    return Container(
      width: 35,
      height: 35,
      decoration: const BoxDecoration(
        color: Color(0xFFE10000),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shagf/core/app_routes.dart';
import 'package:shagf/data/services/api_service.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _personalIdController = TextEditingController();

  bool _isSaving = false;
  String? _profileImageUrl;
  File? _localImageFile;

  @override
  void initState() {
    super.initState();
    _prefillFromFirebase();
  }

  void _prefillFromFirebase() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _emailController.text = user.email ?? "";
      _nameController.text = user.displayName ?? "";
      // لو عندك بيانات إضافية من Firestore ممكن تضيفيها هنا
    }
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);

      if (picked == null) return;

      final file = File(picked.path);

      setState(() {
        _localImageFile = file;
      });

      final url = await ApiService.uploadProfilePicture(file);

      setState(() {
        _profileImageUrl = url;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile picture updated successfully")),
      );
    } catch (e) {
      debugPrint("Error uploading profile picture: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to upload profile picture")),
      );
    }
  }

  Future<void> _onConfirm() async {
    try {
      setState(() {
        _isSaving = true;
      });

      await ApiService.updateUserProfile(
        nameEn: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        personalId: _personalIdController.text.trim(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );
    } catch (e) {
      debugPrint("Error updating user: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update profile")),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final avatarRadius = width * 0.18;
    final buttonHeight = height * 0.07;
    final horizPadding = width * 0.15;

    ImageProvider avatarImage;

    if (_localImageFile != null) {
      avatarImage = FileImage(_localImageFile!);
    } else if (_profileImageUrl != null && _profileImageUrl!.isNotEmpty) {
      avatarImage = NetworkImage(_profileImageUrl!);
    } else {
      avatarImage =
          const AssetImage("assets/blank-profile-picture-973460_1280.png");
    }

    return Scaffold(
      extendBody: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: height * 0.01),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: avatarRadius,
                    backgroundImage: avatarImage,
                  ),
                ),
                SizedBox(height: height * 0.015),
                TextButton(
                  onPressed: _pickAndUploadImage,
                  child: Text(
                    "Change Profile Picture",
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: Colors.blue,
                      fontSize: width * 0.04,
                    ),
                  ),
                ),

                // Inputs
                buildInput(
                  theme,
                  Icons.person_outline,
                  "Edit Name",
                  width,
                  controller: _nameController,
                ),
                buildInput(
                  theme,
                  Icons.email_outlined,
                  "Email",
                  width,
                  controller: _emailController,
                ),
                buildInput(
                  theme,
                  Icons.phone_outlined,
                  "Phone Number",
                  width,
                  controller: _phoneController,
                ),
                buildInput(
                  theme,
                  TeenyIcons.id,
                  "Personal ID",
                  width,
                  controller: _personalIdController,
                ),

                SizedBox(height: height * 0.03),

                // Confirm Button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizPadding),
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      minimumSize: Size(double.infinity, buttonHeight),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(width * 0.03),
                      ),
                    ),
                    child: _isSaving
                        ? const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text(
                            "Confirm",
                            style: theme.textTheme.titleMedium!.copyWith(
                              color: theme.colorScheme.surface,
                              fontSize: width * 0.045,
                            ),
                          ),
                  ),
                ),

                SizedBox(height: height * 0.02),

                // Logout Button (نفس اللي عندك)
               Padding(
  padding: EdgeInsets.symmetric(horizontal: horizPadding),
  child: ElevatedButton(
    onPressed: () {
      showDialog(
        context: context,
        builder: (context) =>
            buildLogoutDialog(context, theme, width),
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.primary,
      minimumSize: Size(double.infinity, buttonHeight),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(width * 0.03),
      ),
    ),
    child: Text(
      "Log out",
      style: theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.surface,
        fontSize: width * 0.045,
      ),
    ),
  ),
)

              ],
            ),
          ),
        ),
      ),
    );
  }

  // ------------- INPUT WIDGET ----------------
  Widget buildInput(
    ThemeData theme,
    IconData icon,
    String hint,
    double width, {
    required TextEditingController controller,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        right: width * 0.09,
        left: width * 0.09,
        bottom: width * 0.07,
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: width * 0.045),
        decoration: InputDecoration(
          filled: true,
          fillColor: theme.canvasColor,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(width * 0.03),
          ),
          prefixIcon:
              Icon(icon, color: theme.colorScheme.primary, size: width * 0.065),
          hintText: hint,
          hintStyle: TextStyle(
            color: theme.colorScheme.primary,
            fontSize: width * 0.045,
          ),
        ),
      ),
    );
  }

  // ------------- LOGOUT DIALOG ----------------
  Widget buildLogoutDialog(
      BuildContext context, ThemeData theme, double width) {
    return AlertDialog(
  backgroundColor: theme.scaffoldBackgroundColor,
  title: Text(
    "Log out",
    style: TextStyle(
      color: theme.textTheme.bodyMedium!.color,
      fontSize: width * 0.05,
    ),
  ),
  content: Text(
    "Are you sure you want to log out?",
    style: TextStyle(
      color: theme.textTheme.bodyMedium!.color,
      fontSize: width * 0.043,
    ),
  ),
  actions: [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.surface,
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "Cancel",
            style: TextStyle(fontSize: width * 0.04),
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: theme.colorScheme.surface,
          ),
          onPressed: () async {
            // ✅ 1. Logout from Firebase
            await FirebaseAuth.instance.signOut();

            // ✅ 2. Close dialog
            Navigator.of(context).pop();

            // ✅ 3. Navigate to Login & clear stack
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.signIn,
              (route) => false,
            );
          },
          child: Text(
            "Log out",
            style: TextStyle(fontSize: width * 0.04),
          ),
        ),
      ],
    ),
  ],
);

  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _personalIdController.dispose();
    super.dispose();
  }
}

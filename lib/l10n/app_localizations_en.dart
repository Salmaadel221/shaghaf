import 'app_localizations.dart';
/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get shaghaf => 'Shaghaf';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signOut => 'Sign Out';

  @override
  String get toggleTheme => 'Toggle Theme';

  @override
  String get confirm => 'Confirm';

  @override
  String get verify => 'Verify';

  @override
  String get sendOTP => 'Send OTP';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get yourPassword => 'Your password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get fullName => 'Full Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get rememberMe => 'Remember Me';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get loginWithGoogle => 'Login with Google';

  @override
  String get dontHaveAnAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAnAccount => 'Already have an account?';

  @override
  String get or => 'OR';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get pleaseEnterNewPassword => 'Please Enter A New Password';

  @override
  String get enterVerificationCode => 'Enter Verification Code';

  @override
  String weSentCodeTo(String phoneNumber) {
    return 'We\'ve sent a 6-digit code to\n$phoneNumber';
  }

  @override
  String resendCodeIn(String seconds) {
    return 'Resend code in 0:$seconds';
  }

  @override
  String get resendCode => 'Resend Code';

  @override
  String get verifyAndProceed => 'Verify & Proceed';

  @override
  String get home => 'Home';

  @override
  String get toggleLanguage => 'Toggle Language';

  @override
  String get errorInvalidCredential =>
      'Incorrect email or password. Please try again.';

  @override
  String get errorInvalidEmail => 'The email address is badly formatted.';

  @override
  String get errorUserDisabled => 'This user account has been disabled.';

  @override
  String get errorUnexpected =>
      'An unexpected error occurred. Please try again later.';

  @override
  String get errorNetwork =>
      'An error occurred. Please check your connection and try again.';

  @override
  String get errorEmptyFields => 'Please fill in all required fields.';

  @override
  String get errorPasswordsDoNotMatch => 'Passwords do not match.';

  @override
  String get errorInvalidPhoneNumber => 'Please enter a valid phone number.';

  @override
  String get errorInvalidOTP => 'Invalid or expired OTP.';

  @override
  String get successOTPSent => 'OTP sent successfully!';

  @override
  String get successPasswordUpdate =>
      'Password updated successfully! Please sign in again.';

  @override
  String get passwordResetEmailSent => 'Password reset email sent.';

  @override
  String get resetPasswordEmailIntro => 'A reset email will be sent to:';

  @override
  String get resetPasswordEnterEmail => 'Enter your email to reset password';

  @override
  String get sendResetLink => 'Send reset link';

  @override
  String get backToSignIn => 'Back to Sign In';
}

import 'app_localizations.dart';


/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get shaghaf => 'شغف';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get toggleTheme => 'تغيير المظهر';

  @override
  String get confirm => 'تأكيد';

  @override
  String get verify => 'تحقق';

  @override
  String get sendOTP => 'إرسال الكود';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get yourPassword => 'كلمة المرور الخاصة بك';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get rememberMe => 'تذكرني';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get loginWithGoogle => 'تسجيل الدخول عبر جوجل';

  @override
  String get dontHaveAnAccount => 'ليس لديك حساب؟';

  @override
  String get alreadyHaveAnAccount => 'لديك حساب بالفعل؟';

  @override
  String get or => 'أو';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get newPassword => 'كلمة مرور جديدة';

  @override
  String get pleaseEnterNewPassword => 'يرجى إدخال كلمة مرور جديدة';

  @override
  String get enterVerificationCode => 'أدخل رمز التحقق';

  @override
  String weSentCodeTo(String phoneNumber) {
    return 'لقد أرسلنا رمزًا مكوّنًا من 6 أرقام إلى\n$phoneNumber';
  }

  @override
  String resendCodeIn(String seconds) {
    return 'إعادة إرسال الكود خلال 0:$seconds';
  }

  @override
  String get resendCode => 'إعادة إرسال الكود';

  @override
  String get verifyAndProceed => 'تحقق واستمر';

  @override
  String get home => 'الرئيسية';

  @override
  String get toggleLanguage => 'تغيير اللغة';

  @override
  String get errorInvalidCredential =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة.';

  @override
  String get errorInvalidEmail => 'صيغة البريد الإلكتروني غير صحيحة.';

  @override
  String get errorUserDisabled => 'هذا الحساب تم تعطيله.';

  @override
  String get errorUnexpected => 'حدث خطأ غير متوقع. يرجى المحاولة لاحقاً.';

  @override
  String get errorNetwork => 'حدث خطأ. تحقق من اتصال الإنترنت وحاول مرة أخرى.';

  @override
  String get errorEmptyFields => 'يرجى ملء جميع الحقول المطلوبة.';

  @override
  String get errorPasswordsDoNotMatch => 'كلمتا المرور غير متطابقتين.';

  @override
  String get errorInvalidPhoneNumber => 'يرجى إدخال رقم هاتف صحيح.';

  @override
  String get errorInvalidOTP => 'رمز التحقق غير صحيح أو منتهي.';

  @override
  String get successOTPSent => 'تم إرسال رمز التحقق بنجاح!';

  @override
  String get successPasswordUpdate =>
      'تم تحديث كلمة المرور بنجاح! يرجى تسجيل الدخول مجددًا.';

  @override
  String get passwordResetEmailSent =>
      'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك.';

  @override
  String get resetPasswordEmailIntro => 'سيتم إرسال رابط إعادة التعيين إلى:';

  @override
  String get resetPasswordEnterEmail =>
      'أدخل بريدك الإلكتروني لإعادة تعيين كلمة المرور';

  @override
  String get sendResetLink => 'إرسال الرابط';

  @override
  String get backToSignIn => 'العودة لتسجيل الدخول';
}

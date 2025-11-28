// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

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
  String get toggleTheme => 'تغيير الثيم';

  @override
  String get confirm => 'تأكيد';

  @override
  String get verify => 'تحقق';

  @override
  String get sendOTP => 'إرسال الرمز';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get yourPassword => 'كلمة المرور';

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
  String get loginWithGoogle => 'الدخول باستخدام جوجل';

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
  String get pleaseEnterNewPassword => 'الرجاء إدخال كلمة مرور جديدة';

  @override
  String get enterVerificationCode => 'أدخل رمز التحقق';

  @override
  String weSentCodeTo(String phoneNumber) {
    return 'لقد أرسلنا رمزاً مكوناً من 6 أرقام إلى\n$phoneNumber';
  }

  @override
  String resendCodeIn(String seconds) {
    return 'إعادة إرسال الرمز خلال 0:$seconds';
  }

  @override
  String get resendCode => 'إعادة إرسال الرمز';

  @override
  String get verifyAndProceed => 'تحقق واستمر';

  @override
  String get home => 'الرئيسية';

  @override
  String get toggleLanguage => 'تغيير اللغة';

  @override
  String get errorInvalidCredential =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة. الرجاء المحاولة مرة أخرى.';

  @override
  String get errorInvalidEmail => 'صيغة البريد الإلكتروني غير صالحة.';

  @override
  String get errorUserDisabled => 'تم تعطيل حساب المستخدم هذا.';

  @override
  String get errorUnexpected =>
      'حدث خطأ غير متوقع. الرجاء المحاولة مرة أخرى لاحقاً.';

  @override
  String get errorNetwork =>
      'حدث خطأ. الرجاء التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى.';

  @override
  String get errorEmptyFields => 'الرجاء ملء جميع الحقول المطلوبة.';

  @override
  String get errorPasswordsDoNotMatch => 'كلمتا المرور غير متطابقتين.';

  @override
  String get errorInvalidPhoneNumber => 'الرجاء إدخال رقم هاتف صحيح.';

  @override
  String get errorInvalidOTP => 'رمز التحقق غير صالح أو انتهت صلاحيته.';

  @override
  String get successOTPSent => 'تم إرسال الرمز بنجاح!';

  @override
  String get successPasswordUpdate =>
      'تم تحديث كلمة المرور بنجاح! الرجاء تسجيل الدخول مرة أخرى.';
}

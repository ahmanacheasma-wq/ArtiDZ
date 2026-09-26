// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'ArtisDZ';

  @override
  String get appSlogan => 'الحرف الجزائرية الأصيلة';

  @override
  String get heroTitle1 => 'ابحث عن';

  @override
  String get heroTitle2 => 'حرفي';

  @override
  String get heroTitle3 => 'في الجزائر';

  @override
  String get heroSimple => 'بسيط';

  @override
  String get heroRapide => 'سريع';

  @override
  String get heroWilayas => '58 ولاية';

  @override
  String get searchTitle => 'ابحث عن حرفي';

  @override
  String get searchWilaya => 'اختر الولاية...';

  @override
  String get searchMetier => 'اختر المهنة...';

  @override
  String get searchBtn => 'بحث';

  @override
  String searchBtnWith(String metier, String wilaya) {
    return 'بحث عن $metier في $wilaya';
  }

  @override
  String get metiersTitle => 'المهن الشائعة';

  @override
  String get bannerArtisan => 'هل أنت حرفي ؟';

  @override
  String get bannerInscrire => 'سجّل\nمجاناً';

  @override
  String get authBienvenue => 'مرحباً\nبعودتك';

  @override
  String get authSoustitre => 'سجّل الدخول لحجز حرفييك';

  @override
  String get authEmail => 'البريد الإلكتروني';

  @override
  String get authPassword => 'كلمة المرور';

  @override
  String get authForgot => 'نسيت كلمة المرور ؟';

  @override
  String get authLogin => 'تسجيل الدخول';

  @override
  String get authNoAccount => 'ليس لديك حساب ؟ ';

  @override
  String get authSignup => 'إنشاء حساب';

  @override
  String get authOr => 'أو تابع باستخدام';

  @override
  String get signupTitle => 'إنشاء\nحسابك';

  @override
  String get signupSous => 'انضم إلى آلاف الجزائريين';

  @override
  String get signupClient => '👤  عميل';

  @override
  String get signupArtisan => '⚒️  حرفي';

  @override
  String get signupNom => 'اللقب';

  @override
  String get signupPrenom => 'الاسم';

  @override
  String get signupPhone => 'رقم الهاتف';

  @override
  String get signupBtnClient => 'إنشاء حسابي';

  @override
  String get signupBtnArtisan => '⚒️  إنشاء حساب حرفي';

  @override
  String get signupHasAccount => 'لديك حساب بالفعل ؟ ';

  @override
  String get signupConnect => 'تسجيل الدخول';

  @override
  String get signupCGU => 'أوافق على شروط استخدام ArtisDZ';

  @override
  String get resultatSelect => 'اختر';

  @override
  String resultatDesc(String wilaya) {
    return 'أفضل الحرفيين في محيط $wilaya';
  }

  @override
  String get resultatPrestations => 'الخدمات';

  @override
  String get resultatCarte => 'الخريطة';

  @override
  String get resultatFiltres => 'تصفية';

  @override
  String get resultatReserver => 'احجز';

  @override
  String get resultatNotifier => 'أشعرني';

  @override
  String get resultatTrier => 'ترتيب حسب';

  @override
  String get resultatReinit => 'إعادة تعيين';

  @override
  String get resultatProchain => 'الموعد القادم';

  @override
  String get langTitle => 'اختر اللغة';

  @override
  String get onboardNext => 'التالي';

  @override
  String get onboardStart => 'ابدأ';

  @override
  String get onboardSkip => 'تخطى';

  @override
  String get validWilaya => 'الرجاء اختيار ولاية';

  @override
  String get validMetier => 'الرجاء اختيار مهنة';

  @override
  String get validBoth => 'الرجاء اختيار ولاية ومهنة';
}

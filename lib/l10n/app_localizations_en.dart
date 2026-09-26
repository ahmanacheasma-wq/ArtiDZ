// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'ArtisDZ';

  @override
  String get appSlogan => 'Authentic Algerian Crafts';

  @override
  String get heroTitle1 => 'Find a';

  @override
  String get heroTitle2 => 'craftsman';

  @override
  String get heroTitle3 => 'in Algeria';

  @override
  String get heroSimple => 'Simple';

  @override
  String get heroRapide => 'Fast';

  @override
  String get heroWilayas => '58 wilayas';

  @override
  String get searchTitle => 'FIND A CRAFTSMAN';

  @override
  String get searchWilaya => 'Choose a wilaya...';

  @override
  String get searchMetier => 'Choose a trade...';

  @override
  String get searchBtn => 'Search';

  @override
  String searchBtnWith(String metier, String wilaya) {
    return 'Search $metier in $wilaya';
  }

  @override
  String get metiersTitle => 'POPULAR TRADES';

  @override
  String get bannerArtisan => 'ARE YOU A CRAFTSMAN?';

  @override
  String get bannerInscrire => 'Register\nfor free';

  @override
  String get authBienvenue => 'Welcome\nback';

  @override
  String get authSoustitre => 'Sign in to book your craftsmen';

  @override
  String get authEmail => 'Email address';

  @override
  String get authPassword => 'Password';

  @override
  String get authForgot => 'Forgot password?';

  @override
  String get authLogin => 'Sign in';

  @override
  String get authNoAccount => 'No account yet? ';

  @override
  String get authSignup => 'Sign up';

  @override
  String get authOr => 'or continue with';

  @override
  String get signupTitle => 'Create your\naccount';

  @override
  String get signupSous => 'Join thousands of Algerians';

  @override
  String get signupClient => '👤  Client';

  @override
  String get signupArtisan => '⚒️  Craftsman';

  @override
  String get signupNom => 'Last name';

  @override
  String get signupPrenom => 'First name';

  @override
  String get signupPhone => 'Phone number';

  @override
  String get signupBtnClient => 'Create my account';

  @override
  String get signupBtnArtisan => '⚒️  Create craftsman account';

  @override
  String get signupHasAccount => 'Already have an account? ';

  @override
  String get signupConnect => 'Sign in';

  @override
  String get signupCGU => 'I accept ArtisDZ terms of use';

  @override
  String get resultatSelect => 'Select a';

  @override
  String resultatDesc(String wilaya) {
    return 'Best craftsmen around $wilaya';
  }

  @override
  String get resultatPrestations => 'Services';

  @override
  String get resultatCarte => 'Map';

  @override
  String get resultatFiltres => 'Filters';

  @override
  String get resultatReserver => 'Book';

  @override
  String get resultatNotifier => 'Notify me';

  @override
  String get resultatTrier => 'SORT BY';

  @override
  String get resultatReinit => 'Reset';

  @override
  String get resultatProchain => 'Next slot';

  @override
  String get langTitle => 'Choose language';

  @override
  String get onboardNext => 'Next';

  @override
  String get onboardStart => 'Get started';

  @override
  String get onboardSkip => 'Skip';

  @override
  String get validWilaya => 'Please choose a wilaya';

  @override
  String get validMetier => 'Please choose a trade';

  @override
  String get validBoth => 'Please choose a wilaya and a trade';
}

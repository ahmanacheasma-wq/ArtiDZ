import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @appName.
  ///
  /// In fr, this message translates to:
  /// **'ArtisDZ'**
  String get appName;

  /// No description provided for @appSlogan.
  ///
  /// In fr, this message translates to:
  /// **'الحرف الجزائرية الأصيلة'**
  String get appSlogan;

  /// No description provided for @heroTitle1.
  ///
  /// In fr, this message translates to:
  /// **'Trouvez un'**
  String get heroTitle1;

  /// No description provided for @heroTitle2.
  ///
  /// In fr, this message translates to:
  /// **'artisan'**
  String get heroTitle2;

  /// No description provided for @heroTitle3.
  ///
  /// In fr, this message translates to:
  /// **'en Algérie'**
  String get heroTitle3;

  /// No description provided for @heroSimple.
  ///
  /// In fr, this message translates to:
  /// **'Simple'**
  String get heroSimple;

  /// No description provided for @heroRapide.
  ///
  /// In fr, this message translates to:
  /// **'Rapide'**
  String get heroRapide;

  /// No description provided for @heroWilayas.
  ///
  /// In fr, this message translates to:
  /// **'58 wilayas'**
  String get heroWilayas;

  /// No description provided for @searchTitle.
  ///
  /// In fr, this message translates to:
  /// **'TROUVER UN ARTISAN'**
  String get searchTitle;

  /// No description provided for @searchWilaya.
  ///
  /// In fr, this message translates to:
  /// **'Choisir une wilaya...'**
  String get searchWilaya;

  /// No description provided for @searchMetier.
  ///
  /// In fr, this message translates to:
  /// **'Choisir un métier...'**
  String get searchMetier;

  /// No description provided for @searchBtn.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher'**
  String get searchBtn;

  /// No description provided for @searchBtnWith.
  ///
  /// In fr, this message translates to:
  /// **'Chercher {metier} à {wilaya}'**
  String searchBtnWith(String metier, String wilaya);

  /// No description provided for @metiersTitle.
  ///
  /// In fr, this message translates to:
  /// **'MÉTIERS POPULAIRES'**
  String get metiersTitle;

  /// No description provided for @bannerArtisan.
  ///
  /// In fr, this message translates to:
  /// **'VOUS ÊTES ARTISAN ?'**
  String get bannerArtisan;

  /// No description provided for @bannerInscrire.
  ///
  /// In fr, this message translates to:
  /// **'Inscrivez-vous\ngratuitement'**
  String get bannerInscrire;

  /// No description provided for @authBienvenue.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue\nde retour'**
  String get authBienvenue;

  /// No description provided for @authSoustitre.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous pour réserver vos artisans'**
  String get authSoustitre;

  /// No description provided for @authEmail.
  ///
  /// In fr, this message translates to:
  /// **'Adresse e-mail'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get authPassword;

  /// No description provided for @authForgot.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié ?'**
  String get authForgot;

  /// No description provided for @authLogin.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get authLogin;

  /// No description provided for @authNoAccount.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de compte ? '**
  String get authNoAccount;

  /// No description provided for @authSignup.
  ///
  /// In fr, this message translates to:
  /// **'S\'inscrire'**
  String get authSignup;

  /// No description provided for @authOr.
  ///
  /// In fr, this message translates to:
  /// **'ou continuer avec'**
  String get authOr;

  /// No description provided for @signupTitle.
  ///
  /// In fr, this message translates to:
  /// **'Créer votre\ncompte'**
  String get signupTitle;

  /// No description provided for @signupSous.
  ///
  /// In fr, this message translates to:
  /// **'Rejoignez des milliers d\'Algériens'**
  String get signupSous;

  /// No description provided for @signupClient.
  ///
  /// In fr, this message translates to:
  /// **'👤  Client'**
  String get signupClient;

  /// No description provided for @signupArtisan.
  ///
  /// In fr, this message translates to:
  /// **'⚒️  Artisan'**
  String get signupArtisan;

  /// No description provided for @signupNom.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get signupNom;

  /// No description provided for @signupPrenom.
  ///
  /// In fr, this message translates to:
  /// **'Prénom'**
  String get signupPrenom;

  /// No description provided for @signupPhone.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de téléphone'**
  String get signupPhone;

  /// No description provided for @signupBtnClient.
  ///
  /// In fr, this message translates to:
  /// **'Créer mon compte'**
  String get signupBtnClient;

  /// No description provided for @signupBtnArtisan.
  ///
  /// In fr, this message translates to:
  /// **'⚒️  Créer mon compte artisan'**
  String get signupBtnArtisan;

  /// No description provided for @signupHasAccount.
  ///
  /// In fr, this message translates to:
  /// **'Déjà un compte ? '**
  String get signupHasAccount;

  /// No description provided for @signupConnect.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get signupConnect;

  /// No description provided for @signupCGU.
  ///
  /// In fr, this message translates to:
  /// **'J\'accepte les conditions d\'utilisation d\'ArtisDZ'**
  String get signupCGU;

  /// No description provided for @resultatSelect.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez un'**
  String get resultatSelect;

  /// No description provided for @resultatDesc.
  ///
  /// In fr, this message translates to:
  /// **'Les meilleurs artisans aux alentours de {wilaya}'**
  String resultatDesc(String wilaya);

  /// No description provided for @resultatPrestations.
  ///
  /// In fr, this message translates to:
  /// **'Prestations'**
  String get resultatPrestations;

  /// No description provided for @resultatCarte.
  ///
  /// In fr, this message translates to:
  /// **'Carte'**
  String get resultatCarte;

  /// No description provided for @resultatFiltres.
  ///
  /// In fr, this message translates to:
  /// **'Filtres'**
  String get resultatFiltres;

  /// No description provided for @resultatReserver.
  ///
  /// In fr, this message translates to:
  /// **'Réserver'**
  String get resultatReserver;

  /// No description provided for @resultatNotifier.
  ///
  /// In fr, this message translates to:
  /// **'Notifier'**
  String get resultatNotifier;

  /// No description provided for @resultatTrier.
  ///
  /// In fr, this message translates to:
  /// **'TRIER PAR'**
  String get resultatTrier;

  /// No description provided for @resultatReinit.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser'**
  String get resultatReinit;

  /// No description provided for @resultatProchain.
  ///
  /// In fr, this message translates to:
  /// **'Prochain créneau'**
  String get resultatProchain;

  /// No description provided for @langTitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisir la langue'**
  String get langTitle;

  /// No description provided for @onboardNext.
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get onboardNext;

  /// No description provided for @onboardStart.
  ///
  /// In fr, this message translates to:
  /// **'Commencer'**
  String get onboardStart;

  /// No description provided for @onboardSkip.
  ///
  /// In fr, this message translates to:
  /// **'Passer'**
  String get onboardSkip;

  /// No description provided for @validWilaya.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez choisir une wilaya'**
  String get validWilaya;

  /// No description provided for @validMetier.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez choisir un métier'**
  String get validMetier;

  /// No description provided for @validBoth.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez choisir une wilaya et un métier'**
  String get validBoth;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

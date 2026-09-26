// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'ArtisDZ';

  @override
  String get appSlogan => 'الحرف الجزائرية الأصيلة';

  @override
  String get heroTitle1 => 'Trouvez un';

  @override
  String get heroTitle2 => 'artisan';

  @override
  String get heroTitle3 => 'en Algérie';

  @override
  String get heroSimple => 'Simple';

  @override
  String get heroRapide => 'Rapide';

  @override
  String get heroWilayas => '58 wilayas';

  @override
  String get searchTitle => 'TROUVER UN ARTISAN';

  @override
  String get searchWilaya => 'Choisir une wilaya...';

  @override
  String get searchMetier => 'Choisir un métier...';

  @override
  String get searchBtn => 'Rechercher';

  @override
  String searchBtnWith(String metier, String wilaya) {
    return 'Chercher $metier à $wilaya';
  }

  @override
  String get metiersTitle => 'MÉTIERS POPULAIRES';

  @override
  String get bannerArtisan => 'VOUS ÊTES ARTISAN ?';

  @override
  String get bannerInscrire => 'Inscrivez-vous\ngratuitement';

  @override
  String get authBienvenue => 'Bienvenue\nde retour';

  @override
  String get authSoustitre => 'Connectez-vous pour réserver vos artisans';

  @override
  String get authEmail => 'Adresse e-mail';

  @override
  String get authPassword => 'Mot de passe';

  @override
  String get authForgot => 'Mot de passe oublié ?';

  @override
  String get authLogin => 'Se connecter';

  @override
  String get authNoAccount => 'Pas encore de compte ? ';

  @override
  String get authSignup => 'S\'inscrire';

  @override
  String get authOr => 'ou continuer avec';

  @override
  String get signupTitle => 'Créer votre\ncompte';

  @override
  String get signupSous => 'Rejoignez des milliers d\'Algériens';

  @override
  String get signupClient => '👤  Client';

  @override
  String get signupArtisan => '⚒️  Artisan';

  @override
  String get signupNom => 'Nom';

  @override
  String get signupPrenom => 'Prénom';

  @override
  String get signupPhone => 'Numéro de téléphone';

  @override
  String get signupBtnClient => 'Créer mon compte';

  @override
  String get signupBtnArtisan => '⚒️  Créer mon compte artisan';

  @override
  String get signupHasAccount => 'Déjà un compte ? ';

  @override
  String get signupConnect => 'Se connecter';

  @override
  String get signupCGU => 'J\'accepte les conditions d\'utilisation d\'ArtisDZ';

  @override
  String get resultatSelect => 'Sélectionnez un';

  @override
  String resultatDesc(String wilaya) {
    return 'Les meilleurs artisans aux alentours de $wilaya';
  }

  @override
  String get resultatPrestations => 'Prestations';

  @override
  String get resultatCarte => 'Carte';

  @override
  String get resultatFiltres => 'Filtres';

  @override
  String get resultatReserver => 'Réserver';

  @override
  String get resultatNotifier => 'Notifier';

  @override
  String get resultatTrier => 'TRIER PAR';

  @override
  String get resultatReinit => 'Réinitialiser';

  @override
  String get resultatProchain => 'Prochain créneau';

  @override
  String get langTitle => 'Choisir la langue';

  @override
  String get onboardNext => 'Suivant';

  @override
  String get onboardStart => 'Commencer';

  @override
  String get onboardSkip => 'Passer';

  @override
  String get validWilaya => 'Veuillez choisir une wilaya';

  @override
  String get validMetier => 'Veuillez choisir un métier';

  @override
  String get validBoth => 'Veuillez choisir une wilaya et un métier';
}

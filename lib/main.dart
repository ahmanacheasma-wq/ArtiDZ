import 'screens/main_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_page.dart';
import 'screens/resultat_recherche.dart';
import 'screens/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Fix carte Google Maps corrompue sur Android
  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = false; // ← false = Legacy renderer
  }

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor:                    Colors.transparent,
      statusBarIconBrightness:           Brightness.dark,
      systemNavigationBarColor:          Color(0xFFFDF8F2),
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const ArtisDZApp());
}

class ArtisDZApp extends StatelessWidget {
  const ArtisDZApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr'),
      ],
      title: 'ArtisDZ',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: const SplashScreen(),
      routes: {
        '/home': (_) => const MainShell(),
        '/results': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>?;
          return ResultatReche(
            metier: args?['metier'] ?? 'Artisans',
            wilaya: args?['wilaya'] ?? 'Alger',
          );
        },
      },
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,

      colorScheme: ColorScheme.light(
        surface:                  AppC.blanc,
        onSurface:                AppC.brunFonce,
        primary:                  AppC.brunFonce,
        onPrimary:                Colors.white,
        secondary:                AppC.ocre,
        onSecondary:              Colors.white,
        tertiary:                 AppC.brun,
        onTertiary:               Colors.white,
        error:                    const Color(0xFFB71C1C),
        surfaceContainerHighest:  AppC.creme,
      ),

      scaffoldBackgroundColor: AppC.blanc,

      textTheme: const TextTheme(
        displayLarge:  TextStyle(fontFamily: 'Georgia', color: AppC.brunFonce, fontWeight: FontWeight.w300, letterSpacing: -1),
        displayMedium: TextStyle(fontFamily: 'Georgia', color: AppC.brunFonce, fontWeight: FontWeight.w300),
        titleLarge:    TextStyle(fontFamily: 'Georgia', color: AppC.brunFonce, fontWeight: FontWeight.w400, fontSize: 20),
        titleMedium:   TextStyle(color: AppC.brunFonce, fontWeight: FontWeight.w500, fontSize: 16),
        bodyLarge:     TextStyle(color: AppC.brunFonce, fontSize: 15),
        bodyMedium:    TextStyle(color: AppC.argile,    fontSize: 13),
        labelSmall:    TextStyle(color: AppC.argile,    fontSize: 9, letterSpacing: 2.2, fontWeight: FontWeight.w400),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor:        Colors.transparent,
        elevation:              0,
        scrolledUnderElevation: 0,
        foregroundColor:        AppC.brunFonce,
        titleTextStyle: TextStyle(
          fontFamily: 'Georgia', fontSize: 18,
          fontWeight: FontWeight.w400, color: AppC.brunFonce, letterSpacing: 1,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled:    true,
        fillColor: AppC.argentClair,
        hintStyle: const TextStyle(color: AppC.argile, fontStyle: FontStyle.italic, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppC.brunFonce,
          foregroundColor: Colors.white,
          elevation:       0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
      ),

      dividerTheme: DividerThemeData(
        color:     AppC.sable.withOpacity(0.5),
        thickness: 1,
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  PALETTE GLOBALE  —  import '../main.dart' show AppC;
// ════════════════════════════════════════════════════════════════════════════
class AppC {
  // Fonds
  static const blanc        = Color(0xFFFDF8F2);  // Blanc chaud
  static const creme        = Color(0xFFF5ECD7);  // Crème
  static const argentClair  = Color(0xFFEDE0C8);  // Champs input
  static const sable        = Color(0xFFD9C4A0);  // Bordures douces

  // Marque
  static const brunFonce    = Color(0xFF3D2B1F);  // Texte principal / boutons
  static const brun         = Color(0xFF6B4226);  // Brun chaud
  static const brunMoyen    = Color(0xFFA0715A);  // Brun moyen
  static const ocre         = Color(0xFFC8922A);  // Or artisanal
  static const ocreClair    = Color(0xFFD9A84C);  // Ocre lumineux

  // Textes
  static const argile       = Color(0xFFA0715A);  // Texte secondaire
  static const gris         = Color(0xFF8B6A50);  // Texte tertiaire

  // Statuts
  static const success      = Color(0xFF2E7D4F);
  static const error        = Color(0xFFB71C1C);
}
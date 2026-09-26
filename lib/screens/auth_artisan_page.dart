import 'package:flutter/material.dart';
import '../main.dart' show AppC; // Pour utiliser tes couleurs

class AuthArtisanPage extends StatelessWidget {
  const AuthArtisanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.blanc,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: AppC.brunFonce)
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TITRE EXCLUSIF ARTISAN
            const Text(
                "Bienvenue Artisan",
                style: TextStyle(fontFamily: 'Georgia', fontSize: 30, fontWeight: FontWeight.bold, color: AppC.brunFonce)
            ),
            const SizedBox(height: 15),
            const Text(
                "Connectez-vous à votre espace professionnel pour gérer vos services.",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppC.argile, fontSize: 16)
            ),

            const SizedBox(height: 50),

            // BOUTON GOOGLE (Zéro Facebook comme demandé)
            _buildSocialBtn(
              label: "Continuer avec Google",
              isGoogle: true,
              onTap: () => print("Connexion Google Artisan..."),
            ),

            const SizedBox(height: 15),

            // BOUTON EMAIL (Optionnel mais pro)
            _buildSocialBtn(
              label: "Utiliser mon Email",
              isGoogle: false,
              onTap: () => print("Connexion Email Artisan..."),
            ),
          ],
        ),
      ),
    );
  }

  // Petit widget pour créer les boutons proprement
  Widget _buildSocialBtn({required String label, required bool isGoogle, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: isGoogle ? Colors.white : AppC.brunFonce,
          borderRadius: BorderRadius.circular(15),
          border: isGoogle ? Border.all(color: AppC.sable) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(isGoogle) const Icon(Icons.account_circle, color: AppC.ocre),
            if(!isGoogle) const Icon(Icons.email, color: Colors.white),
            const SizedBox(width: 10),
            Text(
                label,
                style: TextStyle(
                    color: isGoogle ? AppC.brunFonce : Colors.white,
                    fontWeight: FontWeight.bold
                )
            ),
          ],
        ),
      ),
    );
  }
}
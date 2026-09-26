import 'package:flutter/material.dart';
import '../main.dart' show AppC;

// ════════════════════════════════════════════════════════════════════════════
//  MODÈLE ARTISAN
// ════════════════════════════════════════════════════════════════════════════
class Artisan {
  final String nom;
  final String prenom;
  final String metier;
  final String metierEmoji;
  final String wilaya;
  final String commune;
  final double note;
  final int nbAvis;
  final int experience;
  final String description;
  final bool disponible;
  final bool verifie;
  final String? photoUrl;

  const Artisan({
    required this.nom,
    required this.prenom,
    required this.metier,
    required this.metierEmoji,
    required this.wilaya,
    required this.commune,
    required this.note,
    required this.nbAvis,
    required this.experience,
    required this.description,
    this.disponible = true,
    this.verifie = false,
    this.photoUrl,
  });
}

// ════════════════════════════════════════════════════════════════════════════
//  ARTISAN CARD WIDGET
// ════════════════════════════════════════════════════════════════════════════
class ArtisanCard extends StatelessWidget {
  final Artisan artisan;
  final VoidCallback? onVoirProfil;
  final VoidCallback? onContacter;

  const ArtisanCard({
    super.key,
    required this.artisan,
    this.onVoirProfil,
    this.onContacter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppC.brun.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Partie principale ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Avatar ──────────────────────────────────────────
                Stack(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: const LinearGradient(
                          colors: [AppC.brun, AppC.brunFonce],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppC.brun.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: artisan.photoUrl != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.network(
                          artisan.photoUrl!,
                          fit: BoxFit.cover,
                        ),
                      )
                          : Center(
                        child: Text(
                          '${artisan.prenom[0]}${artisan.nom[0]}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontFamily: 'Georgia',
                          ),
                        ),
                      ),
                    ),
                    // Badge disponible
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: artisan.disponible
                              ? const Color(0xFF22C55E)
                              : const Color(0xFFEF4444),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),

                // ── Infos principales ────────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nom + badge vérifié
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${artisan.prenom} ${artisan.nom}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppC.brunFonce,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (artisan.verifie)
                            Container(
                              margin: const EdgeInsets.only(left: 6),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF22C55E)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFF22C55E)
                                      .withOpacity(0.4),
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.verified_rounded,
                                      size: 10,
                                      color: Color(0xFF22C55E)),
                                  SizedBox(width: 3),
                                  Text('Vérifié',
                                      style: TextStyle(
                                          fontSize: 9,
                                          color: Color(0xFF22C55E),
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 5),

                      // Métier
                      Row(
                        children: [
                          Text(artisan.metierEmoji,
                              style: const TextStyle(fontSize: 13)),
                          const SizedBox(width: 5),
                          Text(
                            artisan.metier,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppC.ocre,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),

                      // Localisation
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 12, color: AppC.argile),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${artisan.commune} • ${artisan.wilaya}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppC.argile,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Séparateur ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 1,
              color: AppC.sable.withOpacity(0.4),
            ),
          ),

          // ── Stats ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Note
                _StatBadge(
                  icon: Icons.star_rounded,
                  iconColor: const Color(0xFFF59E0B),
                  label:
                  '${artisan.note.toStringAsFixed(1)} (${artisan.nbAvis})',
                ),
                const SizedBox(width: 10),

                // Expérience
                _StatBadge(
                  icon: Icons.workspace_premium_outlined,
                  iconColor: AppC.ocre,
                  label: artisan.experience == 1
                      ? '1 an exp.'
                      : '${artisan.experience} ans exp.',
                ),
                const Spacer(),

                // Disponibilité
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: artisan.disponible
                        ? const Color(0xFF22C55E).withOpacity(0.1)
                        : const Color(0xFFEF4444).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: artisan.disponible
                          ? const Color(0xFF22C55E).withOpacity(0.3)
                          : const Color(0xFFEF4444).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    artisan.disponible ? 'Disponible' : 'Occupé',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: artisan.disponible
                          ? const Color(0xFF22C55E)
                          : const Color(0xFFEF4444),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Description ────────────────────────────────────────────
          if (artisan.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppC.creme,
                  borderRadius: BorderRadius.circular(12),
                  border:
                  Border.all(color: AppC.sable.withOpacity(0.5)),
                ),
                child: Text(
                  artisan.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppC.argile,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

          // ── Boutons ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                // Voir profil
                Expanded(
                  child: GestureDetector(
                    onTap: onVoirProfil,
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppC.creme,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppC.sable),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_outline_rounded,
                              size: 15, color: AppC.brunFonce),
                          SizedBox(width: 6),
                          Text(
                            'Voir profil',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppC.brunFonce,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Contacter
                Expanded(
                  child: GestureDetector(
                    onTap: onContacter,
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppC.brunFonce, AppC.brun],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppC.brun.withOpacity(0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.phone_outlined,
                              size: 15, color: Colors.white),
                          SizedBox(width: 6),
                          Text(
                            'Contacter',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  STAT BADGE
// ════════════════════════════════════════════════════════════════════════════
class _StatBadge extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;

  const _StatBadge({
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppC.argentClair,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppC.sable.withOpacity(0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: iconColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppC.brunFonce,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
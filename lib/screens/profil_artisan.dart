import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prise_rdv/main.dart' show AppC;
import 'resultat_recherche.dart' show ArtisanListing;
// ════════════════════════════════════════════════════════════════════════════
//  PAGE PROFIL ARTISAN
// ════════════════════════════════════════════════════════════════════════════
class ProfilArtisan extends StatefulWidget {
  final ArtisanListing artisan;
  const ProfilArtisan({super.key, required this.artisan});

  @override
  State<ProfilArtisan> createState() => _ProfilArtisanState();
}

class _ProfilArtisanState extends State<ProfilArtisan> {
  bool _isFavori = false;

  // Données mock enrichies selon l'artisan
  String get _phone => '+213 05 XX XX XX XX';
  String get _experience => '8 ans d\'expérience';
  String get _description =>
      'Artisan qualifié, sérieux et ponctuel. Je réalise tous types de travaux '
          'avec soin et professionnalisme. Devis gratuit sous 24h. '
          'Disponible 7j/7 pour les urgences.';

  List<String> get _specialites => [
    ...widget.artisan.tags,
    'Devis gratuit',
    '7j/7',
  ];

  // Galerie mock (emojis représentant les travaux)
  List<Map<String, String>> get _galerie => [
    {'emoji': widget.artisan.emoji, 'label': 'Travail 1'},
    {'emoji': widget.artisan.emoji, 'label': 'Travail 2'},
    {'emoji': widget.artisan.emoji, 'label': 'Travail 3'},
    {'emoji': widget.artisan.emoji, 'label': 'Travail 4'},
    {'emoji': widget.artisan.emoji, 'label': 'Travail 5'},
    {'emoji': widget.artisan.emoji, 'label': 'Travail 6'},
  ];

  // Avis mock
  final List<Map<String, dynamic>> _avis = [
    {'nom': 'Sonia B.', 'note': 5, 'date': 'Il y a 2 jours',
      'texte': 'Excellent travail, rapide et propre. Je recommande vivement !'},
    {'nom': 'Kamel D.', 'note': 5, 'date': 'Il y a 1 semaine',
      'texte': 'Très professionnel, tarif raisonnable. Résultat impeccable.'},
    {'nom': 'Farida M.', 'note': 4, 'date': 'Il y a 2 semaines',
      'texte': 'Bon travail dans l\'ensemble, quelques petits délais mais résultat satisfaisant.'},
  ];

  void _appeler() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _AppelSheet(
        name: widget.artisan.name,
        phone: _phone,
      ),
    );
  }

  void _toggleFavori() {
    HapticFeedback.lightImpact();
    setState(() => _isFavori = !_isFavori);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        backgroundColor: AppC.brunFonce,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(seconds: 2),
        content: Row(children: [
          Icon(_isFavori ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              size: 16, color: _isFavori ? Colors.redAccent : Colors.white70),
          const SizedBox(width: 10),
          Text(
            _isFavori ? 'Ajouté aux favoris' : 'Retiré des favoris',
            style: const TextStyle(fontSize: 13, color: Colors.white,
                fontWeight: FontWeight.w500),
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.artisan;
    return Scaffold(
      backgroundColor: AppC.blanc,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [

          // ── HEADER HERO ─────────────────────────────────────────────
          SliverToBoxAdapter(child: _buildHero(a)),

          // ── INFOS PRINCIPALES ────────────────────────────────────────
          SliverToBoxAdapter(child: _buildInfoCard(a)),

          // ── DESCRIPTION ──────────────────────────────────────────────
          SliverToBoxAdapter(child: _buildSection(
            title: 'À propos',
            child: Text(
              _description,
              style: const TextStyle(
                fontSize: 13.5, color: AppC.argile,
                height: 1.7, fontWeight: FontWeight.w300,
              ),
            ),
          )),

          // ── SPÉCIALITÉS ──────────────────────────────────────────────
          SliverToBoxAdapter(child: _buildSection(
            title: 'Spécialités',
            child: Wrap(
              spacing: 8, runSpacing: 8,
              children: _specialites.map((s) => Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: AppC.creme,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppC.sable),
                ),
                child: Text(s, style: const TextStyle(
                    fontSize: 12, color: AppC.brun,
                    fontWeight: FontWeight.w500)),
              )).toList(),
            ),
          )),

          // ── LOCALISATION ─────────────────────────────────────────────
          SliverToBoxAdapter(child: _buildSection(
            title: 'Localisation',
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppC.creme,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppC.sable),
              ),
              child: Row(children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: AppC.brunFonce,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.location_on_rounded,
                      color: Colors.white, size: 22),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(a.quartier,
                      style: const TextStyle(
                        fontSize: 15, color: AppC.brunFonce,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(a.wilaya,
                        style: const TextStyle(
                            fontSize: 13, color: AppC.argile)),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppC.argentClair,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppC.sable),
                  ),
                  child: const Text('Voir sur la carte',
                      style: TextStyle(fontSize: 11, color: AppC.brun,
                          fontWeight: FontWeight.w600)),
                ),
              ]),
            ),
          )),

          // ── GALERIE ──────────────────────────────────────────────────
          SliverToBoxAdapter(child: _buildSection(
            title: 'Galerie de travaux',
            child: SizedBox(
              height: 110,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _galerie.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) => Container(
                  width: 110, height: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: LinearGradient(
                      colors: [
                        a.cardAccent.withOpacity(0.7),
                        a.cardAccent.withOpacity(0.3),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(color: AppC.sable.withOpacity(0.5)),
                  ),
                  child: Center(
                    child: Text(_galerie[i]['emoji']!,
                        style: const TextStyle(fontSize: 38)),
                  ),
                ),
              ),
            ),
          )),

          // ── AVIS ─────────────────────────────────────────────────────
          SliverToBoxAdapter(child: _buildSection(
            title: 'Avis clients',
            child: Column(
              children: _avis.map((av) => _AvisCard(avis: av)).toList(),
            ),
          )),

          const SliverToBoxAdapter(child: SizedBox(height: 110)),
        ],
      ),

      // ── BOUTONS FLOTTANTS ────────────────────────────────────────────
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  HERO
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildHero(ArtisanListing a) {
    final top = MediaQuery.of(context).padding.top;
    return Stack(
      children: [
        // Fond dégradé
        Container(
          height: 260 + top,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [
                AppC.brunFonce,
                a.cardAccent.withOpacity(0.85),
                a.cardAccent,
              ],
            ),
          ),
        ),
        // Motif
        Positioned.fill(
          child: Opacity(opacity: 0.08,
              child: CustomPaint(painter: _HeroPattern())),
        ),
        // Arche blanche
        Positioned(bottom: -2, left: 0, right: 0,
          child: Container(height: 40,
            decoration: const BoxDecoration(
              color: AppC.blanc,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
          ),
        ),
        // Contenu
        Positioned(top: top + 12, left: 20, right: 20,
          child: Column(children: [
            // Barre top : retour + favori
            Row(children: [
              GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      size: 14, color: Colors.white),
                ),
              ),
              const Spacer(),
              // Favori
              GestureDetector(
                onTap: _toggleFavori,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: _isFavori
                        ? Colors.redAccent.withOpacity(0.2)
                        : Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(
                      color: _isFavori
                          ? Colors.redAccent.withOpacity(0.5)
                          : Colors.white.withOpacity(0.3),
                    ),
                  ),
                  child: Icon(
                    _isFavori
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 18,
                    color: _isFavori ? Colors.redAccent : Colors.white,
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 24),

            // Avatar emoji
            Container(
              width: 90, height: 90,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.white.withOpacity(0.4), width: 2.5),
              ),
              child: Center(
                child: Text(a.emoji,
                    style: const TextStyle(fontSize: 42)),
              ),
            ),
            const SizedBox(height: 14),

            // Nom
            Text(a.name,
              style: const TextStyle(
                fontFamily: 'Georgia', fontSize: 22,
                color: Colors.white, fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
                shadows: [Shadow(color: Colors.black26, blurRadius: 8)],
              ),
            ),
            const SizedBox(height: 6),

            // Métier + expérience
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.25)),
                ),
                child: Text(a.metier,
                    style: const TextStyle(fontSize: 12, color: Colors.white,
                        fontWeight: FontWeight.w500)),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.25)),
                ),
                child: Text(_experience,
                    style: const TextStyle(fontSize: 12, color: Colors.white70)),
              ),
            ]),
          ]),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  CARTE INFO (note, avis, dispo)
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildInfoCard(ArtisanListing a) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppC.sable.withOpacity(0.5)),
          boxShadow: [BoxShadow(
            color: AppC.brun.withOpacity(0.08),
            blurRadius: 16, offset: const Offset(0, 4),
          )],
        ),
        child: Row(children: [
          _StatCell(
            value: a.rating.toStringAsFixed(1),
            label: 'Note',
            icon: Icons.star_rounded,
            iconColor: AppC.ocre,
          ),
          _vDivider(),
          _StatCell(
            value: '${a.reviews}',
            label: 'Avis',
            icon: Icons.chat_bubble_outline_rounded,
            iconColor: AppC.brun,
          ),
          _vDivider(),
          _StatCell(
            value: a.disponible ? 'Oui' : 'Non',
            label: 'Disponible',
            icon: Icons.circle,
            iconColor: a.disponible ? AppC.success : AppC.argile,
          ),
        ]),
      ),
    );
  }

  Widget _vDivider() => Container(
      width: 1, height: 40, color: AppC.sable.withOpacity(0.5));

  // ══════════════════════════════════════════════════════════════════════════
  //  SECTION WRAPPER
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildSection({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(width: 3, height: 16,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: AppC.ocre,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(title, style: const TextStyle(
              fontFamily: 'Georgia', fontSize: 17,
              color: AppC.brunFonce, fontWeight: FontWeight.w400,
            )),
          ]),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  BARRE BAS : Appeler + Favori
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 14, 20, MediaQuery.of(context).padding.bottom + 14),
      decoration: BoxDecoration(
        color: AppC.blanc,
        border: Border(top: BorderSide(color: AppC.sable.withOpacity(0.5))),
        boxShadow: [BoxShadow(
          color: AppC.brun.withOpacity(0.08),
          blurRadius: 16, offset: const Offset(0, -4),
        )],
      ),
      child: Row(children: [

        // Bouton Favori
        GestureDetector(
          onTap: _toggleFavori,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: _isFavori
                  ? Colors.redAccent.withOpacity(0.1)
                  : AppC.creme,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: _isFavori
                    ? Colors.redAccent.withOpacity(0.4)
                    : AppC.sable,
              ),
            ),
            child: Icon(
              _isFavori
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              size: 22,
              color: _isFavori ? Colors.redAccent : AppC.argile,
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Bouton Appeler
        Expanded(
          child: GestureDetector(
            onTap: _appeler,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppC.brunFonce, AppC.brun],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(
                  color: AppC.brun.withOpacity(0.4),
                  blurRadius: 12, offset: const Offset(0, 4),
                )],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 28, height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.phone_rounded,
                        size: 14, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  const Text('Appeler',
                    style: TextStyle(
                      fontSize: 15, color: Colors.white,
                      fontWeight: FontWeight.w600, letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  COMPOSANTS
// ════════════════════════════════════════════════════════════════════════════

class _StatCell extends StatelessWidget {
  final String value, label;
  final IconData icon;
  final Color iconColor;
  const _StatCell({required this.value, required this.label,
    required this.icon, required this.iconColor});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(children: [
      Icon(icon, size: 16, color: iconColor),
      const SizedBox(height: 4),
      Text(value, style: const TextStyle(
          fontSize: 17, color: AppC.brunFonce, fontWeight: FontWeight.w700)),
      const SizedBox(height: 2),
      Text(label, style: const TextStyle(
          fontSize: 10, color: AppC.argile, letterSpacing: 0.3)),
    ]),
  );
}

class _AvisCard extends StatelessWidget {
  final Map<String, dynamic> avis;
  const _AvisCard({required this.avis});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppC.sable.withOpacity(0.5)),
      boxShadow: [BoxShadow(
        color: AppC.brun.withOpacity(0.06),
        blurRadius: 10, offset: const Offset(0, 3),
      )],
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        // Avatar initiale
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: AppC.creme,
            shape: BoxShape.circle,
            border: Border.all(color: AppC.sable),
          ),
          child: Center(child: Text(
            avis['nom'].toString()[0],
            style: const TextStyle(
                fontSize: 15, color: AppC.brun, fontWeight: FontWeight.w700),
          )),
        ),
        const SizedBox(width: 10),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(avis['nom'], style: const TextStyle(
                fontSize: 13, color: AppC.brunFonce,
                fontWeight: FontWeight.w600)),
            Text(avis['date'], style: const TextStyle(
                fontSize: 10, color: AppC.argile)),
          ],
        )),
        // Étoiles
        Row(children: List.generate(5, (i) => Icon(
          i < avis['note'] ? Icons.star_rounded : Icons.star_outline_rounded,
          size: 13,
          color: i < avis['note'] ? AppC.ocre : AppC.sable,
        ))),
      ]),
      const SizedBox(height: 10),
      Text(avis['texte'], style: const TextStyle(
        fontSize: 12.5, color: AppC.argile, height: 1.6,
        fontWeight: FontWeight.w300,
      )),
    ]),
  );
}

// ── Bottom sheet appel ────────────────────────────────────────────────────
class _AppelSheet extends StatelessWidget {
  final String name, phone;
  const _AppelSheet({required this.name, required this.phone});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.fromLTRB(12, 0, 12, 24),
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: AppC.blanc,
      borderRadius: BorderRadius.circular(28),
      boxShadow: [BoxShadow(
        color: AppC.brun.withOpacity(0.15),
        blurRadius: 30, offset: const Offset(0, -4),
      )],
    ),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 38, height: 4,
        decoration: BoxDecoration(
            color: AppC.sable, borderRadius: BorderRadius.circular(2)),
      ),
      const SizedBox(height: 20),
      Container(
        width: 64, height: 64,
        decoration: BoxDecoration(
          color: AppC.brunFonce,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(
            color: AppC.brun.withOpacity(0.4),
            blurRadius: 16, offset: const Offset(0, 6),
          )],
        ),
        child: const Icon(Icons.phone_rounded, size: 28, color: Colors.white),
      ),
      const SizedBox(height: 16),
      Text('Appeler $name',
          style: const TextStyle(fontFamily: 'Georgia', fontSize: 18,
              color: AppC.brunFonce, fontWeight: FontWeight.w400)),
      const SizedBox(height: 6),
      Text(phone, style: const TextStyle(
          fontSize: 16, color: AppC.ocre, fontWeight: FontWeight.w600,
          letterSpacing: 1)),
      const SizedBox(height: 24),
      // Bouton appel
      GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          width: double.infinity, height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppC.brunFonce, AppC.brun],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(
              color: AppC.brun.withOpacity(0.4),
              blurRadius: 12, offset: const Offset(0, 4),
            )],
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            Icon(Icons.phone_rounded, size: 18, color: Colors.white),
            SizedBox(width: 10),
            Text('Confirmer l\'appel', style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600)),
          ]),
        ),
      ),
      const SizedBox(height: 12),
      GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          width: double.infinity, height: 46,
          decoration: BoxDecoration(
            color: AppC.creme,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppC.sable),
          ),
          child: const Center(child: Text('Annuler',
              style: TextStyle(fontSize: 14, color: AppC.argile,
                  fontWeight: FontWeight.w500))),
        ),
      ),
    ]),
  );
}

// ════════════════════════════════════════════════════════════════════════════
//  PAINTER
// ════════════════════════════════════════════════════════════════════════════
class _HeroPattern extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white..strokeWidth = 0.7..style = PaintingStyle.stroke;
    const step = 30.0;
    for (double x = -size.height; x < size.width + size.height; x += step * 1.5) {
      canvas.drawLine(Offset(x, 0), Offset(x + size.height, size.height), p);
      canvas.drawLine(Offset(x + size.height, 0), Offset(x, size.height), p);
    }
    p.strokeWidth = 1.0;
    canvas.drawCircle(
        Offset(size.width * 0.8, size.height * 0.5), size.width * 0.3, p);
  }
  @override bool shouldRepaint(_) => false;
}
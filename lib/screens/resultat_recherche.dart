import 'package:flutter/material.dart';
import '../main.dart' show AppC;
import 'reservation_page.dart';
import 'carte_page.dart';
import 'profil_artisan.dart';
// ════════════════════════════════════════════════════════════════════════════
//  MODÈLE
// ════════════════════════════════════════════════════════════════════════════
class ArtisanListing {
  final String name;
  final String metier;
  final String wilaya;
  final String quartier;
  final double rating;
  final int    reviews;
  final String emoji;
  final bool   disponible;
  final String prochainCreneau;
  final List<String> tags;
  final Color  cardAccent;

  const ArtisanListing({
    required this.name,
    required this.metier,
    required this.wilaya,
    required this.quartier,
    required this.rating,
    required this.reviews,
    required this.emoji,
    required this.disponible,
    required this.prochainCreneau,
    required this.tags,
    required this.cardAccent,
  });
}

// ════════════════════════════════════════════════════════════════════════════
//  DONNÉES MOCK
// ════════════════════════════════════════════════════════════════════════════
final List<ArtisanListing> kListings = [
  ArtisanListing(
    name: 'Mourad Benali',     metier: 'Plombier',    wilaya: 'Alger',
    quartier: 'Bab El Oued',   rating: 4.9, reviews: 127,
    emoji: '🔧', disponible: true, prochainCreneau: "Aujourd'hui 14h00",
    tags: ['Urgence', 'Chauffe-eau', 'Fuite'],
    cardAccent: Color(0xFF6B4226),
  ),
  ArtisanListing(
    name: 'Karim Meziani',     metier: 'Électricien', wilaya: 'Alger',
    quartier: 'Hussein Dey',   rating: 4.7, reviews: 214,
    emoji: '⚡', disponible: true, prochainCreneau: "Aujourd'hui 16h30",
    tags: ['Tableau élec.', 'Prises', 'Éclairage'],
    cardAccent: Color(0xFFC8922A),
  ),
  ArtisanListing(
    name: 'Sofiane Khelil',    metier: 'Menuisier',   wilaya: 'Alger',
    quartier: 'El Harrach',    rating: 4.8, reviews: 89,
    emoji: '🪵', disponible: false, prochainCreneau: 'Demain 09h00',
    tags: ['Portes', 'Parquet', 'Cuisine'],
    cardAccent: Color(0xFFA0715A),
  ),
  ArtisanListing(
    name: 'Rachid Boukhalfa',  metier: 'Maçon',       wilaya: 'Alger',
    quartier: 'Kouba',         rating: 4.6, reviews: 155,
    emoji: '🧱', disponible: true, prochainCreneau: "Aujourd'hui 15h00",
    tags: ['Carrelage', 'Enduit', 'Rénovation'],
    cardAccent: Color(0xFF3D2B1F),
  ),
  ArtisanListing(
    name: 'Yacine Amrani',     metier: 'Peintre',     wilaya: 'Alger',
    quartier: 'Bir Mourad Raïs', rating: 4.5, reviews: 91,
    emoji: '🎨', disponible: true, prochainCreneau: 'Demain 10h00',
    tags: ['Intérieur', 'Façade', 'Décoratif'],
    cardAccent: Color(0xFF8B6A50),
  ),
  ArtisanListing(
    name: 'Amina Touati',      metier: 'Broderie',    wilaya: 'Alger',
    quartier: 'Hydra',         rating: 5.0, reviews: 67,
    emoji: '🪡', disponible: false, prochainCreneau: 'Mer. 09h30',
    tags: ['Kabyle', 'Tenue traditionnelle', 'Sur mesure'],
    cardAccent: Color(0xFFD9A84C),
  ),
];

// ════════════════════════════════════════════════════════════════════════════
//  PAGE RÉSULTATS
// ════════════════════════════════════════════════════════════════════════════
class ResultatReche extends StatefulWidget {
  final String metier;
  final String wilaya;
  final String? commune;

  const ResultatReche({
    super.key,
    this.metier = 'Plombiers',
    this.wilaya = 'Alger',
    this.commune,
  });

  @override
  State<ResultatReche> createState() => _ResultatRecheState();
}

class _ResultatRecheState extends State<ResultatReche> {
  int    _viewMode    = 0; // 0 = Prestations, 1 = Carte
  bool   _filterOpen  = false;
  String _sortBy      = 'Pertinence';

  final List<String> _sortOptions  = ['Pertinence', 'Mieux notés', 'Disponible maintenant', 'Proximité'];
  final Set<String>  _activeFilters = {};
  final List<String> _allFilters   = [
    'Disponible maintenant', 'Urgence', 'Moins de 2km',
    'Noté 4+', 'Expérimenté (+5 ans)', 'Tarif négociable',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.blanc,
      body: Column(
        children: [

          // ── Top bar ───────────────────────────────────────────────────
          _buildTopBar(context),

          // ── Barre filtres ─────────────────────────────────────────────
          _buildFilterBar(),

          // ── Panneau filtres (animé) ───────────────────────────────────
          AnimatedSize(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            child: _filterOpen ? _buildFilterPanel() : const SizedBox.shrink(),
          ),

          // ── Liste ─────────────────────────────────────────────────────
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: _buildSectionHeader()),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (_, i) => _ArtisanCard(listing: kListings[i]),
                      childCount: kListings.length,
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

  // ── Top bar ──────────────────────────────────────────────────────────────
  Widget _buildTopBar(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      color: AppC.blanc,
      padding: EdgeInsets.fromLTRB(16, top + 10, 16, 12),
      child: Column(
        children: [
          // Ligne logo
          Row(
            children: [
              // Retour
              GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: AppC.creme,
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(color: AppC.sable),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: AppC.brunFonce),
                ),
              ),
              const Spacer(),
              // Logo
              Text(
                'ArtisDZ',
                style: TextStyle(
                  fontFamily: 'Georgia', fontSize: 17,
                  color: AppC.brunFonce, fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                  shadows: [Shadow(color: AppC.ocre.withOpacity(0.3), blurRadius: 6)],
                ),
              ),
              const Spacer(),
              // Avatar
              Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  color: AppC.creme,
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: AppC.sable),
                ),
                child: const Icon(Icons.person_outline_rounded, color: AppC.brun, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Barre de recherche résumée
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: AppC.creme,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppC.sable),
              boxShadow: [
                BoxShadow(
                  color: AppC.brun.withOpacity(0.08),
                  blurRadius: 10, offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.search_rounded, size: 16, color: AppC.ocre),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.metier,
                            style: const TextStyle(
                              fontSize: 15, color: AppC.brunFonce,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Container(
                              width: 4, height: 4,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: AppC.ocre,
                              ),
                            ),
                          ),
                          Text(
                            widget.commune != null
                                ? widget.commune!
                                : widget.wilaya.substring(5),
                            style: const TextStyle(
                              fontSize: 15, color: AppC.brunFonce,
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.ellipsis, // ← coupe si trop long
                            maxLines: 1,
                          ),
                        ],
                      ),
                      const Text(
                        'À tout moment',
                        style: TextStyle(
                          fontSize: 11, color: AppC.argile,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: AppC.argentClair,
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: AppC.sable),
                  ),
                  child: const Icon(Icons.edit_outlined, size: 14, color: AppC.argile),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Barre filtres ─────────────────────────────────────────────────────────
  Widget _buildFilterBar() {
    return Container(
      color: AppC.blanc,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Row(
        children: [
          // Toggle Prestations / Carte
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: AppC.creme,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppC.sable),
              ),
              child: Row(
                children: [
                  _ViewToggle(label: 'Prestations', icon: Icons.grid_view_rounded,
                      selected: _viewMode == 0, onTap: () => setState(() => _viewMode = 0)),
                  Container(width: 1, height: 20, color: AppC.sable),
                  _ViewToggle(label: 'Carte', icon: Icons.map_outlined,
                      selected: _viewMode == 1,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (_) => CartePage(
                            metier: widget.metier,
                            wilaya: widget.wilaya,
                            artisans: kListings,
                          ),
                        ));
                      }),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Bouton filtres
          GestureDetector(
            onTap: () => setState(() => _filterOpen = !_filterOpen),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: _filterOpen ? AppC.brunFonce : AppC.creme,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _filterOpen ? AppC.brunFonce : AppC.sable,
                ),
                boxShadow: _filterOpen
                    ? [BoxShadow(color: AppC.brun.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.tune_rounded, size: 15,
                      color: _filterOpen ? AppC.ocreClair : AppC.argile),
                  const SizedBox(width: 6),
                  Text(
                    'Filtres${_activeFilters.isNotEmpty ? ' (${_activeFilters.length})' : ''}',
                    style: TextStyle(
                      fontSize: 12,
                      color: _filterOpen ? Colors.white : AppC.argile,
                      fontWeight: _filterOpen ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Panneau filtres ───────────────────────────────────────────────────────
  Widget _buildFilterPanel() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppC.creme,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppC.sable),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trier par
          Row(
            children: [
              const Text('TRIER PAR',
                  style: TextStyle(fontSize: 8, letterSpacing: 2, color: AppC.argile)),
              const Spacer(),
              GestureDetector(
                onTap: () => setState(() => _activeFilters.clear()),
                child: const Text('Réinitialiser',
                    style: TextStyle(fontSize: 10, color: AppC.ocre,
                        decoration: TextDecoration.underline, decorationColor: AppC.ocre)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 34,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _sortOptions.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final sel = _sortBy == _sortOptions[i];
                return GestureDetector(
                  onTap: () => setState(() => _sortBy = _sortOptions[i]),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: sel ? AppC.brunFonce : AppC.argentClair,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: sel ? AppC.brunFonce : AppC.sable),
                    ),
                    child: Center(
                      child: Text(_sortOptions[i],
                        style: TextStyle(
                          fontSize: 11,
                          color: sel ? Colors.white : AppC.argile,
                          fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Filtres rapides
          const Text('FILTRES RAPIDES',
              style: TextStyle(fontSize: 8, letterSpacing: 2, color: AppC.argile)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: _allFilters.map((f) {
              final active = _activeFilters.contains(f);
              return GestureDetector(
                onTap: () => setState(() =>
                active ? _activeFilters.remove(f) : _activeFilters.add(f)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: active ? AppC.brunFonce : AppC.argentClair,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: active ? AppC.brunFonce : AppC.sable),
                  ),
                  child: Text(f,
                    style: TextStyle(
                      fontSize: 11,
                      color: active ? Colors.white : AppC.argile,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── En-tête section ───────────────────────────────────────────────────────
  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Georgia', fontSize: 22,
                      color: AppC.brunFonce, height: 1.2,
                    ),
                    children: [
                      const TextSpan(text: 'Sélectionnez un\n'),
                      TextSpan(
                        text: widget.metier.toLowerCase(),
                        style: const TextStyle(
                          fontStyle: FontStyle.italic, color: AppC.ocre,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppC.creme,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppC.sable),
                ),
                child: Text('${kListings.length} résultats',
                  style: const TextStyle(
                    fontSize: 10, color: AppC.brun, fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Les meilleurs artisans aux alentours de ${widget.wilaya} — Réservation en ligne',
            style: const TextStyle(
              fontSize: 13, color: AppC.argile,
              height: 1.5, fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppC.ocre.withOpacity(0.5), AppC.sable.withOpacity(0.2), Colors.transparent],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  CARTE ARTISAN
// ════════════════════════════════════════════════════════════════════════════
class _ArtisanCard extends StatefulWidget {
  final ArtisanListing listing;
  const _ArtisanCard({required this.listing});
  @override State<_ArtisanCard> createState() => _ArtisanCardState();
}

class _ArtisanCardState extends State<_ArtisanCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final l = widget.listing;
    return GestureDetector(
      onTapDown:   (_) => setState(() => _pressed = true),
      onTapUp:     (_) => setState(() => _pressed = false),
      onTapCancel: ()  => setState(() => _pressed = false),
      onTap: () {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: _pressed ? AppC.creme : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: _pressed ? AppC.sable : AppC.sable.withOpacity(0.5)),
          boxShadow: _pressed ? [] : [
            BoxShadow(
              color: AppC.brun.withOpacity(0.1),
              blurRadius: 18, offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Bannière ─────────────────────────────────────────────────
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
              child: Stack(
                children: [
                  // Fond dégradé chaud
                  Container(
                    height: 140, width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft, end: Alignment.bottomRight,
                        colors: [
                          l.cardAccent.withOpacity(0.85),
                          l.cardAccent.withOpacity(0.4),
                          AppC.creme,
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Motif géo
                        Opacity(
                          opacity: 0.1,
                          child: CustomPaint(
                            painter: _MiniBannerPainter(),
                            size: const Size(double.infinity, 140),
                          ),
                        ),
                        Center(child: Text(l.emoji, style: const TextStyle(fontSize: 52))),
                      ],
                    ),
                  ),

                  // Badge disponibilité
                  Positioned(
                    top: 12, left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: l.disponible
                            ? Colors.white.withOpacity(0.9)
                            : AppC.creme.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: l.disponible
                              ? AppC.success.withOpacity(0.4)
                              : AppC.sable,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6, height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: l.disponible ? AppC.success : AppC.argile,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            l.disponible ? 'Disponible' : 'Indisponible',
                            style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w600,
                              color: l.disponible ? AppC.success : AppC.argile,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Note
                  Positioned(
                    top: 12, right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.88),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppC.sable),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, size: 12, color: AppC.ocre),
                          const SizedBox(width: 3),
                          Text(
                            l.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 12, color: AppC.brunFonce, fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(' (${l.reviews})',
                              style: TextStyle(fontSize: 10, color: AppC.argile.withOpacity(0.8))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Infos ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Nom + localisation
                  Row(
                    children: [
                      Expanded(
                        child: Text(l.name,
                          style: const TextStyle(
                            fontSize: 16, color: AppC.brunFonce, fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 12, color: AppC.argile),
                          const SizedBox(width: 3),
                          Text('${l.quartier}, ${l.wilaya}',
                              style: const TextStyle(fontSize: 10, color: AppC.argile)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Métier
                  Row(
                    children: [
                      Container(
                        width: 3, height: 12,
                        margin: const EdgeInsets.only(right: 7),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppC.ocre, AppC.brun],
                            begin: Alignment.topCenter, end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Text(l.metier,
                        style: const TextStyle(
                          fontSize: 12, color: AppC.ocre,
                          fontWeight: FontWeight.w600, letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Tags
                  Wrap(
                    spacing: 7, runSpacing: 7,
                    children: l.tags.map((tag) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppC.argentClair,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppC.sable.withOpacity(0.7)),
                      ),
                      child: Text(tag,
                          style: const TextStyle(fontSize: 10, color: AppC.argile)),
                    )).toList(),
                  ),
                  const SizedBox(height: 12),

                  // Divider
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, AppC.sable.withOpacity(0.6), Colors.transparent],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Créneau + bouton
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.schedule_rounded, size: 14,
                                color: l.disponible ? AppC.success : AppC.argile),
                            const SizedBox(width: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Prochain créneau',
                                    style: TextStyle(fontSize: 9, color: AppC.argile, letterSpacing: 0.5)),
                                Text(l.prochainCreneau,
                                  style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600,
                                    color: l.disponible ? AppC.brunFonce : AppC.argile,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      _ReserveBtn(disponible: l.disponible, listing: l),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  COMPOSANTS
// ════════════════════════════════════════════════════════════════════════════

class _ViewToggle extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _ViewToggle({required this.label, required this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: selected ? AppC.brunFonce : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: selected
              ? [BoxShadow(color: AppC.brun.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 2))]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: selected ? AppC.ocreClair : AppC.argile),
            const SizedBox(width: 5),
            Text(label,
              style: TextStyle(
                fontSize: 12,
                color: selected ? Colors.white : AppC.argile,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ReserveBtn extends StatefulWidget {
  final bool disponible;
  final ArtisanListing listing;  // ← ajoute
  const _ReserveBtn({
    required this.disponible,
    required this.listing,        // ← ajoute
  });

  @override State<_ReserveBtn> createState() => _ReserveBtnState();
}

class _ReserveBtnState extends State<_ReserveBtn> {
  bool _p = false;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTapDown:   (_) => setState(() => _p = true),
    onTapUp:     (_) => setState(() => _p = false),
    onTapCancel: ()  => setState(() => _p = false),
    onTap: () {
      if (widget.disponible) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ReservationPage(
                artisan: widget.listing),
          ),
        );
      }
    },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      transform: Matrix4.identity()..scale(_p ? 0.95 : 1.0),
      transformAlignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: widget.disponible
            ? (_p ? AppC.brun : AppC.brunFonce)
            : AppC.argentClair,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.disponible ? AppC.brunFonce : AppC.sable,
        ),
        boxShadow: widget.disponible && !_p
            ? [BoxShadow(color: AppC.brun.withOpacity(0.35), blurRadius: 10, offset: const Offset(0, 4))]
            : [],
      ),
      child: Text(
        widget.disponible ? 'Réserver' : 'Notifier',
        style: TextStyle(
          fontSize: 13,
          color: widget.disponible ? Colors.white : AppC.argile,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

// ════════════════════════════════════════════════════════════════════════════
//  PAINTER
// ════════════════════════════════════════════════════════════════════════════
class _MiniBannerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white..strokeWidth = 0.7..style = PaintingStyle.stroke;
    const step = 24.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
    p.strokeWidth = 0.35;
    for (double x = -size.height; x < size.width + size.height; x += step * 1.4) {
      canvas.drawLine(Offset(x, 0), Offset(x + size.height, size.height), p);
    }
  }
  @override bool shouldRepaint(_) => false;
}
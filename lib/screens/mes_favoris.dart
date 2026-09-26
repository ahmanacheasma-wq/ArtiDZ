import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prise_rdv/main.dart' show AppC;
import 'resultat_recherche.dart' show ArtisanListing, kListings;
import 'package:prise_rdv/screens/profil_artisan.dart' show ProfilArtisan;

// ════════════════════════════════════════════════════════════════════════════
//  PAGE MES FAVORIS
// ════════════════════════════════════════════════════════════════════════════
class MesFavoris extends StatefulWidget {
  const MesFavoris({super.key});

  @override
  State<MesFavoris> createState() => _MesFavorisState();
}

class _MesFavorisState extends State<MesFavoris> {

  // Mock : les 3 premiers artisans sont en favoris
  late final List<ArtisanListing> _favoris = kListings.take(3).toList();

  void _retirerFavori(ArtisanListing artisan) {
    HapticFeedback.lightImpact();
    setState(() => _favoris.remove(artisan));
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        backgroundColor: AppC.brunFonce,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(seconds: 3),
        content: Row(children: [
          const Icon(Icons.favorite_border_rounded,
              size: 16, color: Colors.white70),
          const SizedBox(width: 10),
          Expanded(child: Text('${artisan.name} retiré des favoris',
              style: const TextStyle(fontSize: 12, color: Colors.white,
                  fontWeight: FontWeight.w500))),
          GestureDetector(
            onTap: () {
              setState(() => _favoris.add(artisan));
              ScaffoldMessenger.of(context).clearSnackBars();
            },
            child: const Text('Annuler',
                style: TextStyle(fontSize: 12, color: AppC.ocreClair,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    decorationColor: AppC.ocreClair)),
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.blanc,
      body: Column(children: [

        // ── HEADER ──────────────────────────────────────────────────────
        _buildHeader(context),

        // ── CONTENU ─────────────────────────────────────────────────────
        Expanded(
          child: _favoris.isEmpty
              ? _buildEmpty()
              : ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
            itemCount: _favoris.length,
            itemBuilder: (_, i) => _FavoriCard(
              artisan: _favoris[i],
              onRetirer: () => _retirerFavori(_favoris[i]),
              onVoirProfil: () => Navigator.push(context,
                MaterialPageRoute(
                  builder: (_) => ProfilArtisan(artisan: _favoris[i]),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  HEADER
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildHeader(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Stack(children: [
      Container(
        height: 130 + top,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Color(0xFF3D2B1F), Color(0xFF6B4226),
              Color(0xFFA0715A), Color(0xFFC8922A)],
            stops: [0.0, 0.35, 0.65, 1.0],
          ),
        ),
      ),
      Positioned.fill(
        child: Opacity(opacity: 0.08,
            child: CustomPaint(painter: _Pattern())),
      ),
      Positioned(bottom: -2, left: 0, right: 0,
        child: Container(height: 28,
          decoration: const BoxDecoration(color: AppC.blanc,
              borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
        ),
      ),
      Positioned(top: top + 14, left: 20, right: 20,
        child: Row(children: [
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Container(width: 38, height: 38,
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
          const Text('Mes Favoris',
              style: TextStyle(fontFamily: 'Georgia', fontSize: 17,
                  color: Colors.white, fontWeight: FontWeight.w400,
                  letterSpacing: 0.5)),
          const Spacer(),
          // Compteur
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.25)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.favorite_rounded,
                  size: 11, color: Colors.redAccent),
              const SizedBox(width: 5),
              Text('${_favoris.length}',
                  style: const TextStyle(fontSize: 11, color: Colors.white,
                      fontWeight: FontWeight.w600)),
            ]),
          ),
        ]),
      ),
    ]);
  }

  Widget _buildEmpty() => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text('🤍', style: TextStyle(fontSize: 52)),
      const SizedBox(height: 16),
      const Text('Aucun favori',
          style: TextStyle(fontFamily: 'Georgia', fontSize: 18,
              color: AppC.brunFonce, fontWeight: FontWeight.w400)),
      const SizedBox(height: 8),
      const Text('Ajoutez des artisans à vos favoris\npour les retrouver ici',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: AppC.argile, height: 1.5)),
    ]),
  );
}

// ════════════════════════════════════════════════════════════════════════════
//  CARTE FAVORI
// ════════════════════════════════════════════════════════════════════════════
class _FavoriCard extends StatefulWidget {
  final ArtisanListing artisan;
  final VoidCallback onRetirer;
  final VoidCallback onVoirProfil;
  const _FavoriCard({required this.artisan, required this.onRetirer,
    required this.onVoirProfil});
  @override State<_FavoriCard> createState() => _FavoriCardState();
}

class _FavoriCardState extends State<_FavoriCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final a = widget.artisan;
    return GestureDetector(
      onTapDown:   (_) => setState(() => _pressed = true),
      onTapUp:     (_) => setState(() => _pressed = false),
      onTapCancel: ()  => setState(() => _pressed = false),
      onTap: widget.onVoirProfil,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: _pressed ? AppC.creme : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _pressed
              ? AppC.sable : AppC.sable.withOpacity(0.5)),
          boxShadow: _pressed ? [] : [BoxShadow(
            color: AppC.brun.withOpacity(0.09),
            blurRadius: 14, offset: const Offset(0, 4),
          )],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(children: [

            // ── Avatar ──────────────────────────────────────────────────
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [a.cardAccent.withOpacity(0.85),
                    a.cardAccent.withOpacity(0.35)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
              ),
              child: Center(child: Text(a.emoji,
                  style: const TextStyle(fontSize: 28))),
            ),
            const SizedBox(width: 14),

            // ── Infos ────────────────────────────────────────────────────
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nom + note
                Row(children: [
                  Expanded(child: Text(a.name, style: const TextStyle(
                      fontSize: 14, color: AppC.brunFonce,
                      fontWeight: FontWeight.w600))),
                  Row(children: [
                    const Icon(Icons.star_rounded,
                        size: 12, color: AppC.ocre),
                    const SizedBox(width: 3),
                    Text(a.rating.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 12,
                            color: AppC.brunFonce, fontWeight: FontWeight.w700)),
                  ]),
                ]),
                const SizedBox(height: 3),
                // Métier
                Row(children: [
                  Container(width: 3, height: 10,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                        color: AppC.ocre, borderRadius: BorderRadius.circular(2)),
                  ),
                  Text(a.metier, style: const TextStyle(
                      fontSize: 11, color: AppC.ocre, fontWeight: FontWeight.w500)),
                ]),
                const SizedBox(height: 6),
                // Lieu + dispo
                Row(children: [
                  const Icon(Icons.location_on_outlined,
                      size: 11, color: AppC.argile),
                  const SizedBox(width: 3),
                  Text('${a.quartier}, ${a.wilaya}',
                      style: const TextStyle(fontSize: 10, color: AppC.argile)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: a.disponible
                          ? AppC.success.withOpacity(0.1)
                          : AppC.argentClair,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: a.disponible
                            ? AppC.success.withOpacity(0.3)
                            : AppC.sable,
                      ),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Container(width: 5, height: 5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: a.disponible ? AppC.success : AppC.argile,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(a.disponible ? 'Dispo' : 'Indispo',
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600,
                              color: a.disponible ? AppC.success : AppC.argile)),
                    ]),
                  ),
                ]),
              ],
            )),
            const SizedBox(width: 10),

            // ── Actions ──────────────────────────────────────────────────
            Column(children: [
              // Retirer favori
              GestureDetector(
                onTap: widget.onRetirer,
                child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Colors.redAccent.withOpacity(0.25)),
                  ),
                  child: const Icon(Icons.favorite_rounded,
                      size: 16, color: Colors.redAccent),
                ),
              ),
              const SizedBox(height: 8),
              // Voir profil
              GestureDetector(
                onTap: widget.onVoirProfil,
                child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: AppC.creme,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppC.sable),
                  ),
                  child: const Icon(Icons.arrow_forward_ios_rounded,
                      size: 13, color: AppC.brun),
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  PAINTER
// ════════════════════════════════════════════════════════════════════════════
class _Pattern extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.white..strokeWidth = 0.7
      ..style = PaintingStyle.stroke;
    const step = 30.0;
    for (double x = -size.height; x < size.width + size.height; x += step * 1.5) {
      canvas.drawLine(Offset(x, 0), Offset(x + size.height, size.height), p);
      canvas.drawLine(Offset(x + size.height, 0), Offset(x, size.height), p);
    }
  }
  @override bool shouldRepaint(_) => false;
}
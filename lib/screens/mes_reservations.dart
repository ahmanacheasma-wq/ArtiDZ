import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart' show AppC;

// ════════════════════════════════════════════════════════════════════════════
//  MODÈLES
// ════════════════════════════════════════════════════════════════════════════
enum TypeDemande { creneau, devis }
enum StatutDemande { enAttente, confirme, termine, annule }

class Demande {
  final String id;
  final String artisanNom;
  final String artisanMetier;
  final String artisanEmoji;
  final TypeDemande type;
  final StatutDemande statut;
  final String date;
  final String heure;
  final String wilaya;
  final String quartier;
  final String description;
  final Color accent;

  const Demande({
    required this.id,
    required this.artisanNom,
    required this.artisanMetier,
    required this.artisanEmoji,
    required this.type,
    required this.statut,
    required this.date,
    required this.heure,
    required this.wilaya,
    required this.quartier,
    required this.description,
    required this.accent,
  });
}

// ════════════════════════════════════════════════════════════════════════════
//  DONNÉES SIMULÉES
// ════════════════════════════════════════════════════════════════════════════
final List<Demande> kDemandes = [
  Demande(
    id: 'DEM-001',
    artisanNom: 'Mourad Benali',
    artisanMetier: 'Plomberie',
    artisanEmoji: '🔧',
    type: TypeDemande.creneau,
    statut: StatutDemande.confirme,
    date: "Aujourd'hui",
    heure: '14h00',
    wilaya: 'Alger',
    quartier: 'Bab El Oued',
    description: 'Fuite d\'eau sous l\'évier de la cuisine',
    accent: const Color(0xFF6B4226),
  ),
  Demande(
    id: 'DEM-002',
    artisanNom: 'Karim Meziani',
    artisanMetier: 'Électricité',
    artisanEmoji: '⚡',
    type: TypeDemande.creneau,
    statut: StatutDemande.enAttente,
    date: 'Demain',
    heure: '10h30',
    wilaya: 'Alger',
    quartier: 'Hussein Dey',
    description: 'Panne électrique dans le salon',
    accent: const Color(0xFFC8922A),
  ),
  Demande(
    id: 'DEM-003',
    artisanNom: 'Rachid Boukhalfa',
    artisanMetier: 'Maçonnerie',
    artisanEmoji: '🧱',
    type: TypeDemande.devis,
    statut: StatutDemande.enAttente,
    date: '24 Mars 2026',
    heure: '',
    wilaya: 'Alger',
    quartier: 'Kouba',
    description: 'Construction d\'une pièce supplémentaire de 20m²',
    accent: const Color(0xFF3D2B1F),
  ),
  Demande(
    id: 'DEM-004',
    artisanNom: 'Yacine Amrani',
    artisanMetier: 'Peinture',
    artisanEmoji: '🎨',
    type: TypeDemande.devis,
    statut: StatutDemande.termine,
    date: '15 Mars 2026',
    heure: '',
    wilaya: 'Alger',
    quartier: 'Bir Mourad Raïs',
    description: 'Peinture complète d\'un appartement de 80m²',
    accent: const Color(0xFF8B6A50),
  ),
  Demande(
    id: 'DEM-005',
    artisanNom: 'Sofiane Khelil',
    artisanMetier: 'Menuiserie',
    artisanEmoji: '🪵',
    type: TypeDemande.devis,
    statut: StatutDemande.annule,
    date: '10 Mars 2026',
    heure: '',
    wilaya: 'Alger',
    quartier: 'El Harrach',
    description: 'Fabrication d\'une cuisine sur mesure',
    accent: const Color(0xFFA0715A),
  ),
];

// ════════════════════════════════════════════════════════════════════════════
//  PAGE MES DEMANDES
// ════════════════════════════════════════════════════════════════════════════
class MesReservations extends StatefulWidget {
  const MesReservations({super.key});

  @override
  State<MesReservations> createState() => _MesReservationsState();
}

class _MesReservationsState extends State<MesReservations>
    with SingleTickerProviderStateMixin {

  late final TabController _tab;
  final _tabs = ['Toutes', 'Créneaux', 'Devis', 'Terminées'];

  List<Demande> _filtered(int index) {
    switch (index) {
      case 1:
        return kDemandes
            .where((d) => d.type == TypeDemande.creneau)
            .toList();
      case 2:
        return kDemandes
            .where((d) => d.type == TypeDemande.devis)
            .toList();
      case 3:
        return kDemandes
            .where((d) => d.statut == StatutDemande.termine ||
            d.statut == StatutDemande.annule)
            .toList();
      default:
        return kDemandes;
    }
  }

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: _tabs.length, vsync: this);
    _tab.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.blanc,
      body: Column(children: [
        _buildHeader(context),
        _buildTabBar(),
        Expanded(
          child: TabBarView(
            controller: _tab,
            physics: const BouncingScrollPhysics(),
            children: List.generate(_tabs.length, (i) {
              final list = _filtered(i);
              if (list.isEmpty) return _buildEmpty();
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
                itemCount: list.length,
                itemBuilder: (_, j) => _DemandeCard(
                  demande: list[j],
                  onAnnuler: () => _annuler(list[j]),
                ),
              );
            }),
          ),
        ),
      ]),
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  HEADER
  // ══════════════════════════════════════════════════════════════
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
      Positioned.fill(child: Opacity(opacity: 0.08,
          child: CustomPaint(painter: _Pattern()))),
      Positioned(bottom: -2, left: 0, right: 0,
        child: Container(height: 28,
          decoration: const BoxDecoration(color: AppC.blanc,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(26))),
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
                border: Border.all(
                    color: Colors.white.withOpacity(0.3)),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 14, color: Colors.white),
            ),
          ),
          const Spacer(),
          const Text('Mes Demandes',
            style: TextStyle(fontFamily: 'Georgia', fontSize: 17,
                color: Colors.white, fontWeight: FontWeight.w400,
                letterSpacing: 0.5),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 11, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: Colors.white.withOpacity(0.25)),
            ),
            child: Text('${kDemandes.length} demandes',
              style: const TextStyle(fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ]),
      ),
    ]);
  }

  // ══════════════════════════════════════════════════════════════
  //  TAB BAR
  // ══════════════════════════════════════════════════════════════
  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Container(
        height: 44, padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: AppC.creme,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppC.sable),
        ),
        child: TabBar(
          controller: _tab,
          indicator: BoxDecoration(
            color: AppC.brunFonce,
            borderRadius: BorderRadius.circular(11),
            boxShadow: [BoxShadow(
                color: AppC.brun.withOpacity(0.3),
                blurRadius: 6, offset: const Offset(0, 2))],
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: Colors.white,
          unselectedLabelColor: AppC.argile,
          labelStyle: const TextStyle(
              fontSize: 11, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(
              fontSize: 11, fontWeight: FontWeight.w400),
          tabs: _tabs.map((t) => Tab(text: t)).toList(),
        ),
      ),
    );
  }

  Widget _buildEmpty() => Center(
    child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📋', style: TextStyle(fontSize: 52)),
          const SizedBox(height: 16),
          const Text('Aucune demande',
            style: TextStyle(fontFamily: 'Georgia', fontSize: 18,
                color: AppC.brunFonce, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 8),
          const Text('Vos demandes apparaîtront ici',
              style: TextStyle(fontSize: 13, color: AppC.argile)),
        ]),
  );

  void _annuler(Demande demande) {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: AppC.blanc,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Annuler la demande ?',
              style: TextStyle(fontFamily: 'Georgia', fontSize: 17,
                  color: AppC.brunFonce,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 10),
            Text(
              'Annuler votre demande auprès de '
                  '${demande.artisanNom} ?',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12,
                  color: AppC.argile, height: 1.5),
            ),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(height: 44,
                  decoration: BoxDecoration(
                    color: AppC.creme,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppC.sable),
                  ),
                  child: const Center(child: Text('Garder',
                    style: TextStyle(fontSize: 13,
                        color: AppC.argile,
                        fontWeight: FontWeight.w500),
                  )),
                ),
              )),
              const SizedBox(width: 10),
              Expanded(child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(height: 44,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(
                        color: Colors.redAccent.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3))],
                  ),
                  child: const Center(child: Text('Annuler',
                    style: TextStyle(fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  )),
                ),
              )),
            ]),
          ]),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  CARTE DEMANDE
// ════════════════════════════════════════════════════════════════════════════
class _DemandeCard extends StatelessWidget {
  final Demande demande;
  final VoidCallback onAnnuler;
  const _DemandeCard({required this.demande, required this.onAnnuler});

  Color get _statutColor {
    switch (demande.statut) {
      case StatutDemande.confirme:  return AppC.success;
      case StatutDemande.enAttente: return AppC.ocre;
      case StatutDemande.termine:   return AppC.argile;
      case StatutDemande.annule:    return Colors.redAccent;
    }
  }

  String get _statutLabel {
    switch (demande.statut) {
      case StatutDemande.confirme:  return 'Confirmé';
      case StatutDemande.enAttente: return 'En attente';
      case StatutDemande.termine:   return 'Terminé';
      case StatutDemande.annule:    return 'Annulé';
    }
  }

  IconData get _statutIcon {
    switch (demande.statut) {
      case StatutDemande.confirme:
        return Icons.check_circle_outline_rounded;
      case StatutDemande.enAttente:
        return Icons.schedule_rounded;
      case StatutDemande.termine:
        return Icons.task_alt_rounded;
      case StatutDemande.annule:
        return Icons.cancel_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppC.sable.withOpacity(0.5)),
        boxShadow: [BoxShadow(
          color: AppC.brun.withOpacity(0.08),
          blurRadius: 14, offset: const Offset(0, 4),
        )],
      ),
      child: Column(children: [

        // ── Top : artisan + type + statut ──────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
          child: Row(children: [
            // Avatar
            Container(
              width: 50, height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  colors: [
                    demande.accent.withOpacity(0.8),
                    demande.accent.withOpacity(0.4),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(child: Text(demande.artisanEmoji,
                  style: const TextStyle(fontSize: 24))),
            ),
            const SizedBox(width: 12),

            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(demande.artisanNom,
                  style: const TextStyle(fontSize: 14,
                      color: AppC.brunFonce,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Row(children: [
                  Container(width: 3, height: 10,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                        color: AppC.ocre,
                        borderRadius: BorderRadius.circular(2)),
                  ),
                  Text(demande.artisanMetier,
                    style: const TextStyle(fontSize: 11,
                        color: AppC.ocre,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 8),
                  // Badge type
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: demande.type == TypeDemande.creneau
                          ? AppC.brunFonce.withOpacity(0.08)
                          : AppC.ocre.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      demande.type == TypeDemande.creneau
                          ? '📅 Créneau'
                          : '📋 Devis',
                      style: TextStyle(
                        fontSize: 9,
                        color: demande.type == TypeDemande.creneau
                            ? AppC.brunFonce : AppC.ocre,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ]),
              ],
            )),

            // Statut
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: _statutColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: _statutColor.withOpacity(0.3)),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(_statutIcon, size: 10, color: _statutColor),
                const SizedBox(width: 4),
                Text(_statutLabel,
                  style: TextStyle(fontSize: 9,
                      color: _statutColor,
                      fontWeight: FontWeight.w600),
                ),
              ]),
            ),
          ]),
        ),

        // Séparateur
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Container(height: 1,
              color: AppC.sable.withOpacity(0.4)),
        ),

        // ── Description ─────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
          child: Row(children: [
            const Icon(Icons.notes_rounded,
                size: 13, color: AppC.argile),
            const SizedBox(width: 8),
            Expanded(
              child: Text(demande.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12,
                    color: AppC.argile, height: 1.4),
              ),
            ),
          ]),
        ),

        // ── Infos date/lieu ─────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
          child: Row(children: [
            if (demande.type == TypeDemande.creneau)
              _InfoChip(
                icon: Icons.calendar_today_outlined,
                text: '${demande.date} · ${demande.heure}',
              ),
            if (demande.type == TypeDemande.creneau)
              const SizedBox(width: 8),
            _InfoChip(
              icon: Icons.location_on_outlined,
              text: '${demande.quartier}, ${demande.wilaya}',
            ),
          ]),
        ),

        // ── Actions ─────────────────────────────────────────────
        if (demande.statut == StatutDemande.confirme ||
            demande.statut == StatutDemande.enAttente)
          _buildActions(context),

        if (demande.statut == StatutDemande.termine)
          _buildActionsTermine(context),
      ]),
    );
  }

  Widget _buildActions(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
    child: Row(children: [
      // Annuler
      Expanded(child: GestureDetector(
        onTap: onAnnuler,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0F0),
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
                color: Colors.redAccent.withOpacity(0.25)),
          ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.close_rounded, size: 14,
                    color: Colors.redAccent.withOpacity(0.8)),
                const SizedBox(width: 6),
                Text('Annuler', style: TextStyle(
                    fontSize: 12,
                    color: Colors.redAccent.withOpacity(0.8),
                    fontWeight: FontWeight.w600)),
              ]),
        ),
      )),
      const SizedBox(width: 10),
      // Appeler
      Expanded(child: GestureDetector(
        onTap: () {},
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: AppC.brunFonce,
            borderRadius: BorderRadius.circular(11),
            boxShadow: [BoxShadow(
              color: AppC.brun.withOpacity(0.35),
              blurRadius: 8, offset: const Offset(0, 3),
            )],
          ),
          child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone_rounded, size: 14,
                    color: Colors.white),
                SizedBox(width: 6),
                Text('Appeler', style: TextStyle(
                    fontSize: 12, color: Colors.white,
                    fontWeight: FontWeight.w600)),
              ]),
        ),
      )),
    ]),
  );

  Widget _buildActionsTermine(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
    child: GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity, height: 40,
        decoration: BoxDecoration(
          color: AppC.creme,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: AppC.sable),
        ),
        child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star_outline_rounded,
                  size: 14, color: AppC.ocre),
              SizedBox(width: 6),
              Text('Laisser un avis',
                style: TextStyle(fontSize: 12,
                    color: AppC.brun,
                    fontWeight: FontWeight.w600),
              ),
            ]),
      ),
    ),
  );
}

// ════════════════════════════════════════════════════════════════════════════
//  COMPOSANTS
// ════════════════════════════════════════════════════════════════════════════
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppC.creme,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppC.sable.withOpacity(0.6)),
      ),
      child: Row(children: [
        Icon(icon, size: 12, color: AppC.ocre),
        const SizedBox(width: 6),
        Expanded(child: Text(text,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 10,
              color: AppC.brun,
              fontWeight: FontWeight.w500),
        )),
      ]),
    ),
  );
}

class _Pattern extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white..strokeWidth = 0.7
      ..style = PaintingStyle.stroke;
    const step = 30.0;
    for (double x = -size.height;
    x < size.width + size.height; x += step * 1.5) {
      canvas.drawLine(
          Offset(x, 0), Offset(x + size.height, size.height), p);
      canvas.drawLine(
          Offset(x + size.height, 0), Offset(x, size.height), p);
    }
  }
  @override bool shouldRepaint(_) => false;
}

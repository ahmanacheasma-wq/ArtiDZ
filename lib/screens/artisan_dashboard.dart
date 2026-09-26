import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart' show AppC;
import 'resultat_recherche.dart' show ArtisanListing;

// ════════════════════════════════════════════════════════════════════════════
//  MODÈLE DEMANDE CLIENT
// ════════════════════════════════════════════════════════════════════════════
class DemandeClient {
  final String id;
  final String nomClient;
  final String probleme;
  final String date;
  final String heure;
  final String adresse;
  final String budget;
  final String statut; // 'en_attente', 'confirme', 'termine', 'annule'

  const DemandeClient({
    required this.id,
    required this.nomClient,
    required this.probleme,
    required this.date,
    required this.heure,
    required this.adresse,
    required this.budget,
    required this.statut,
  });
}

// Données mock
final List<DemandeClient> kDemandes = [
  DemandeClient(
    id: '001', nomClient: 'Sonia Bensalem',
    probleme: 'Fuite d\'eau urgente sous l\'évier de cuisine',
    date: 'Aujourd\'hui', heure: '14h00',
    adresse: 'Boufarik, Blida', budget: '3000 DA',
    statut: 'en_attente',
  ),
  DemandeClient(
    id: '002', nomClient: 'Kamel Djebbar',
    probleme: 'Chauffe-eau en panne depuis 2 jours',
    date: 'Demain', heure: '09h00',
    adresse: 'Meftah, Blida', budget: '5000 DA',
    statut: 'en_attente',
  ),
  DemandeClient(
    id: '003', nomClient: 'Farida Mekki',
    probleme: 'Installation d\'un nouveau robinet de salle de bain',
    date: 'Sam 29 Mars', heure: '10h30',
    adresse: 'Blida Centre', budget: '2500 DA',
    statut: 'confirme',
  ),
  DemandeClient(
    id: '004', nomClient: 'Ahmed Bouzid',
    probleme: 'Remplacement tuyauterie salle de bain',
    date: 'Ven 28 Mars', heure: '15h00',
    adresse: 'Bouarfa, Blida', budget: '8000 DA',
    statut: 'termine',
  ),
];

// ════════════════════════════════════════════════════════════════════════════
//  MAIN SHELL ARTISAN
// ════════════════════════════════════════════════════════════════════════════
class ArtisanShell extends StatefulWidget {
  const ArtisanShell({super.key});

  @override
  State<ArtisanShell> createState() => _ArtisanShellState();
}

class _ArtisanShellState extends State<ArtisanShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    _DashboardPage(),
    _DemandesPage(),
    _BudgetPage(),
    _ProfilArtisanEditPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.blanc,
      body: _pages[_currentIndex],
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppC.sable.withOpacity(0.5))),
        boxShadow: [BoxShadow(
          color: AppC.brun.withOpacity(0.08),
          blurRadius: 16, offset: const Offset(0, -4),
        )],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              _NavItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard_rounded,
                  label: 'Accueil', index: 0, current: _currentIndex,
                  onTap: () => setState(() => _currentIndex = 0)),
              _NavItem(icon: Icons.calendar_today_outlined, activeIcon: Icons.calendar_today_rounded,
                  label: 'Demandes', index: 1, current: _currentIndex,
                  badge: kDemandes.where((d) => d.statut == 'en_attente').length,
                  onTap: () => setState(() => _currentIndex = 1)),
              _NavItem(icon: Icons.account_balance_wallet_outlined, activeIcon: Icons.account_balance_wallet_rounded,
                  label: 'Budget', index: 2, current: _currentIndex,
                  onTap: () => setState(() => _currentIndex = 2)),
              _NavItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded,
                  label: 'Mon Profil', index: 3, current: _currentIndex,
                  onTap: () => setState(() => _currentIndex = 3)),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  PAGE 1 — DASHBOARD
// ════════════════════════════════════════════════════════════════════════════
class _DashboardPage extends StatelessWidget {
  const _DashboardPage();

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────
          Container(
            padding: EdgeInsets.fromLTRB(20, top + 16, 20, 28),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [
                  Color(0xFF3D2B1F), Color(0xFF6B4226),
                  Color(0xFFA0715A), Color(0xFFC8922A),
                ],
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: Column(children: [
              Row(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Bonjour,', style: TextStyle(
                      fontSize: 13, color: Colors.white.withOpacity(0.7))),
                  const Text('Karim Benali 👋', style: TextStyle(
                      fontFamily: 'Georgia', fontSize: 22,
                      color: Colors.white, fontWeight: FontWeight.w400)),
                ]),
                const Spacer(),
                Stack(children: [
                  Container(
                    width: 46, height: 46,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.4)),
                    ),
                    child: const Center(child: Text('KB',
                        style: TextStyle(fontSize: 16,
                            fontWeight: FontWeight.w700, color: Colors.white))),
                  ),
                  Positioned(bottom: 0, right: 0,
                    child: Container(
                      width: 14, height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ]),
              ]),
              const SizedBox(height: 20),

              // Stats rapides
              Row(children: [
                _StatCard(value: '12', label: 'Demandes', icon: '📅'),
                const SizedBox(width: 10),
                _StatCard(value: '4.8', label: 'Ma note', icon: '⭐'),
                const SizedBox(width: 10),
                _StatCard(value: '85k', label: 'DA Revenus', icon: '💰'),
              ]),
            ]),
          ),

          const SizedBox(height: 20),

          // ── Demandes du jour ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionTitle(title: 'Demandes du jour',
                    trailing: '${kDemandes.where((d) => d.statut == 'en_attente').length} en attente'),
                const SizedBox(height: 12),
                ...kDemandes.where((d) => d.statut == 'en_attente').take(2).map(
                      (d) => _DemandeCardMini(demande: d),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Disponibilités ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle(title: 'Mes disponibilités'),
                const SizedBox(height: 12),
                _DispoWidget(),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Derniers avis ───────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle(title: 'Derniers avis'),
                const SizedBox(height: 12),
                _AvisCard(nom: 'Sonia B.', note: 5,
                    texte: 'Excellent travail, rapide et propre !',
                    date: 'Il y a 2 jours'),
                _AvisCard(nom: 'Kamel D.', note: 5,
                    texte: 'Très professionnel, tarif raisonnable.',
                    date: 'Il y a 1 semaine'),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  PAGE 2 — DEMANDES
// ════════════════════════════════════════════════════════════════════════════
class _DemandesPage extends StatefulWidget {
  const _DemandesPage();

  @override
  State<_DemandesPage> createState() => _DemandesPageState();
}

class _DemandesPageState extends State<_DemandesPage> {
  String _filter = 'en_attente';

  final Map<String, String> _labels = {
    'en_attente': 'En attente',
    'confirme':   'Confirmé',
    'termine':    'Terminé',
    'annule':     'Annulé',
  };

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final filtered = kDemandes.where((d) => d.statut == _filter).toList();

    return Column(children: [
      // Header
      Container(
        padding: EdgeInsets.fromLTRB(20, top + 16, 20, 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xFFEDE0D0))),
        ),
        child: Column(children: [
          Row(children: [
            const Text('Mes Demandes', style: TextStyle(
                fontFamily: 'Georgia', fontSize: 22,
                color: AppC.brunFonce, fontWeight: FontWeight.w400)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppC.ocre.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppC.ocre.withOpacity(0.3)),
              ),
              child: Text('${kDemandes.length} total',
                  style: const TextStyle(fontSize: 11,
                      color: AppC.ocre, fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 14),

          // Tabs filtres
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _labels.entries.map((e) {
                final sel = _filter == e.key;
                final count = kDemandes.where((d) => d.statut == e.key).length;
                return GestureDetector(
                  onTap: () => setState(() => _filter = e.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: sel ? AppC.brunFonce : AppC.creme,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: sel ? AppC.brunFonce : AppC.sable),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Text(e.value, style: TextStyle(
                          fontSize: 12,
                          color: sel ? Colors.white : AppC.argile,
                          fontWeight: sel ? FontWeight.w700 : FontWeight.w400)),
                      if (count > 0) ...[
                        const SizedBox(width: 6),
                        Container(
                          width: 18, height: 18,
                          decoration: BoxDecoration(
                            color: sel ? AppC.ocre : AppC.argile.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Center(child: Text('$count',
                              style: const TextStyle(fontSize: 9,
                                  color: Colors.white, fontWeight: FontWeight.w700))),
                        ),
                      ],
                    ]),
                  ),
                );
              }).toList(),
            ),
          ),
        ]),
      ),

      // Liste
      Expanded(
        child: filtered.isEmpty
            ? _EmptyState(
          icon: '📭',
          title: 'Aucune demande',
          subtitle: 'Vous n\'avez pas de demandes ${_labels[_filter]!.toLowerCase()}',
        )
            : ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          itemBuilder: (_, i) => _DemandeCardFull(
            demande: filtered[i],
            onAccepter: filtered[i].statut == 'en_attente' ? () {
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                _snack('✅ Demande acceptée !', AppC.brunFonce),
              );
            } : null,
            onRefuser: filtered[i].statut == 'en_attente' ? () {
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                _snack('❌ Demande refusée', const Color(0xFFB71C1C)),
              );
            } : null,
          ),
        ),
      ),
    ]);
  }

  SnackBar _snack(String msg, Color color) => SnackBar(
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
    backgroundColor: color,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    content: Text(msg, style: const TextStyle(
        fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600)),
  );
}

// ════════════════════════════════════════════════════════════════════════════
//  PAGE 3 — BUDGET
// ════════════════════════════════════════════════════════════════════════════
class _BudgetPage extends StatelessWidget {
  const _BudgetPage();

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(children: [
        // Header
        Container(
          padding: EdgeInsets.fromLTRB(20, top + 16, 20, 28),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [Color(0xFF3D2B1F), Color(0xFF6B4226),
                Color(0xFFA0715A), Color(0xFFC8922A)],
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
          ),
          child: Column(children: [
            const Text('Mes Revenus', style: TextStyle(
                fontFamily: 'Georgia', fontSize: 22,
                color: Colors.white, fontWeight: FontWeight.w400)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Column(children: [
                const Text('Total ce mois', style: TextStyle(
                    fontSize: 12, color: Colors.white70)),
                const SizedBox(height: 8),
                const Text('85 000 DA', style: TextStyle(
                    fontFamily: 'Georgia', fontSize: 34,
                    color: Colors.white, fontWeight: FontWeight.w400)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: const Color(0xFF22C55E).withOpacity(0.4)),
                  ),
                  child: const Text('↑ +12% vs mois dernier',
                      style: TextStyle(fontSize: 11,
                          color: Color(0xFF86EFAC),
                          fontWeight: FontWeight.w600)),
                ),
              ]),
            ),
          ]),
        ),

        const SizedBox(height: 20),

        // Stats du mois
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(children: [
            Expanded(child: _BudgetStatCard(
                icon: '✅', value: '8', label: 'Interventions\nterminées',
                color: const Color(0xFF22C55E))),
            const SizedBox(width: 12),
            Expanded(child: _BudgetStatCard(
                icon: '⏳', value: '3', label: 'En cours',
                color: AppC.ocre)),
            const SizedBox(width: 12),
            Expanded(child: _BudgetStatCard(
                icon: '❌', value: '1', label: 'Annulées',
                color: const Color(0xFFEF4444))),
          ]),
        ),

        const SizedBox(height: 20),

        // Historique
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle(title: 'Historique des paiements'),
              const SizedBox(height: 12),
              _PaiementRow(nom: 'Sonia B.', service: 'Réparation fuite',
                  montant: '3 000 DA', date: 'Aujourd\'hui', statut: 'payé'),
              _PaiementRow(nom: 'Kamel D.', service: 'Chauffe-eau',
                  montant: '5 000 DA', date: 'Hier', statut: 'payé'),
              _PaiementRow(nom: 'Farida M.', service: 'Robinet salle de bain',
                  montant: '2 500 DA', date: 'Sam 29 Mars', statut: 'en_attente'),
              _PaiementRow(nom: 'Ahmed B.', service: 'Tuyauterie complète',
                  montant: '8 000 DA', date: 'Ven 28 Mars', statut: 'payé'),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Tarif journalier
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle(title: 'Mon tarif'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppC.sable.withOpacity(0.5)),
                  boxShadow: [BoxShadow(
                    color: AppC.brun.withOpacity(0.08),
                    blurRadius: 12, offset: const Offset(0, 3),
                  )],
                ),
                child: Row(children: [
                  const Icon(Icons.monetization_on_outlined,
                      size: 22, color: AppC.ocre),
                  const SizedBox(width: 12),
                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Tarif journalier',
                            style: TextStyle(fontSize: 12, color: AppC.argile)),
                        Text('3 500 DA / jour',
                            style: TextStyle(fontSize: 16,
                                color: AppC.brunFonce,
                                fontWeight: FontWeight.w700)),
                      ]),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppC.creme,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppC.sable),
                    ),
                    child: const Text('Modifier',
                        style: TextStyle(fontSize: 12,
                            color: AppC.brun, fontWeight: FontWeight.w600)),
                  ),
                ]),
              ),
            ],
          ),
        ),

        const SizedBox(height: 40),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  PAGE 4 — MON PROFIL (Modifier)
// ════════════════════════════════════════════════════════════════════════════
class _ProfilArtisanEditPage extends StatefulWidget {
  const _ProfilArtisanEditPage();

  @override
  State<_ProfilArtisanEditPage> createState() => _ProfilArtisanEditPageState();
}

class _ProfilArtisanEditPageState extends State<_ProfilArtisanEditPage> {
  bool _disponible = true;
  final _nomCtrl  = TextEditingController(text: 'Benali');
  final _prenomCtrl = TextEditingController(text: 'Karim');
  final _telCtrl  = TextEditingController(text: '561719733');
  final _descCtrl = TextEditingController(
      text: 'Artisan qualifié, sérieux et ponctuel. Devis gratuit sous 24h.');
  String _metier  = '🔧 Plomberie';
  String _wilaya  = '09 - Blida';
  String _commune = 'Boufarik';

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(children: [

        // ── Header Profil ────────────────────────────────────────────
        Container(
          padding: EdgeInsets.fromLTRB(20, top + 16, 20, 32),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [Color(0xFF3D2B1F), Color(0xFF6B4226),
                Color(0xFFA0715A), Color(0xFFC8922A)],
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
          ),
          child: Column(children: [
            const Text('Mon Profil', style: TextStyle(
                fontFamily: 'Georgia', fontSize: 22,
                color: Colors.white, fontWeight: FontWeight.w400)),
            const SizedBox(height: 24),

            // Avatar
            Stack(alignment: Alignment.bottomRight, children: [
              Container(
                width: 88, height: 88,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.white.withOpacity(0.4), width: 2.5),
                ),
                child: const Center(child: Text('KB', style: TextStyle(
                    fontFamily: 'Georgia', fontSize: 28,
                    color: Colors.white, fontWeight: FontWeight.w700))),
              ),
              Container(
                width: 30, height: 30,
                decoration: BoxDecoration(
                  color: AppC.ocre,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.camera_alt_rounded,
                    size: 14, color: Colors.white),
              ),
            ]),
            const SizedBox(height: 12),
            const Text('Karim Benali', style: TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),

            // Toggle disponible
            GestureDetector(
              onTap: () => setState(() => _disponible = !_disponible),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _disponible
                      ? const Color(0xFF22C55E).withOpacity(0.2)
                      : Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _disponible
                        ? const Color(0xFF22C55E).withOpacity(0.5)
                        : Colors.white.withOpacity(0.3),
                  ),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    width: 8, height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _disponible
                          ? const Color(0xFF22C55E)
                          : Colors.white54,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _disponible ? 'Disponible' : 'Indisponible',
                    style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600,
                      color: _disponible
                          ? const Color(0xFF86EFAC)
                          : Colors.white70,
                    ),
                  ),
                ]),
              ),
            ),
          ]),
        ),

        const SizedBox(height: 20),

        // ── Infos personnelles ───────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle(title: 'Informations personnelles'),
              const SizedBox(height: 12),

              Row(children: [
                Expanded(child: _EditField(
                    ctrl: _prenomCtrl, label: 'Prénom',
                    icon: Icons.person_outline_rounded)),
                const SizedBox(width: 12),
                Expanded(child: _EditField(
                    ctrl: _nomCtrl, label: 'Nom',
                    icon: Icons.person_outline_rounded)),
              ]),
              const SizedBox(height: 12),

              _EditField(ctrl: _telCtrl, label: 'Téléphone',
                  icon: Icons.phone_outlined, prefix: '+213',
                  type: TextInputType.phone),
              const SizedBox(height: 12),

              // Métier
              _DropdownEdit(
                label: 'Métier',
                icon: Icons.build_outlined,
                value: _metier,
                items: const ['🔧 Plomberie', '⚡ Électricité', '🪵 Menuiserie',
                  '🧱 Maçonnerie', '🎨 Peinture', '🪡 Broderie',
                  '🏺 Poterie', '💎 Bijouterie', '🔩 Serrurerie',
                  '❄️ Climatisation', '🧵 Tissage', '🪑 Tapisserie'],
                onChanged: (v) => setState(() => _metier = v!),
              ),
              const SizedBox(height: 12),

              // Wilaya
              _DropdownEdit(
                label: 'Wilaya',
                icon: Icons.location_on_outlined,
                value: _wilaya,
                items: const ['09 - Blida', '16 - Alger', '31 - Oran',
                  '25 - Constantine', '19 - Sétif'],
                onChanged: (v) => setState(() => _wilaya = v!),
              ),
              const SizedBox(height: 12),

              // Commune
              _DropdownEdit(
                label: 'Commune',
                icon: Icons.location_city_outlined,
                value: _commune,
                items: const ['Boufarik', 'Blida', 'Meftah', 'Chréa',
                  'Bouarfa', 'Bougara'],
                onChanged: (v) => setState(() => _commune = v!),
              ),
              const SizedBox(height: 12),

              // Description
              _label('Description'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppC.argentClair,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppC.sable.withOpacity(0.7)),
                ),
                child: TextField(
                  controller: _descCtrl, maxLines: 4,
                  style: const TextStyle(fontSize: 14, color: AppC.brunFonce),
                  cursorColor: AppC.ocre,
                  decoration: const InputDecoration(
                    hintText: 'Décrivez vos spécialités...',
                    hintStyle: TextStyle(color: AppC.argile, fontSize: 13,
                        fontStyle: FontStyle.italic),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(14),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // ── Disponibilités ───────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle(title: 'Mes heures disponibles'),
              const SizedBox(height: 12),
              _DispoWidget(),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // ── Bouton Sauvegarder ───────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                backgroundColor: AppC.brunFonce,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                content: const Row(children: [
                  Icon(Icons.check_circle_outline_rounded,
                      color: Colors.white, size: 16),
                  SizedBox(width: 10),
                  Text('Profil mis à jour !',
                      style: TextStyle(fontSize: 13, color: Colors.white,
                          fontWeight: FontWeight.w600)),
                ]),
              ));
            },
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
                  blurRadius: 16, offset: const Offset(0, 6),
                )],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save_outlined, size: 18, color: Colors.white),
                  SizedBox(width: 10),
                  Text('Sauvegarder les modifications',
                      style: TextStyle(fontSize: 15, color: Colors.white,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ),

        // Déconnexion
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity, height: 46,
              decoration: BoxDecoration(
                color: AppC.creme,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppC.sable),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout_rounded, size: 16,
                      color: Color(0xFFEF4444)),
                  SizedBox(width: 8),
                  Text('Se déconnecter',
                      style: TextStyle(fontSize: 14,
                          color: Color(0xFFEF4444),
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _label(String t) => Text(t, style: const TextStyle(
      fontSize: 12, fontWeight: FontWeight.w600,
      color: AppC.brunFonce, letterSpacing: 0.3));
}

// ════════════════════════════════════════════════════════════════════════════
//  COMPOSANTS RÉUTILISABLES
// ════════════════════════════════════════════════════════════════════════════

class _NavItem extends StatelessWidget {
  final IconData icon, activeIcon;
  final String label;
  final int index, current;
  final int badge;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon, required this.activeIcon,
    required this.label, required this.index,
    required this.current, required this.onTap,
    this.badge = 0,
  });

  @override
  Widget build(BuildContext context) {
    final sel = index == current;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: sel
                      ? AppC.brunFonce.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(sel ? activeIcon : icon,
                    size: 22,
                    color: sel ? AppC.brunFonce : AppC.argile),
              ),
              if (badge > 0)
                Positioned(top: 0, right: 0,
                  child: Container(
                    width: 16, height: 16,
                    decoration: const BoxDecoration(
                        color: Color(0xFFEF4444), shape: BoxShape.circle),
                    child: Center(child: Text('$badge',
                        style: const TextStyle(fontSize: 9,
                            color: Colors.white, fontWeight: FontWeight.w700))),
                  ),
                ),
            ]),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(
                fontSize: 10,
                color: sel ? AppC.brunFonce : AppC.argile,
                fontWeight: sel ? FontWeight.w700 : FontWeight.w400)),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value, label, icon;
  const _StatCard({required this.value, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(
            fontFamily: 'Georgia', fontSize: 18,
            color: Colors.white, fontWeight: FontWeight.w400)),
        Text(label, style: TextStyle(
            fontSize: 9, color: Colors.white.withOpacity(0.7),
            letterSpacing: 0.3)),
      ]),
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? trailing;
  const _SectionTitle({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) => Row(children: [
    Container(width: 3, height: 16,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppC.ocre, AppC.brun],
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(2),
      ),
    ),
    Text(title, style: const TextStyle(
        fontFamily: 'Georgia', fontSize: 17,
        color: AppC.brunFonce, fontWeight: FontWeight.w400)),
    if (trailing != null) ...[
      const Spacer(),
      Text(trailing!, style: const TextStyle(
          fontSize: 11, color: AppC.ocre, fontWeight: FontWeight.w600)),
    ],
  ]);
}

class _DemandeCardMini extends StatelessWidget {
  final DemandeClient demande;
  const _DemandeCardMini({required this.demande});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppC.sable.withOpacity(0.5)),
      boxShadow: [BoxShadow(
        color: AppC.brun.withOpacity(0.07),
        blurRadius: 10, offset: const Offset(0, 3),
      )],
    ),
    child: Row(children: [
      Container(
        width: 44, height: 44,
        decoration: BoxDecoration(
          color: AppC.ocre.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppC.ocre.withOpacity(0.3)),
        ),
        child: Center(child: Text(
          demande.nomClient[0],
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700,
              color: AppC.ocre),
        )),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(demande.nomClient, style: const TextStyle(
              fontSize: 14, color: AppC.brunFonce, fontWeight: FontWeight.w600)),
          Text(demande.probleme, style: const TextStyle(
              fontSize: 12, color: AppC.argile),
              maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text('${demande.date} à ${demande.heure}', style: const TextStyle(
              fontSize: 11, color: AppC.ocre, fontWeight: FontWeight.w500)),
        ],
      )),
      Container(
        width: 8, height: 8,
        decoration: const BoxDecoration(
            color: Color(0xFFF59E0B), shape: BoxShape.circle),
      ),
    ]),
  );
}

class _DemandeCardFull extends StatelessWidget {
  final DemandeClient demande;
  final VoidCallback? onAccepter;
  final VoidCallback? onRefuser;
  const _DemandeCardFull({
    required this.demande, this.onAccepter, this.onRefuser});

  Color get _statutColor {
    switch (demande.statut) {
      case 'en_attente': return const Color(0xFFF59E0B);
      case 'confirme':   return const Color(0xFF22C55E);
      case 'termine':    return AppC.argile;
      default:           return const Color(0xFFEF4444);
    }
  }

  String get _statutLabel {
    switch (demande.statut) {
      case 'en_attente': return '⏳ En attente';
      case 'confirme':   return '✅ Confirmé';
      case 'termine':    return '🏁 Terminé';
      default:           return '❌ Annulé';
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppC.sable.withOpacity(0.5)),
      boxShadow: [BoxShadow(
        color: AppC.brun.withOpacity(0.08),
        blurRadius: 16, offset: const Offset(0, 4),
      )],
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      // En-tête
      Row(children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppC.brun.withOpacity(0.8), AppC.brunFonce],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Center(child: Text(demande.nomClient[0],
              style: const TextStyle(fontSize: 18, color: Colors.white,
                  fontWeight: FontWeight.w700))),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(demande.nomClient, style: const TextStyle(
                fontSize: 15, color: AppC.brunFonce, fontWeight: FontWeight.w700)),
            Text('${demande.date} • ${demande.heure}',
                style: const TextStyle(fontSize: 12, color: AppC.argile)),
          ],
        )),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: _statutColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _statutColor.withOpacity(0.3)),
          ),
          child: Text(_statutLabel, style: TextStyle(
              fontSize: 10, color: _statutColor, fontWeight: FontWeight.w600)),
        ),
      ]),

      Container(height: 1, color: AppC.sable.withOpacity(0.4),
          margin: const EdgeInsets.symmetric(vertical: 12)),

      // Détails
      _InfoRow(icon: Icons.description_outlined, text: demande.probleme),
      const SizedBox(height: 6),
      _InfoRow(icon: Icons.location_on_outlined, text: demande.adresse),
      const SizedBox(height: 6),
      _InfoRow(icon: Icons.monetization_on_outlined,
          text: 'Budget estimé : ${demande.budget}'),

      // Boutons si en attente
      if (onAccepter != null && onRefuser != null) ...[
        const SizedBox(height: 14),
        Row(children: [
          Expanded(
            child: GestureDetector(
              onTap: onRefuser,
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  color: AppC.creme,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppC.sable),
                ),
                child: const Center(child: Text('Refuser',
                    style: TextStyle(fontSize: 13, color: AppC.argile,
                        fontWeight: FontWeight.w600))),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: onAccepter,
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [AppC.brunFonce, AppC.brun]),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(
                    color: AppC.brun.withOpacity(0.35),
                    blurRadius: 8, offset: const Offset(0, 3),
                  )],
                ),
                child: const Center(child: Text('Accepter',
                    style: TextStyle(fontSize: 13, color: Colors.white,
                        fontWeight: FontWeight.w700))),
              ),
            ),
          ),
        ]),
      ],
    ]),
  );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => Row(children: [
    Icon(icon, size: 14, color: AppC.argile),
    const SizedBox(width: 8),
    Expanded(child: Text(text, style: const TextStyle(
        fontSize: 13, color: AppC.argile, height: 1.4))),
  ]);
}

class _DispoWidget extends StatefulWidget {
  @override
  State<_DispoWidget> createState() => _DispoWidgetState();
}

class _DispoWidgetState extends State<_DispoWidget> {
  final Map<String, Set<String>> _dispo = {
    'Lun': {'8h', '9h', '10h', '14h', '15h'},
    'Mar': {'9h', '11h', '15h'},
    'Mer': {'8h', '10h', '14h'},
    'Jeu': {'9h', '10h', '15h', '16h'},
    'Ven': {'8h', '9h'},
    'Sam': {'10h', '11h'},
    'Dim': {},
  };
  final List<String> _heures = ['8h','9h','10h','11h','14h','15h','16h'];

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppC.sable.withOpacity(0.5)),
      boxShadow: [BoxShadow(
        color: AppC.brun.withOpacity(0.07),
        blurRadius: 12, offset: const Offset(0, 3),
      )],
    ),
    child: Column(
      children: _dispo.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(children: [
            SizedBox(width: 32, child: Text(entry.key,
                style: const TextStyle(fontSize: 11,
                    color: AppC.brunFonce, fontWeight: FontWeight.w700))),
            const SizedBox(width: 8),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _heures.map((h) {
                    final sel = entry.value.contains(h);
                    return GestureDetector(
                      onTap: () => setState(() =>
                      sel ? entry.value.remove(h) : entry.value.add(h)),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: sel ? AppC.brunFonce : AppC.argentClair,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: sel ? AppC.ocre.withOpacity(0.4) : AppC.sable),
                        ),
                        child: Text(h, style: TextStyle(
                            fontSize: 10,
                            color: sel ? Colors.white : AppC.argile,
                            fontWeight: sel ? FontWeight.w700 : FontWeight.w400)),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ]),
        );
      }).toList(),
    ),
  );
}

class _AvisCard extends StatelessWidget {
  final String nom, texte, date;
  final int note;
  const _AvisCard({required this.nom, required this.note,
    required this.texte, required this.date});

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
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: AppC.creme, shape: BoxShape.circle,
          border: Border.all(color: AppC.sable),
        ),
        child: Center(child: Text(nom[0], style: const TextStyle(
            fontSize: 14, color: AppC.brun, fontWeight: FontWeight.w700))),
      ),
      const SizedBox(width: 10),
      Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(nom, style: const TextStyle(
                fontSize: 13, color: AppC.brunFonce, fontWeight: FontWeight.w600)),
            const Spacer(),
            Row(children: List.generate(5, (i) => Icon(
              i < note ? Icons.star_rounded : Icons.star_outline_rounded,
              size: 11, color: i < note ? AppC.ocre : AppC.sable,
            ))),
          ]),
          Text(date, style: const TextStyle(fontSize: 10, color: AppC.argile)),
          const SizedBox(height: 4),
          Text(texte, style: const TextStyle(
              fontSize: 12, color: AppC.argile, height: 1.5)),
        ],
      )),
    ]),
  );
}

class _BudgetStatCard extends StatelessWidget {
  final String icon, value, label;
  final Color color;
  const _BudgetStatCard({required this.icon, required this.value,
    required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppC.sable.withOpacity(0.5)),
      boxShadow: [BoxShadow(
        color: AppC.brun.withOpacity(0.07),
        blurRadius: 10, offset: const Offset(0, 3),
      )],
    ),
    child: Column(children: [
      Text(icon, style: const TextStyle(fontSize: 22)),
      const SizedBox(height: 6),
      Text(value, style: TextStyle(
          fontSize: 20, color: color, fontWeight: FontWeight.w700)),
      const SizedBox(height: 2),
      Text(label, textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10, color: AppC.argile, height: 1.3)),
    ]),
  );
}

class _PaiementRow extends StatelessWidget {
  final String nom, service, montant, date, statut;
  const _PaiementRow({required this.nom, required this.service,
    required this.montant, required this.date, required this.statut});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppC.sable.withOpacity(0.5)),
    ),
    child: Row(children: [
      Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: AppC.creme, borderRadius: BorderRadius.circular(11),
          border: Border.all(color: AppC.sable),
        ),
        child: Center(child: Text(nom[0], style: const TextStyle(
            fontSize: 16, color: AppC.brun, fontWeight: FontWeight.w700))),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(nom, style: const TextStyle(
              fontSize: 13, color: AppC.brunFonce, fontWeight: FontWeight.w600)),
          Text(service, style: const TextStyle(fontSize: 11, color: AppC.argile)),
          Text(date, style: const TextStyle(fontSize: 10, color: AppC.argile)),
        ],
      )),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(montant, style: const TextStyle(
            fontSize: 14, color: AppC.brunFonce, fontWeight: FontWeight.w700)),
        Container(
          margin: const EdgeInsets.only(top: 3),
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(
            color: statut == 'payé'
                ? const Color(0xFF22C55E).withOpacity(0.1)
                : const Color(0xFFF59E0B).withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(statut == 'payé' ? '✅ Payé' : '⏳ Attente',
              style: TextStyle(
                  fontSize: 9, fontWeight: FontWeight.w600,
                  color: statut == 'payé'
                      ? const Color(0xFF22C55E)
                      : const Color(0xFFF59E0B))),
        ),
      ]),
    ]),
  );
}

class _EditField extends StatelessWidget {
  final TextEditingController ctrl;
  final String label;
  final IconData icon;
  final TextInputType type;
  final String? prefix;

  const _EditField({required this.ctrl, required this.label,
    required this.icon, this.type = TextInputType.text, this.prefix});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 12,
          fontWeight: FontWeight.w600, color: AppC.brunFonce)),
      const SizedBox(height: 6),
      Container(
        decoration: BoxDecoration(
          color: AppC.argentClair,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppC.sable.withOpacity(0.7)),
        ),
        child: Row(children: [
          if (prefix != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  border: Border(right: BorderSide(color: AppC.sable))),
              child: Text(prefix!, style: const TextStyle(
                  fontSize: 13, color: AppC.brunFonce, fontWeight: FontWeight.w600)),
            )
          else
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Icon(icon, size: 16, color: AppC.argile),
            ),
          Expanded(child: TextField(
            controller: ctrl, keyboardType: type,
            style: const TextStyle(fontSize: 14, color: AppC.brunFonce),
            cursorColor: AppC.ocre,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
            ),
          )),
        ]),
      ),
    ],
  );
}

class _DropdownEdit extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownEdit({required this.label, required this.value,
    required this.icon, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 12,
          fontWeight: FontWeight.w600, color: AppC.brunFonce)),
      const SizedBox(height: 6),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        decoration: BoxDecoration(
          color: AppC.argentClair,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppC.sable.withOpacity(0.7)),
        ),
        child: Row(children: [
          Icon(icon, size: 16, color: AppC.argile),
          const SizedBox(width: 8),
          Expanded(child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value, isExpanded: true, isDense: true,
              dropdownColor: AppC.blanc,
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: AppC.argile, size: 20),
              style: const TextStyle(color: AppC.brunFonce, fontSize: 14),
              items: items.map((e) => DropdownMenuItem(
                value: e,
                child: Text(e, style: const TextStyle(
                    color: AppC.brunFonce, fontSize: 13)),
              )).toList(),
              onChanged: onChanged,
            ),
          )),
        ]),
      ),
      const SizedBox(height: 12),
    ],
  );
}

class _EmptyState extends StatelessWidget {
  final String icon, title, subtitle;
  const _EmptyState({required this.icon, required this.title,
    required this.subtitle});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(icon, style: const TextStyle(fontSize: 52)),
      const SizedBox(height: 16),
      Text(title, style: const TextStyle(fontFamily: 'Georgia',
          fontSize: 20, color: AppC.brunFonce)),
      const SizedBox(height: 8),
      Text(subtitle, textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13, color: AppC.argile)),
    ]),
  );
}
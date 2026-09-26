import 'package:flutter/material.dart';
import 'package:prise_rdv/main.dart' show AppC;
import 'package:prise_rdv/screens/mes_reservations.dart';
import 'package:prise_rdv/screens/mes_favoris.dart';
// ════════════════════════════════════════════════════════════════════════════
//  PAGE PROFIL UTILISATEUR
// ════════════════════════════════════════════════════════════════════════════
class ProfilUtilisateur extends StatefulWidget {
  const ProfilUtilisateur({super.key});

  @override
  State<ProfilUtilisateur> createState() => _ProfilUtilisateurState();
}

class _ProfilUtilisateurState extends State<ProfilUtilisateur> {

  // ── Données mock utilisateur ───────────────────────────────────────────
  final String _nom       = 'Mourad Benali';
  final String _email     = 'mourad.benali@email.com';
  final String _phone     = '+213 05 55 12 34 56';
  final String _wilaya    = '16 - Alger';
  final String _membre    = 'Membre depuis Mars 2025';

  // Stats
  final int _reservations = 8;
  final int _favoris      = 5;
  final int _avis         = 3;

  bool _notifPush   = true;
  bool _notifEmail  = false;
  bool _darkMode    = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.blanc,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [

          // ── HEADER ────────────────────────────────────────────────────
          SliverToBoxAdapter(child: _buildHeader(context)),

          // ── STATS ─────────────────────────────────────────────────────
          SliverToBoxAdapter(child: _buildStats()),

          // ── INFOS PERSONNELLES ────────────────────────────────────────
          SliverToBoxAdapter(child: _buildSection(
            icon: Icons.person_outline_rounded,
            title: 'Informations personnelles',
            child: Column(children: [
              _InfoRow(icon: Icons.badge_outlined,
                  label: 'Nom complet', value: _nom),
              _divider(),
              _InfoRow(icon: Icons.email_outlined,
                  label: 'Email', value: _email),
              _divider(),
              _InfoRow(icon: Icons.phone_outlined,
                  label: 'Téléphone', value: _phone),
              _divider(),
              _InfoRow(icon: Icons.location_on_outlined,
                  label: 'Wilaya', value: _wilaya),
            ]),
          )),

          // ── PRÉFÉRENCES ───────────────────────────────────────────────
          SliverToBoxAdapter(child: _buildSection(
            icon: Icons.tune_rounded,
            title: 'Préférences',
            child: Column(children: [
              _ToggleRow(
                icon: Icons.notifications_outlined,
                label: 'Notifications push',
                value: _notifPush,
                onChanged: (v) => setState(() => _notifPush = v),
              ),
              _divider(),
              _ToggleRow(
                icon: Icons.email_outlined,
                label: 'Notifications email',
                value: _notifEmail,
                onChanged: (v) => setState(() => _notifEmail = v),
              ),
              _divider(),
              _ToggleRow(
                icon: Icons.dark_mode_outlined,
                label: 'Mode sombre',
                value: _darkMode,
                onChanged: (v) => setState(() => _darkMode = v),
              ),
            ]),
          )),

          // ── COMPTE ────────────────────────────────────────────────────
          SliverToBoxAdapter(child: _buildSection(
            icon: Icons.settings_outlined,
            title: 'Compte',
            child: Column(children: [
              _ActionRow(
                icon: Icons.lock_outline_rounded,
                label: 'Changer le mot de passe',
                onTap: () {},
              ),
              _divider(),
              _ActionRow(
                icon: Icons.shield_outlined,
                label: 'Confidentialité',
                onTap: () {},
              ),
              _divider(),
              _ActionRow(
                icon: Icons.help_outline_rounded,
                label: 'Aide & Support',
                onTap: () {},
              ),
              _divider(),
              _ActionRow(
                icon: Icons.info_outline_rounded,
                label: 'À propos d\'ArtisDZ',
                onTap: () {},
              ),
            ]),
          )),

          // ── DÉCONNEXION ───────────────────────────────────────────────
          SliverToBoxAdapter(child: _buildLogout(context)),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  HEADER
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildHeader(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Stack(
      children: [
        // Fond dégradé
        Container(
          height: 240 + top,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [
                Color(0xFF3D2B1F), Color(0xFF6B4226),
                Color(0xFFA0715A), Color(0xFFC8922A),
              ],
              stops: [0.0, 0.35, 0.65, 1.0],
            ),
          ),
        ),
        // Motif
        Positioned.fill(
          child: Opacity(opacity: 0.08,
              child: CustomPaint(painter: _HeaderPattern())),
        ),
        // Arche blanche
        Positioned(bottom: -2, left: 0, right: 0,
          child: Container(height: 36,
            decoration: const BoxDecoration(
              color: AppC.blanc,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
          ),
        ),
        // Contenu
        Positioned(top: top + 12, left: 20, right: 20,
          child: Column(children: [
            // Barre top
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
              const Text('Mon Profil',
                style: TextStyle(
                  fontFamily: 'Georgia', fontSize: 17,
                  color: Colors.white, fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              // Bouton modifier
              GestureDetector(
                onTap: () => _showEditSheet(context),
                child: Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: const Icon(Icons.edit_outlined,
                      size: 16, color: Colors.white),
                ),
              ),
            ]),
            const SizedBox(height: 20),

            // Avatar
            Stack(
              children: [
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.15),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.4), width: 2.5),
                  ),
                  child: const Center(
                    child: Text('👤',
                        style: TextStyle(fontSize: 36)),
                  ),
                ),
                Positioned(bottom: 0, right: 0,
                  child: Container(
                    width: 24, height: 24,
                    decoration: BoxDecoration(
                      color: AppC.ocre,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.camera_alt_rounded,
                        size: 11, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Nom
            Text(_nom,
              style: const TextStyle(
                fontFamily: 'Georgia', fontSize: 20,
                color: Colors.white, fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 5),
            // Email + date
            Text(_email,
                style: TextStyle(fontSize: 12,
                    color: Colors.white.withOpacity(0.7))),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Text(_membre,
                  style: TextStyle(fontSize: 10,
                      color: Colors.white.withOpacity(0.8))),
            ),
          ]),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  STATS
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildStats() {
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
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const MesReservations())),
            child: _StatCell(
              value: '$_reservations',
              label: 'Réservations',
              icon: Icons.calendar_month_outlined,
              color: AppC.brun,
            ),
          ),
          _vDiv(),
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const MesFavoris())),
            child: _StatCell(
              value: '$_favoris',
              label: 'Favoris',
              icon: Icons.favorite_outline_rounded,
              color: Colors.redAccent,
            ),
          ),
          _vDiv(),
          _StatCell(
            value: '$_avis',
            label: 'Avis donnés',
            icon: Icons.star_outline_rounded,
            color: AppC.ocre,
          ),
        ]),
      ),
    );
  }

  Widget _vDiv() => Container(
      width: 1, height: 40, color: AppC.sable.withOpacity(0.5));

  // ══════════════════════════════════════════════════════════════════════════
  //  SECTION WRAPPER
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildSection({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 30, height: 30,
            decoration: BoxDecoration(
              color: AppC.creme,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: AppC.sable),
            ),
            child: Icon(icon, size: 15, color: AppC.brun),
          ),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(
            fontFamily: 'Georgia', fontSize: 16,
            color: AppC.brunFonce, fontWeight: FontWeight.w400,
          )),
        ]),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppC.sable.withOpacity(0.5)),
            boxShadow: [BoxShadow(
              color: AppC.brun.withOpacity(0.06),
              blurRadius: 12, offset: const Offset(0, 3),
            )],
          ),
          child: child,
        ),
      ]),
    );
  }

  Widget _divider() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(height: 1, color: AppC.sable.withOpacity(0.4)),
  );

  // ══════════════════════════════════════════════════════════════════════════
  //  DÉCONNEXION
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildLogout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: GestureDetector(
        onTap: () => _showLogoutDialog(context),
        child: Container(
          width: double.infinity, height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0F0),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: Colors.redAccent.withOpacity(0.3)),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.logout_rounded, size: 18,
                color: Colors.redAccent.withOpacity(0.8)),
            const SizedBox(width: 10),
            Text('Se déconnecter',
              style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600,
                color: Colors.redAccent.withOpacity(0.8),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  DIALOGS & SHEETS
  // ══════════════════════════════════════════════════════════════════════════
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: AppC.blanc,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0F0),
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.redAccent.withOpacity(0.3)),
              ),
              child: const Icon(Icons.logout_rounded,
                  size: 26, color: Colors.redAccent),
            ),
            const SizedBox(height: 16),
            const Text('Se déconnecter',
                style: TextStyle(fontFamily: 'Georgia', fontSize: 18,
                    color: AppC.brunFonce, fontWeight: FontWeight.w400)),
            const SizedBox(height: 8),
            const Text(
              'Voulez-vous vraiment vous déconnecter de votre compte ?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppC.argile, height: 1.5),
            ),
            const SizedBox(height: 22),
            Row(children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppC.creme,
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: AppC.sable),
                    ),
                    child: const Center(child: Text('Annuler',
                        style: TextStyle(fontSize: 14, color: AppC.argile,
                            fontWeight: FontWeight.w500))),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context)
                        .popUntil((route) => route.isFirst);
                  },
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(13),
                      boxShadow: [BoxShadow(
                        color: Colors.redAccent.withOpacity(0.35),
                        blurRadius: 10, offset: const Offset(0, 4),
                      )],
                    ),
                    child: const Center(child: Text('Déconnecter',
                        style: TextStyle(fontSize: 14, color: Colors.white,
                            fontWeight: FontWeight.w600))),
                  ),
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }

  void _showEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditProfileSheet(
        nom: _nom, email: _email,
        phone: _phone, wilaya: _wilaya,
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  COMPOSANTS
// ════════════════════════════════════════════════════════════════════════════

class _StatCell extends StatelessWidget {
  final String value, label;
  final IconData icon;
  final Color color;
  const _StatCell({required this.value, required this.label,
    required this.icon, required this.color});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(children: [
      Icon(icon, size: 18, color: color),
      const SizedBox(height: 5),
      Text(value, style: const TextStyle(
          fontSize: 18, color: AppC.brunFonce, fontWeight: FontWeight.w700)),
      const SizedBox(height: 2),
      Text(label, style: const TextStyle(
          fontSize: 9, color: AppC.argile, letterSpacing: 0.3)),
    ]),
  );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
    child: Row(children: [
      Container(
        width: 32, height: 32,
        decoration: BoxDecoration(
          color: AppC.creme,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(icon, size: 15, color: AppC.brun),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(
              fontSize: 10, color: AppC.argile, letterSpacing: 0.3)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(
              fontSize: 13, color: AppC.brunFonce, fontWeight: FontWeight.w500)),
        ],
      )),
      const Icon(Icons.chevron_right_rounded, size: 18, color: AppC.sable),
    ]),
  );
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleRow({required this.icon, required this.label,
    required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    child: Row(children: [
      Container(
        width: 32, height: 32,
        decoration: BoxDecoration(
            color: AppC.creme, borderRadius: BorderRadius.circular(9)),
        child: Icon(icon, size: 15, color: AppC.brun),
      ),
      const SizedBox(width: 12),
      Expanded(child: Text(label, style: const TextStyle(
          fontSize: 13, color: AppC.brunFonce, fontWeight: FontWeight.w500))),
      Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: AppC.brunFonce,
        activeTrackColor: AppC.ocre.withOpacity(0.4),
        inactiveThumbColor: AppC.sable,
        inactiveTrackColor: AppC.argentClair,
      ),
    ]),
  );
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionRow({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
              color: AppC.creme, borderRadius: BorderRadius.circular(9)),
          child: Icon(icon, size: 15, color: AppC.brun),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(
            fontSize: 13, color: AppC.brunFonce, fontWeight: FontWeight.w500))),
        const Icon(Icons.chevron_right_rounded, size: 18, color: AppC.sable),
      ]),
    ),
  );
}

// ════════════════════════════════════════════════════════════════════════════
//  SHEET MODIFIER PROFIL
// ════════════════════════════════════════════════════════════════════════════
class _EditProfileSheet extends StatefulWidget {
  final String nom, email, phone, wilaya;
  const _EditProfileSheet({required this.nom, required this.email,
    required this.phone, required this.wilaya});
  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  late final TextEditingController _nomCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;

  @override
  void initState() {
    super.initState();
    _nomCtrl   = TextEditingController(text: widget.nom);
    _emailCtrl = TextEditingController(text: widget.email);
    _phoneCtrl = TextEditingController(text: widget.phone);
  }

  @override
  void dispose() {
    _nomCtrl.dispose(); _emailCtrl.dispose(); _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottom),
      decoration: BoxDecoration(
        color: AppC.blanc,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(
          color: AppC.brun.withOpacity(0.15),
          blurRadius: 30, offset: const Offset(0, -4),
        )],
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        // Poignée
        Container(width: 38, height: 4,
          decoration: BoxDecoration(
              color: AppC.sable, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(height: 18),
        const Text('Modifier le profil',
            style: TextStyle(fontFamily: 'Georgia', fontSize: 18,
                color: AppC.brunFonce, fontWeight: FontWeight.w400)),
        const SizedBox(height: 20),

        _editField('Nom complet', _nomCtrl, Icons.person_outline_rounded),
        const SizedBox(height: 12),
        _editField('Email', _emailCtrl, Icons.email_outlined,
            type: TextInputType.emailAddress),
        const SizedBox(height: 12),
        _editField('Téléphone', _phoneCtrl, Icons.phone_outlined,
            type: TextInputType.phone),
        const SizedBox(height: 22),

        // Bouton sauvegarder
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
            child: const Center(child: Text('Sauvegarder',
                style: TextStyle(fontSize: 15, color: Colors.white,
                    fontWeight: FontWeight.w600))),
          ),
        ),
      ]),
    );
  }

  Widget _editField(String label, TextEditingController ctrl, IconData icon,
      {TextInputType type = TextInputType.text}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(
          fontSize: 11, color: AppC.argile,
          fontWeight: FontWeight.w500, letterSpacing: 0.3)),
      const SizedBox(height: 6),
      Container(
        decoration: BoxDecoration(
          color: AppC.argentClair,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: AppC.sable.withOpacity(0.6)),
        ),
        child: Row(children: [
          Padding(padding: const EdgeInsets.only(left: 14),
              child: Icon(icon, size: 16, color: AppC.argile)),
          Expanded(child: TextField(
            controller: ctrl, keyboardType: type,
            style: const TextStyle(fontSize: 13, color: AppC.brunFonce),
            cursorColor: AppC.ocre,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 10, vertical: 13),
            ),
          )),
        ]),
      ),
    ]);
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  PAINTER
// ════════════════════════════════════════════════════════════════════════════
class _HeaderPattern extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white..strokeWidth = 0.7..style = PaintingStyle.stroke;
    const step = 30.0;
    for (double x = -size.height;
    x < size.width + size.height; x += step * 1.5) {
      canvas.drawLine(Offset(x, 0), Offset(x + size.height, size.height), p);
      canvas.drawLine(Offset(x + size.height, 0), Offset(x, size.height), p);
    }
    p.strokeWidth = 1.0;
    canvas.drawCircle(
        Offset(size.width * 0.85, size.height * 0.4), size.width * 0.3, p);
  }
  @override bool shouldRepaint(_) => false;
}
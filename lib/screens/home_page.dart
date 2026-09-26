import 'package:flutter/material.dart';
import 'resultat_recherche.dart';
import 'auth_page.dart'; // Importera la page d'auth mixte
import 'client_auth_page.dart'; // Importera la page d'auth client
// On suppose que main.dart exporte AppC
import '../main.dart' show AppC;
import 'wilayas_communes.dart';
import 'profil_utilisateur.dart';
// ════════════════════════════════════════════════════════════════════════════
//  MODÈLES (Conservés)
// ════════════════════════════════════════════════════════════════════════════
class Metier {
  final String emoji;
  final String labelFr;
  final String labelAr;
  const Metier(this.emoji, this.labelFr, this.labelAr);
}

const List<Metier> kMetiers = [
  Metier('🔧', 'Plomberie',     'سباكة'),
  Metier('⚡', 'Électricité',   'كهرباء'),
  Metier('🪵', 'Menuiserie',    'نجارة'),
  Metier('🧱', 'Maçonnerie',    'بناء'),
  Metier('🎨', 'Peinture',      'دهن'),
  Metier('🪡', 'Broderie',      'تطريز'),
  Metier('🏺', 'Poterie',       'فخار'),
  Metier('💎', 'Bijouterie',    'مجوهرات'),
  Metier('🔩', 'Serrurerie',    'حدادة'),
  Metier('❄️', 'Climatisation', 'تكييف'),
  Metier('🧵', 'Tissage',       'نسيج'),
  Metier('🪑', 'Tapisserie',    'تنجيد'),
];

const List<String> kWilayas = [
  '01 - Adrar','02 - Chlef','03 - Laghouat','04 - Oum El Bouaghi',
  '05 - Batna','06 - Béjaïa','07 - Biskra','08 - Béchar','09 - Blida',
  '10 - Bouira','11 - Tamanrasset','12 - Tébessa','13 - Tlemcen',
  '14 - Tiaret','15 - Tizi Ouzou','16 - Alger','17 - Djelfa','18 - Jijel',
  '19 - Sétif','20 - Saïda','21 - Skikda','22 - Sidi Bel Abbès',
  '23 - Annaba','24 - Guelma','25 - Constantine','26 - Médéa',
  '27 - Mostaganem','28 - M\'Sila','29 - Mascara','30 - Ouargla',
  '31 - Oran','32 - El Bayadh','33 - Illizi','34 - Bordj Bou Arréridj',
  '35 - Boumerdès','36 - El Tarf','37 - Tindouf','38 - Tissemsilt',
  '39 - El Oued','40 - Khenchela','41 - Souk Ahras','42 - Tipaza',
  '43 - Mila','44 - Aïn Defla','45 - Naâma','46 - Aïn Témouchent',
  '47 - Ghardaïa','48 - Relizane','49 - Timimoun',
  '50 - Bordj Badji Mokhtar','51 - Ouled Djellal','52 - Béni Abbès',
  '53 - In Salah','54 - In Guezzam','55 - Touggourt','56 - Djanet',
  '57 - El M\'Ghair','58 - El Menia',
];

// ════════════════════════════════════════════════════════════════════════════
//  HOME PAGE (Modifiée pour le flux d'authentification)
// ════════════════════════════════════════════════════════════════════════════
class HomePage extends StatefulWidget {
  final bool isLoggedIn;
  const HomePage({super.key, this.isLoggedIn = false});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {

  late bool _isLoggedIn;

  // ── Search state (visible seulement si connecté) ──
  int     _selectedMetier        = 0;
  String? _selectedWilaya;
  String? _selectedCommune;
  String? _selectedMetierDropdown;
  bool    _tried                 = false;
  String  _langue                = 'FR';

  late final AnimationController _anim;
  late final Animation<double>   _fade;
  late final Animation<Offset>   _slide;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = widget.isLoggedIn;
    _anim  = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fade  = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _slide = Tween<Offset>(
        begin: const Offset(0, 0.05), end: Offset.zero)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic));
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  // ── Navigation vers l'auth client ──
  Future<void> _goToAuth({bool isLogin = false}) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
          builder: (_) => ClientAuthPage(isLogin: isLogin)),
    );
    // Si connexion réussie, on déverrouille la recherche
    if (result == true && mounted) {
      setState(() => _isLoggedIn = true);
    }
  }

  void _goToResults() {
    if (_selectedWilaya == null || _selectedMetierDropdown == null) {
      setState(() => _tried = true);
      _showSnack('Veuillez choisir une wilaya et un métier');
      return;
    }
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => ResultatReche(
        metier: _selectedMetierDropdown!,
        commune: _selectedCommune,
        wilaya: _selectedWilaya!,
      ),
    ));
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      backgroundColor: AppC.brunFonce,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Row(children: [
        const Icon(Icons.info_outline_rounded,
            size: 16, color: AppC.ocreClair),
        const SizedBox(width: 10),
        Expanded(child: Text(msg,
            style: const TextStyle(fontSize: 13, color: Colors.white))),
      ]),
    ));
  }

  void _showLangPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _LangPickerSheet(
        current: _langue,
        onSelect: (lang) {
          setState(() => _langue = lang);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.blanc,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: _buildHero(context),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -40),
              child: _isLoggedIn
                  ? _buildSearchCard()
                  : _buildProBanner(), // Modifiée pour style Doctolib
            ),
            Transform.translate(
              offset: Offset(0, _isLoggedIn ? -24 : -8),
              child: _buildMetiers(),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  HERO (Modifié pour le Top Bar style Doctolib)
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildHero(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return SizedBox(
      height: 420,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
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
          Opacity(
            opacity: 0.13,
            child: CustomPaint(
              painter: _HeroGeoPainter(),
              size: const Size(double.infinity, 420),
            ),
          ),
          Positioned(
            top: -50, right: -50,
            child: Container(
              width: 260, height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.white.withOpacity(0.15), width: 1),
              ),
            ),
          ),
          Positioned(
            top: 90, right: 50,
            child: Container(
              width: 70, height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.white.withOpacity(0.1), width: 1),
              ),
            ),
          ),
          Positioned(
            right: 10, bottom: 40,
            child: Opacity(
              opacity: 0.15,
              child: CustomPaint(
                size: const Size(180, 310),
                painter: _ArtisanPainter(),
              ),
            ),
          ),
          Positioned(
            bottom: -2, left: 0, right: 0,
            child: Container(
              height: 55,
              decoration: const BoxDecoration(
                color: AppC.blanc,
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(36)),
              ),
            ),
          ),
          // ── App bar (Modifiée pour Doctolib Style) ──────────────
          Positioned(
            top: topPad + 12, left: 20, right: 20,
            child: Row(children: [
              // Langue
              GestureDetector(
                onTap: _showLangPicker,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 11, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.25)),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.language_rounded,
                        size: 12, color: Colors.white),
                    const SizedBox(width: 5),
                    Text(_langue, style: const TextStyle(
                        fontSize: 10, letterSpacing: 1.5,
                        color: Colors.white,
                        fontWeight: FontWeight.w300)),
                    const SizedBox(width: 3),
                    const Icon(Icons.keyboard_arrow_down_rounded,
                        size: 14, color: Colors.white70),
                  ]),
                ),
              ),
              const Spacer(),
              // Logo
              Column(children: [
                const Text('ArtisDZ', style: TextStyle(
                  fontFamily: 'Georgia', fontSize: 18,
                  fontWeight: FontWeight.w400, color: Colors.white,
                  letterSpacing: 1.2,
                  shadows: [Shadow(color: Colors.black26, blurRadius: 8)],
                )),
                Text('الحرف الجزائرية',
                  style: TextStyle(fontSize: 9,
                      color: AppC.sable.withOpacity(0.9),
                      fontWeight: FontWeight.w300),
                ),
              ]),
              const Spacer(),
              // Bouton connexion (header) — si non connecté
              if (!_isLoggedIn)
                GestureDetector(
                  onTap: () => _goToAuth(isLogin: true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.35)),
                    ),
                    child: const Text('Se connecter',
                      style: TextStyle(fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3),
                    ),
                  ),
                )
              else
              // Avatar connecté
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: AppC.ocre.withOpacity(0.25),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white.withOpacity(0.4)),
                  ),
                  child: const Icon(Icons.person_outline_rounded,
                      size: 20, color: Colors.white),
                ),
            ]),
          ),
          // ── Titre hero ──────────────────────────────────────────
          Positioned(
            left: 26, right: 110, bottom: 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontFamily: 'Georgia', fontSize: 44, height: 1.12,
                      color: Color(0xFFF5ECD7),
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      TextSpan(text: 'Trouvez un\n'),
                      TextSpan(
                        text: 'artisan',
                        style: TextStyle(fontStyle: FontStyle.italic,
                            color: Color(0xFFD9C4A0),
                            fontWeight: FontWeight.w300),
                      ),
                      TextSpan(text: '\nen Algérie'),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(children: [
                  const Text('Simple',
                      style: TextStyle(fontSize: 13,
                          color: Color(0xFFE8D5A8))),
                  _dot(),
                  const Text('Rapide',
                      style: TextStyle(fontSize: 13,
                          color: Color(0xFFE8D5A8))),
                  _dot(),
                  const Text('48 wilayas',
                      style: TextStyle(fontSize: 13,
                          color: Color(0xFFE8D5A8))),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Container(width: 5, height: 5,
        decoration: const BoxDecoration(
            color: AppC.ocre, shape: BoxShape.circle)),
  );

  // ══════════════════════════════════════════════════════════════════════════
  //  BANNER AUTH (visible quand NON connecté) — style Doctolib
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildAuthBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(color: AppC.brun.withOpacity(0.18),
                blurRadius: 30, offset: const Offset(0, 10)),
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('VOTRE ESPACE ARTISDZ',
                style: TextStyle(fontSize: 9, letterSpacing: 2.5,
                    color: AppC.argile, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 14),

              // ── Bouton Se connecter ──────────────────────────────
              GestureDetector(
                onTap: () => _goToAuth(isLogin: true),
                child: Container(
                  width: double.infinity, height: 54,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppC.brunFonce, AppC.brun],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(
                        color: AppC.brun.withOpacity(0.4),
                        blurRadius: 16, offset: const Offset(0, 6))],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_outline_rounded,
                          size: 18, color: Colors.white),
                      SizedBox(width: 10),
                      Text('Se connecter',
                        style: TextStyle(fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ── Séparateur ──────────────────────────────────────
              Row(children: [
                Expanded(child: Container(
                    height: 1, color: AppC.sable.withOpacity(0.5))),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Text('ou',
                      style: TextStyle(fontSize: 11, color: AppC.argile)),
                ),
                Expanded(child: Container(
                    height: 1, color: AppC.sable.withOpacity(0.5))),
              ]),
              const SizedBox(height: 12),

              // ── Bouton Créer un compte ───────────────────────────
              GestureDetector(
                onTap: () => _goToAuth(isLogin: false),
                child: Container(
                  width: double.infinity, height: 52,
                  decoration: BoxDecoration(
                    color: AppC.creme,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppC.sable),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Créer un compte',
                        style: TextStyle(fontSize: 15,
                            color: AppC.brunFonce,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_ios_rounded,
                          size: 13, color: AppC.ocre),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Info text ────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppC.creme,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppC.sable.withOpacity(0.6)),
                ),
                child: Row(children: [
                  const Icon(Icons.lock_outline_rounded,
                      size: 16, color: AppC.argile),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Connectez-vous pour rechercher et réserver vos artisans',
                      style: TextStyle(fontSize: 12,
                          color: AppC.argile, height: 1.4),
                    ),
                  ),
                ]),
              ),
            ]),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  SEARCH CARD (visible seulement quand connecté)
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildSearchCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(color: AppC.brun.withOpacity(0.18),
                blurRadius: 30, offset: const Offset(0, 10)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('TROUVER UN ARTISAN',
              style: TextStyle(fontSize: 9, letterSpacing: 2.5,
                  color: AppC.argile, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),

            // Wilaya
            _DropdownField(
              icon: Icons.location_on_outlined,
              hint: 'Choisir une wilaya...',
              value: _selectedWilaya,
              isSelected: _selectedWilaya != null,
              hasError: _tried && _selectedWilaya == null,
              items: kWilayas.map((w) => DropdownMenuItem(
                value: w,
                child: Text(w, style: const TextStyle(
                    color: AppC.brunFonce, fontSize: 13)),
              )).toList(),
              onChanged: (v) => setState(() {
                _selectedWilaya = v;
                _selectedCommune = null;
                _tried = false;
              }),
            ),
            const SizedBox(height: 10),

            // ── Commune (apparaît seulement si wilaya choisie) ────────────
            if (_selectedWilaya != null)
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                child: Column(children: [
                  _DropdownField(
                    icon: Icons.location_city_outlined,
                    hint: 'Choisir une commune...',
                    value: _selectedCommune,
                    isSelected: _selectedCommune != null,
                    hasError: false,
                    items: (kCommunes[_selectedWilaya] ?? [])
                        .map((c) => DropdownMenuItem(
                      value: c,
                      child: Text(c, style: const TextStyle(
                          color: const Color(0xFF3D2B1F), fontSize: 13)),
                    )).toList(),
                    onChanged: (v) => setState(() {
                      _selectedCommune = v;
                    }),
                  ),
                  const SizedBox(height: 10),
                ]),
              ),

            // Métier
            _DropdownField(
              icon: Icons.build_outlined,
              hint: 'Choisir un métier...',
              value: _selectedMetierDropdown,
              isSelected: _selectedMetierDropdown != null,
              hasError: _tried && _selectedMetierDropdown == null,
              items: kMetiers.map((m) => DropdownMenuItem(
                value: m.labelFr,
                child: Row(children: [
                  Text(m.emoji, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 10),
                  Text(m.labelFr, style: const TextStyle(
                      color: AppC.brunFonce, fontSize: 13)),
                ]),
              )).toList(),
              onChanged: (v) => setState(() {
                _selectedMetierDropdown = v;
                _tried = false;
              }),
            ),
            const SizedBox(height: 14),

            // Bouton Rechercher
            GestureDetector(
              onTap: _goToResults,
              child: Container(
                width: double.infinity, height: 50,
                decoration: BoxDecoration(
                  color: AppC.brunFonce,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(
                      color: AppC.brun.withOpacity(0.4),
                      blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_rounded,
                        size: 18, color: Colors.white),
                    const SizedBox(width: 10),
                    Text(
                      _selectedMetierDropdown != null &&
                          _selectedWilaya != null
                          ? 'Chercher $_selectedMetierDropdown à ${_selectedCommune ?? _selectedWilaya!.substring(5)}'
                          : 'Rechercher',
                      style: const TextStyle(fontSize: 14,
                          color: Colors.white, fontWeight: FontWeight.w600,
                          letterSpacing: 0.3),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  MÉTIERS (Conservés)
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildMetiers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 14),
          child: Text('MÉTIERS POPULAIRES',
            style: TextStyle(fontSize: 9, letterSpacing: 2.5,
                color: AppC.argile, fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const BouncingScrollPhysics(),
            itemCount: kMetiers.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) => _MetierChip(
              metier: kMetiers[i],
              selected: _selectedMetier == i,
              onTap: () {
                setState(() {
                  _selectedMetier = i;
                  if (_isLoggedIn) {
                    _selectedMetierDropdown = kMetiers[i].labelFr;
                  }
                });
                // Si non connecté → inviter à se connecter
                if (!_isLoggedIn) {
                  _showAuthPrompt(kMetiers[i].labelFr);
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 14),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Padding(
            key: ValueKey(_selectedMetier),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 13),
              decoration: BoxDecoration(
                color: AppC.creme,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppC.sable.withOpacity(0.5)),
              ),
              child: Row(children: [
                Text(kMetiers[_selectedMetier].emoji,
                    style: const TextStyle(fontSize: 26)),
                const SizedBox(width: 14),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(kMetiers[_selectedMetier].labelFr,
                      style: const TextStyle(fontSize: 15,
                          color: AppC.brunFonce,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(kMetiers[_selectedMetier].labelAr,
                      style: const TextStyle(
                          fontSize: 13, color: AppC.ocre),
                    ),
                  ],
                )),
                GestureDetector(
                  onTap: () {
                    if (_isLoggedIn) {
                      _goToResults();
                    } else {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_) => const AuthPage(startAsArtisan: true),
                      ));
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 9),
                    decoration: BoxDecoration(
                      color: AppC.brunFonce,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(
                          color: AppC.brun.withOpacity(0.35),
                          blurRadius: 10, offset: const Offset(0, 3))],
                    ),
                    child: Text(
                      _isLoggedIn ? 'Chercher' : 'Inscrire mon activité',  // 👈 CHANGÉ
                      style: const TextStyle(fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ],
    );
  }

  // ── Dialog invitation à se connecter (Modifié) ───────────────────────────
  void _showAuthPrompt(String metierName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppC.blanc,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [BoxShadow(
              color: AppC.brun.withOpacity(0.15),
              blurRadius: 30, offset: const Offset(0, -4))],
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            width: 38, height: 4,
            decoration: BoxDecoration(
                color: AppC.sable,
                borderRadius: BorderRadius.circular(2)),
          ),
          Text('🔍 $metierName',
              style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 12),
          Text('Pour trouver un $metierName près de chez vous',
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'Georgia',
                fontSize: 20, color: AppC.brunFonce, height: 1.3),
          ),
          const SizedBox(height: 8),
          const Text(
            'Connectez-vous ou créez un compte pour accéder à la recherche',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppC.argile,
                height: 1.5),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () {
              if (widget.isLoggedIn) {
                // Déjà connecté → aller au profil
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => const ProfilUtilisateur(),
                ));
              } else {
                // Non connecté → page auth
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => const ClientAuthPage(isLogin: false),
                ));
              }
            },
            child: Container(
              width: widget.isLoggedIn ? 42 : 90,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Center(
                child: widget.isLoggedIn
                    ? const Icon(Icons.person_rounded,
                    color: Colors.white, size: 20)
                    : const Text('Se connecter',
                    style: TextStyle(
                      fontSize: 10, color: Colors.white,
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              _goToAuth(isLogin: false);
            },
            child: Container(
              width: double.infinity, height: 50,
              decoration: BoxDecoration(
                color: AppC.creme,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppC.sable),
              ),
              child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Créer un compte gratuitement',
                        style: TextStyle(fontSize: 14,
                            color: AppC.brunFonce,
                            fontWeight: FontWeight.w600)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_ios_rounded,
                        size: 12, color: AppC.ocre),
                  ]),
            ),
          ),
        ]),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  BANNIÈRE PRO ARTISAN (Redessinée et redirection Artisan Exclusif)
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildProBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [BoxShadow(
              color: AppC.brun.withOpacity(0.18),
              blurRadius: 30, offset: const Offset(0, 10))],
        ),
        child: Column(
          children: [
            Row(children: [
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  color: AppC.creme,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppC.sable),
                ),
                child: const Center(
                    child: Text('⚒️',
                        style: TextStyle(fontSize: 24))),
              ),
              const SizedBox(width: 14),
              const Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('VOUS ÊTES ARTISAN ?',
                    style: TextStyle(fontSize: 10,
                        color: AppC.argile,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 6),
                  Text('Inscrivez-vous gratuitement',
                    style: TextStyle(fontFamily: 'Georgia',
                        fontSize: 17, color: AppC.brunFonce,
                        fontWeight: FontWeight.w400, height: 1.3),
                  ),
                ],
              )),
            ]),
            const SizedBox(height: 20),

            // ── Bouton Redirection Vers AuthArtisanPage ────────────────────
            GestureDetector(
              // Navigation exclusive vers la page d'authentification des artisans
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(
                    // IMPORTANT: Pousser vers une page d'auth spécifique ou AuthPage forcée
                      builder: (_) => const AuthPage(startAsArtisan: true))),
              child: Container(
                width: double.infinity, height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppC.brunFonce, AppC.brun],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(
                      color: AppC.brun.withOpacity(0.4),
                      blurRadius: 16, offset: const Offset(0, 6))],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Inscrire mon activité',
                      style: TextStyle(fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_ios_rounded,
                        size: 13, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  DROPDOWN FIELD (Conservé)
// ════════════════════════════════════════════════════════════════════════════
class _DropdownField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final String? value;
  final bool isSelected;
  final bool hasError;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.icon, required this.hint, required this.value,
    required this.isSelected, required this.items, required this.onChanged,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: AppC.argentClair,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? AppC.ocre.withOpacity(0.5) : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Row(children: [
        Icon(icon, size: 16,
            color: isSelected ? AppC.ocre : AppC.argile),
        const SizedBox(width: 8),
        Expanded(child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value, isExpanded: true, isDense: true,
            dropdownColor: AppC.blanc,
            icon: Icon(Icons.keyboard_arrow_down_rounded,
                color: isSelected ? AppC.ocre : AppC.argile, size: 20),
            style: const TextStyle(color: AppC.brunFonce, fontSize: 14),
            hint: Text(hint,
              style: const TextStyle(color: AppC.argile,
                  fontStyle: FontStyle.italic, fontSize: 14),
            ),
            items: items,
            onChanged: onChanged,
          ),
        )),
        if (isSelected)
          GestureDetector(
            onTap: () => onChanged(null),
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Icon(Icons.close_rounded,
                  size: 16, color: AppC.argile.withOpacity(0.7)),
            ),
          ),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  CHIP MÉTIER (Conservé)
// ════════════════════════════════════════════════════════════════════════════
class _MetierChip extends StatelessWidget {
  final Metier metier;
  final bool selected;
  final VoidCallback onTap;
  const _MetierChip({required this.metier, required this.selected,
    required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 70,
        child: Column(children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            width: 62, height: 62,
            decoration: BoxDecoration(
              gradient: selected ? const LinearGradient(
                colors: [AppC.brun, AppC.brunFonce],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ) : null,
              color: selected ? null : AppC.creme,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: selected
                    ? AppC.ocre.withOpacity(0.4)
                    : AppC.sable.withOpacity(0.6),
                width: selected ? 1.5 : 1,
              ),
              boxShadow: selected ? [BoxShadow(
                  color: AppC.brun.withOpacity(0.35),
                  blurRadius: 12, offset: const Offset(0, 4))] : [],
            ),
            child: Center(
                child: Text(metier.emoji,
                    style: const TextStyle(fontSize: 25))),
          ),
          const SizedBox(height: 6),
          Text(metier.labelFr,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9,
              color: selected ? AppC.brunFonce : AppC.argile,
              fontWeight:
              selected ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ]),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  PAINTERS (Conservés)
// ════════════════════════════════════════════════════════════════════════════
class _HeroGeoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white..strokeWidth = 0.7
      ..style = PaintingStyle.stroke;
    const step = 32.0;
    for (double x = -size.height; x < size.width + size.height;
    x += step * 1.5) {
      canvas.drawLine(Offset(x, 0), Offset(x + size.height, size.height), p);
      canvas.drawLine(
          Offset(x + size.height, 0), Offset(x, size.height), p);
    }
    p.strokeWidth = 1.2;
    canvas.drawCircle(Offset(size.width * 0.78, size.height * 0.42),
        size.width * 0.42, p);
    p.strokeWidth = 0.6;
    canvas.drawCircle(Offset(size.width * 0.78, size.height * 0.42),
        size.width * 0.26, p);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _ArtisanPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white..strokeWidth = 1.3
      ..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final cx = size.width * 0.52;
    canvas.drawCircle(Offset(cx, size.height * 0.13), 25, p);
    final body = Path()
      ..moveTo(cx - 44, size.height * 0.31)
      ..quadraticBezierTo(cx, size.height * 0.25, cx + 44, size.height * 0.31)
      ..lineTo(cx + 55, size.height)
      ..lineTo(cx - 55, size.height)
      ..close();
    canvas.drawPath(body, p);
    canvas.drawLine(Offset(cx - 44, size.height * 0.33),
        Offset(cx - 70, size.height * 0.54), p);
    canvas.drawLine(Offset(cx - 70, size.height * 0.54),
        Offset(cx - 55, size.height * 0.70), p);
    canvas.drawCircle(Offset(cx - 52, size.height * 0.72), 8, p);
    canvas.drawLine(Offset(cx + 44, size.height * 0.33),
        Offset(cx + 62, size.height * 0.52), p);
    p.strokeWidth = 0.6;
    canvas.drawLine(Offset(cx - 44, size.height * 0.52),
        Offset(cx + 44, size.height * 0.52), p);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ════════════════════════════════════════════════════════════════════════════
//  SÉLECTEUR DE LANGUE (Conservé)
// ════════════════════════════════════════════════════════════════════════════
class _LangPickerSheet extends StatelessWidget {
  final String current;
  final void Function(String) onSelect;
  const _LangPickerSheet(
      {required this.current, required this.onSelect});

  static const _langs = [
    {'code': 'FR', 'label': 'Français', 'flag': '🇫🇷',
      'sub': 'Langue française'},
    {'code': 'AR', 'label': 'العربية', 'flag': '🇩🇿',
      'sub': 'اللغة العربية'},
    {'code': 'EN', 'label': 'English', 'flag': '🇬🇧',
      'sub': 'English language'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 24),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF8F2),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(
            color: const Color(0xFF6B4226).withOpacity(0.18),
            blurRadius: 30, offset: const Offset(0, -4))],
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          margin: const EdgeInsets.only(top: 14),
          width: 38, height: 4,
          decoration: BoxDecoration(
              color: const Color(0xFFD9C4A0),
              borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(height: 18),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(children: [
            Icon(Icons.language_rounded,
                size: 18, color: Color(0xFF6B4226)),
            SizedBox(width: 10),
            Text('Choisir la langue',
                style: TextStyle(fontFamily: 'Georgia', fontSize: 17,
                    color: Color(0xFF3D2B1F),
                    fontWeight: FontWeight.w400)),
          ]),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(height: 1,
              color: const Color(0xFFD9C4A0).withOpacity(0.5)),
        ),
        const SizedBox(height: 8),
        ..._langs.map((l) {
          final selected = l['code'] == current;
          return GestureDetector(
            onTap: () => onSelect(l['code']!),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 4),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 13),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF3D2B1F)
                    : const Color(0xFFF5ECD7),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected
                      ? const Color(0xFFC8922A).withOpacity(0.5)
                      : const Color(0xFFD9C4A0),
                ),
                boxShadow: selected ? [BoxShadow(
                    color: const Color(0xFF6B4226).withOpacity(0.3),
                    blurRadius: 10, offset: const Offset(0, 3))] : [],
              ),
              child: Row(children: [
                Text(l['flag']!,
                    style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 14),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l['label']!,
                        style: TextStyle(fontSize: 15,
                            color: selected
                                ? Colors.white
                                : const Color(0xFF3D2B1F),
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(l['sub']!,
                        style: TextStyle(fontSize: 11,
                            color: selected
                                ? Colors.white.withOpacity(0.6)
                                : const Color(0xFFA0715A))),
                  ],
                )),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: selected ? 1.0 : 0.0,
                  child: Container(
                    width: 26, height: 26,
                    decoration: const BoxDecoration(
                        color: Color(0xFFC8922A),
                        shape: BoxShape.circle),
                    child: const Icon(Icons.check_rounded,
                        size: 14, color: Colors.white),
                  ),
                ),
              ]),
            ),
          );
        }),
        const SizedBox(height: 16),
      ]),
    );
  }
}
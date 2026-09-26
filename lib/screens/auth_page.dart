import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart' show AppC;
import 'home_page.dart';
import 'main_shell.dart'; // ← ajoute cette ligne
import 'artisan_dashboard.dart';

// ════════════════════════════════════════════════════════════════════════════
//  AUTH ARTISAN PAGE — Connexion + Inscription exclusivement pour les artisans
// ════════════════════════════════════════════════════════════════════════════
class AuthPage extends StatefulWidget {
  final bool startAsArtisan;
  const AuthPage({super.key, this.startAsArtisan = false});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {

  // 'login' ou 'signup'
  String _view = 'login';

  // ── Connexion ──────────────────────────────────────────────────────────
  final _loginEmail    = TextEditingController();
  final _loginPassword = TextEditingController();
  bool  _loginObscure  = true;
  bool  _loginLoading  = false;

  // ── Inscription Artisan ────────────────────────────────────────────────
  final _aNom      = TextEditingController();
  final _aPrenom   = TextEditingController();
  final _aEmail    = TextEditingController();
  final _aPhone    = TextEditingController();
  final _aPassword = TextEditingController();
  final _aConfirm  = TextEditingController();
  final _aDesc     = TextEditingController();
  bool  _aObscure  = true;
  bool  _aObscure2 = true;
  bool  _aLoading  = false;
  String?   _aMetier;
  String?   _aWilaya;
  int       _aExp   = 1;
  DateTime? _aDateNaissance;
  String?   _aSexe;

  @override
  void dispose() {
    _loginEmail.dispose();  _loginPassword.dispose();
    _aNom.dispose();  _aPrenom.dispose();  _aEmail.dispose();
    _aPhone.dispose(); _aPassword.dispose(); _aConfirm.dispose();
    _aDesc.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 25),
      firstDate: DateTime(1940),
      lastDate: DateTime(now.year - 16),
      locale: const Locale('fr'),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF3D2B1F),
            onPrimary: Colors.white,
            surface: Color(0xFFFDF8F2),
            onSurface: Color(0xFF3D2B1F),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _aDateNaissance = picked);
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.blanc,
      body: Column(children: [
        _buildHeader(),
        const SizedBox(height: 16),
        Expanded(child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _view == 'login' ? _buildLogin() : _buildSignupArtisan(),
        )),
      ]),
    );
  }

  // ════════════════════════════════════════════════════════════════════════
  //  HEADER — Espace Artisan uniquement
  // ════════════════════════════════════════════════════════════════════════
  Widget _buildHeader() {
    final top = MediaQuery.of(context).padding.top;
    return Stack(children: [
      Container(
        height: 170 + top, width: double.infinity,
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
      Positioned.fill(child: Opacity(
          opacity: 0.1, child: CustomPaint(painter: _PatternPainter()))),
      Positioned(
          bottom: -2, left: 0, right: 0,
          child: Container(
              height: 30,
              decoration: const BoxDecoration(
                  color: AppC.blanc,
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(28))))),
      Positioned(
        top: top + 12, left: 0, right: 0,
        child: Column(children: [
          // Bouton retour
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: Container(
                  width: 38, height: 38,
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
            ),
          ),
          const SizedBox(height: 10),

          // Badge ESPACE ARTISAN
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: Colors.white.withOpacity(0.25)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('⚒️', style: TextStyle(fontSize: 14)),
                SizedBox(width: 8),
                Text('ESPACE ARTISAN',
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Titre
          const Text('ArtisDZ',
              style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 26,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(color: Colors.black26, blurRadius: 10)
                  ])),
          const SizedBox(height: 4),
          Text('Bienvenue pour l\'artisan',
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.75),
                  fontWeight: FontWeight.w300)),
        ]),
      ),
    ]);
  }

  // ════════════════════════════════════════════════════════════════════════
  //  CONNEXION ARTISAN
  // ════════════════════════════════════════════════════════════════════════
  Widget _buildLogin() {
    return SingleChildScrollView(
      key: const ValueKey('login'),
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            RichText(text: const TextSpan(
              style: TextStyle(fontFamily: 'Georgia', fontSize: 24,
                  color: AppC.brunFonce, height: 1.3),
              children: [
                TextSpan(text: 'Connectez-vous à\n'),
                TextSpan(text: 'votre espace artisan',
                    style: TextStyle(fontStyle: FontStyle.italic,
                        color: AppC.ocre)),
              ],
            )),
            const SizedBox(height: 6),
            const Text('Gérez votre activité et vos réservations',
                style: TextStyle(fontSize: 13, color: AppC.argile)),
            const SizedBox(height: 28),

            // ── Se connecter avec Google ──────────────────────────────
            GestureDetector(
              onTap: () {
                // TODO: implémenter Google Sign-In
              },
              child: Container(
                width: double.infinity, height: 54,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppC.sable),
                  boxShadow: [BoxShadow(
                      color: AppC.brun.withOpacity(0.08),
                      blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('🌐', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 12),
                    Text('Se connecter avec Google',
                        style: TextStyle(
                            fontSize: 15,
                            color: AppC.brunFonce,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Ou avec email ─────────────────────────────────────────
            _DividerLine(label: 'ou avec votre email'),
            const SizedBox(height: 20),

            _label('Adresse e-mail'),
            const SizedBox(height: 8),
            _Field(
                ctrl: _loginEmail, hint: 'votre@email.com',
                icon: Icons.email_outlined,
                type: TextInputType.emailAddress),
            const SizedBox(height: 16),

            _label('Mot de passe'),
            const SizedBox(height: 8),
            _Field(
                ctrl: _loginPassword, hint: '••••••••',
                icon: Icons.lock_outline_rounded,
                obscure: _loginObscure,
                onToggle: () =>
                    setState(() => _loginObscure = !_loginObscure)),
            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {},
                child: const Text('Mot de passe oublié ?',
                    style: TextStyle(
                        fontSize: 12, color: AppC.ocre,
                        decoration: TextDecoration.underline,
                        decorationColor: AppC.ocre)),
              ),
            ),
            const SizedBox(height: 28),

            _BigBtn(
              label: 'Se connecter',
              loading: _loginLoading,
              onTap: () async {
                setState(() => _loginLoading = true);
                await Future.delayed(
                    const Duration(milliseconds: 1500));
                if (mounted) {
                  setState(() => _loginLoading = false);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (_) => const MainShell()),
                          (route) => false);
                }
              },
            ),



            const SizedBox(height: 30),

            // ── Inscrire mon activité ─────────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppC.creme,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppC.sable),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(children: [
                    Text('⚒️', style: TextStyle(fontSize: 22)),
                    SizedBox(width: 10),
                    Text('Pas encore inscrit ?',
                        style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 17,
                            color: AppC.brunFonce,
                            fontWeight: FontWeight.w400)),
                  ]),
                  const SizedBox(height: 8),
                  const Text(
                    'Rejoignez des milliers d\'artisans algériens et recevez des demandes dans toute l\'Algérie.',
                    style: TextStyle(
                        fontSize: 12, color: AppC.argile, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () =>
                        setState(() => _view = 'signup'),
                    child: Container(
                      width: double.infinity, height: 52,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [AppC.brunFonce, AppC.brun],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(
                            color: AppC.brun.withOpacity(0.4),
                            blurRadius: 14,
                            offset: const Offset(0, 5))],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Inscrire mon activité',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3)),
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
          ]),
    );
  }

  // ════════════════════════════════════════════════════════════════════════
  //  INSCRIPTION ARTISAN
  // ════════════════════════════════════════════════════════════════════════
  Widget _buildSignupArtisan() {
    final passwordsMatch = _aPassword.text.isEmpty && _aConfirm.text.isEmpty
        ? true
        : _aPassword.text == _aConfirm.text;

    return SingleChildScrollView(
      key: const ValueKey('signup_artisan'),
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            GestureDetector(
              onTap: () => setState(() => _view = 'login'),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.arrow_back_ios_new_rounded,
                    size: 13, color: AppC.argile),
                SizedBox(width: 6),
                Text('Retour à la connexion',
                    style: TextStyle(fontSize: 13, color: AppC.argile)),
              ]),
            ),
            const SizedBox(height: 18),

            RichText(text: const TextSpan(
                style: TextStyle(fontFamily: 'Georgia', fontSize: 24,
                    color: AppC.brunFonce, height: 1.3),
                children: [
                  TextSpan(text: 'Inscrire\n'),
                  TextSpan(text: 'mon activité',
                      style: TextStyle(fontStyle: FontStyle.italic,
                          color: AppC.ocre)),
                ])),
            const SizedBox(height: 6),
            const Text("Recevez des demandes dans toute l'Algérie",
                style: TextStyle(fontSize: 13, color: AppC.argile)),
            const SizedBox(height: 22),

            // ── INFOS PERSONNELLES ────────────────────────────────────
            _sectionTitle('INFORMATIONS PERSONNELLES'),
            const SizedBox(height: 12),

            Row(children: [
              Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Nom'), const SizedBox(height: 8),
                    _Field(ctrl: _aNom, hint: 'Benali',
                        icon: Icons.person_outline_rounded),
                  ])),
              const SizedBox(width: 12),
              Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Prénom'), const SizedBox(height: 8),
                    _Field(ctrl: _aPrenom, hint: 'Mourad',
                        icon: Icons.person_outline_rounded),
                  ])),
            ]),
            const SizedBox(height: 14),

            // Date de naissance
            _label('Date de naissance'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                    color: AppC.argentClair,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: _aDateNaissance != null
                            ? AppC.ocre.withOpacity(0.5)
                            : AppC.sable.withOpacity(0.7))),
                child: Row(children: [
                  Icon(Icons.cake_outlined, size: 17,
                      color: _aDateNaissance != null
                          ? AppC.ocre : AppC.argile),
                  const SizedBox(width: 10),
                  Text(
                    _aDateNaissance != null
                        ? _formatDate(_aDateNaissance!)
                        : 'JJ/MM/AAAA',
                    style: TextStyle(fontSize: 14,
                        color: _aDateNaissance != null
                            ? AppC.brunFonce : AppC.argile,
                        fontStyle: _aDateNaissance != null
                            ? FontStyle.normal : FontStyle.italic),
                  ),

                ]),
              ),
            ),
            const SizedBox(height: 14),

            // Sexe
            _label('Sexe'),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: _SexeBtn(
                  label: 'Homme', emoji: '👨',
                  selected: _aSexe == 'Homme',
                  onTap: () => setState(() => _aSexe = 'Homme'))),
              const SizedBox(width: 12),
              Expanded(child: _SexeBtn(
                  label: 'Femme', emoji: '👩',
                  selected: _aSexe == 'Femme',
                  onTap: () => setState(() => _aSexe = 'Femme'))),
            ]),
            const SizedBox(height: 14),

            // Email
            _label('Adresse e-mail'), const SizedBox(height: 8),
            _Field(ctrl: _aEmail, hint: 'votre@email.com',
                icon: Icons.email_outlined,
                type: TextInputType.emailAddress),
            const SizedBox(height: 14),

            // Téléphone
            _label('Téléphone'), const SizedBox(height: 8),
            _Field(ctrl: _aPhone, hint: '05 XX XX XX XX',
                icon: Icons.phone_outlined,
                type: TextInputType.phone, prefix: '+213'),
            const SizedBox(height: 14),

            // Mot de passe
            _label('Mot de passe'), const SizedBox(height: 8),
            _Field(ctrl: _aPassword, hint: '8 caractères minimum',
                icon: Icons.lock_outline_rounded,
                obscure: _aObscure,
                onToggle: () =>
                    setState(() => _aObscure = !_aObscure),
                onChanged: (_) => setState(() {})),
            const SizedBox(height: 8),
            _PasswordStrength(password: _aPassword.text),
            const SizedBox(height: 14),

            // Confirmation
            _label('Confirmer le mot de passe'),
            const SizedBox(height: 8),
            _Field(ctrl: _aConfirm, hint: 'Répétez votre mot de passe',
                icon: Icons.lock_outline_rounded,
                obscure: _aObscure2,
                onToggle: () =>
                    setState(() => _aObscure2 = !_aObscure2),
                onChanged: (_) => setState(() {})),
            const SizedBox(height: 6),
            if (_aConfirm.text.isNotEmpty)
              _PasswordMatchIndicator(match: passwordsMatch),
            const SizedBox(height: 22),

            // ── INFOS PROFESSIONNELLES ────────────────────────────────
            _sectionTitle('INFORMATIONS PROFESSIONNELLES'),
            const SizedBox(height: 12),

            _label('Votre métier'), const SizedBox(height: 8),
            _DropdownField(
              icon: Icons.build_outlined,
              hint: 'Choisir votre métier...',
              value: _aMetier,
              items: const [
                '🔧 Plomberie', '⚡ Électricité', '🪵 Menuiserie',
                '🧱 Maçonnerie', '🎨 Peinture', '🪡 Broderie',
                '🏺 Poterie', '💎 Bijouterie', '🔩 Serrurerie',
                '❄️ Climatisation', '🧵 Tissage', '🪑 Tapisserie',
              ],
              onChanged: (v) => setState(() => _aMetier = v),
            ),
            const SizedBox(height: 14),

            _label("Wilaya d'activité"), const SizedBox(height: 8),
            _DropdownField(
              icon: Icons.location_on_outlined,
              hint: 'Choisir votre wilaya...',
              value: _aWilaya,
              items: const [
                '16 - Alger', '31 - Oran', '25 - Constantine',
                '19 - Sétif', '06 - Béjaïa', '05 - Batna',
                '23 - Annaba', '09 - Blida', '15 - Tizi Ouzou',
                '27 - Mostaganem', '01 - Adrar', '02 - Chlef',
                '03 - Laghouat', '04 - Oum El Bouaghi', '07 - Biskra',
                '08 - Béchar', '10 - Bouira', '11 - Tamanrasset',
                '12 - Tébessa', '13 - Tlemcen', '14 - Tiaret',
                '17 - Djelfa', '18 - Jijel', '20 - Saïda',
                '21 - Skikda', '22 - Sidi Bel Abbès', '24 - Guelma',
                '26 - Médéa', "28 - M'Sila", '29 - Mascara',
                '30 - Ouargla', '32 - El Bayadh', '33 - Illizi',
                '34 - Bordj Bou Arréridj', '35 - Boumerdès',
                '36 - El Tarf', '37 - Tindouf', '38 - Tissemsilt',
                '39 - El Oued', '40 - Khenchela', '41 - Souk Ahras',
                '42 - Tipaza', '43 - Mila', '44 - Aïn Defla',
                '45 - Naâma', '46 - Aïn Témouchent', '47 - Ghardaïa',
                '48 - Relizane', '49 - Timimoun',
                '50 - Bordj Badji Mokhtar', '51 - Ouled Djellal',
                '52 - Béni Abbès', '53 - In Salah', '54 - In Guezzam',
                '55 - Touggourt', '56 - Djanet',
                "57 - El M'Ghair", '58 - El Menia',
              ],
              onChanged: (v) => setState(() => _aWilaya = v),
            ),
            const SizedBox(height: 14),

            // Expérience
            _label("Années d'expérience"), const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: AppC.argentClair,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: AppC.sable.withOpacity(0.7))),
              child: Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        const Icon(Icons.workspace_premium_outlined,
                            size: 17, color: AppC.argile),
                        const SizedBox(width: 8),
                        Text(
                            _aExp == 1
                                ? "1 an d'expérience"
                                : "$_aExp ans d'expérience",
                            style: const TextStyle(
                                fontSize: 14,
                                color: AppC.brunFonce,
                                fontWeight: FontWeight.w600)),
                      ]),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                            color: AppC.ocre.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: AppC.ocre.withOpacity(0.3))),
                        child: Text(
                            _aExp >= 20
                                ? '20+ ans'
                                : '$_aExp an${_aExp > 1 ? 's' : ''}',
                            style: const TextStyle(
                                fontSize: 11,
                                color: AppC.ocre,
                                fontWeight: FontWeight.w600)),
                      ),
                    ]),
                SliderTheme(
                  data: SliderThemeData(
                      activeTrackColor: AppC.brunFonce,
                      inactiveTrackColor: AppC.sable,
                      thumbColor: AppC.ocre,
                      overlayColor: AppC.ocre.withOpacity(0.2),
                      trackHeight: 4),
                  child: Slider(
                      value: _aExp.toDouble(),
                      min: 1, max: 20, divisions: 19,
                      onChanged: (v) =>
                          setState(() => _aExp = v.round())),
                ),
              ]),
            ),
            const SizedBox(height: 14),

            // Description
            _label('Description / Bio'), const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                  color: AppC.argentClair,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: AppC.sable.withOpacity(0.7))),
              child: TextField(
                  controller: _aDesc, maxLines: 4,
                  style: const TextStyle(
                      fontSize: 14, color: AppC.brunFonce),
                  cursorColor: AppC.ocre,
                  decoration: const InputDecoration(
                      hintText:
                      "Décrivez vos spécialités, zone d'intervention...",
                      hintStyle: TextStyle(
                          color: AppC.argile,
                          fontStyle: FontStyle.italic,
                          fontSize: 13),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16))),
            ),
            const SizedBox(height: 22),

            _CguBox(),
            const SizedBox(height: 22),

            _BigBtn(
              label: '⚒️  Inscrire mon activité',
              loading: _aLoading,
              onTap: () async {
                if (_aPassword.text != _aConfirm.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      _errorSnack(
                          'Les mots de passe ne correspondent pas'));
                  return;
                }
                setState(() => _aLoading = true);
                await Future.delayed(
                    const Duration(milliseconds: 1500));
                if (mounted) {
                  setState(() => _aLoading = false);
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (_) =>
                          const ArtisanShell()));
                }
              },
            ),
          ]),
    );
  }

  SnackBar _errorSnack(String msg) => SnackBar(
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
    backgroundColor: const Color(0xFFB71C1C),
    shape:
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    content: Row(children: [
      const Icon(Icons.error_outline_rounded,
          color: Colors.white, size: 16),
      const SizedBox(width: 10),
      Text(msg,
          style: const TextStyle(fontSize: 13, color: Colors.white)),
    ]),
  );

  Widget _sectionTitle(String t) => Row(children: [
    Container(
        width: 3, height: 16,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [AppC.ocre, AppC.brun],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
            borderRadius: BorderRadius.circular(2))),
    Text(t,
        style: const TextStyle(
            fontSize: 9,
            letterSpacing: 2,
            color: AppC.argile,
            fontWeight: FontWeight.w600)),
  ]);

  Widget _label(String t) => Text(t,
      style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppC.brunFonce,
          letterSpacing: 0.3));
}

// ════════════════════════════════════════════════════════════════════════════
//  PAGE BIENVENUE ARTISAN
// ════════════════════════════════════════════════════════════════════════════
class ArtisanWelcomePage extends StatelessWidget {
  const ArtisanWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, height: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2A1A10), Color(0xFF3D2B1F),
                  Color(0xFF6B4226), Color(0xFFC8922A),
                ],
                stops: [0.0, 0.3, 0.6, 1.0])),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(children: [
              const Spacer(),
              Container(
                  width: 110, height: 110,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                      border: Border.all(
                          color: AppC.ocreClair.withOpacity(0.5),
                          width: 2),
                      boxShadow: [BoxShadow(
                          color: AppC.ocre.withOpacity(0.3),
                          blurRadius: 40, spreadRadius: 5)]),
                  child: const Center(
                      child: Text('⚒️',
                          style: TextStyle(fontSize: 50)))),
              const SizedBox(height: 32),
              const Text('Bienvenue\ndans ArtisDZ !',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Georgia', fontSize: 30,
                      color: Colors.white, fontWeight: FontWeight.w400,
                      height: 1.3, letterSpacing: 1)),
              const SizedBox(height: 12),
              Text('مرحباً بك في ArtisDZ',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white.withOpacity(0.65),
                      fontWeight: FontWeight.w300)),
              const SizedBox(height: 36),
              _StepCard(
                  numero: '01',
                  titre: 'Profil en vérification',
                  desc: 'Notre équipe vérifie vos infos sous 24h',
                  icon: Icons.verified_outlined),
              const SizedBox(height: 12),
              _StepCard(
                  numero: '02',
                  titre: 'Recevez des demandes',
                  desc: 'Les clients de votre wilaya vous contactent',
                  icon: Icons.notifications_outlined),
              const SizedBox(height: 12),
              _StepCard(
                  numero: '03',
                  titre: 'Développez votre activité',
                  desc: 'Gérez vos RDV et votre réputation',
                  icon: Icons.trending_up_rounded),
              const Spacer(),
              GestureDetector(
                  onTap: () => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (_) => const ArtisanShell()),
                          (route) => false),
                  child: Container(
                      width: double.infinity, height: 56,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 8))]),
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Accéder à mon tableau de bord',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: AppC.brunFonce,
                                    fontWeight: FontWeight.w700)),
                            SizedBox(width: 10),
                            Icon(Icons.arrow_forward_ios_rounded,
                                size: 14, color: AppC.ocre),
                          ]))),
              const SizedBox(height: 16),
            ]),
          ),
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final String numero, titre, desc;
  final IconData icon;

  const _StepCard({
    required this.numero, required this.titre,
    required this.desc, required this.icon,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border:
        Border.all(color: Colors.white.withOpacity(0.15))),
    child: Row(children: [
      Container(
          width: 42, height: 42,
          decoration: BoxDecoration(
              color: AppC.ocre.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppC.ocre.withOpacity(0.4))),
          child:
          Icon(icon, size: 20, color: AppC.ocreClair)),
      const SizedBox(width: 14),
      Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titre,
                style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 3),
            Text(desc,
                style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.6),
                    height: 1.4)),
          ])),
      Text(numero,
          style: TextStyle(
              fontSize: 22,
              color: Colors.white.withOpacity(0.15),
              fontWeight: FontWeight.w700,
              fontFamily: 'Georgia')),
    ]),
  );
}

// ════════════════════════════════════════════════════════════════════════════
//  DASHBOARD ARTISAN
// ════════════════════════════════════════════════════════════════════════════
class ArtisanDashboard extends StatelessWidget {
  const ArtisanDashboard({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppC.blanc,
    body: const Center(
        child: Text('Dashboard Artisan — bientôt',
            style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 20,
                color: AppC.brunFonce))),
  );
}

// ════════════════════════════════════════════════════════════════════════════
//  COMPOSANTS RÉUTILISABLES
// ════════════════════════════════════════════════════════════════════════════
class _Field extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final IconData icon;
  final TextInputType type;
  final bool? obscure;
  final VoidCallback? onToggle;
  final String? prefix;
  final ValueChanged<String>? onChanged;

  const _Field({
    required this.ctrl, required this.hint, required this.icon,
    this.type = TextInputType.text, this.obscure, this.onToggle,
    this.prefix, this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
        color: AppC.argentClair,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppC.sable.withOpacity(0.7))),
    child: Row(children: [
      if (prefix != null)
        Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(color: AppC.sable))),
            child: Text(prefix!,
                style: const TextStyle(
                    fontSize: 13,
                    color: AppC.brunFonce,
                    fontWeight: FontWeight.w600))),
      if (prefix == null)
        Padding(
            padding: const EdgeInsets.only(left: 14),
            child: Icon(icon, size: 17, color: AppC.argile)),
      Expanded(
          child: TextField(
            controller: ctrl,
            keyboardType: type,
            obscureText: obscure ?? false,
            onChanged: onChanged,
            style: const TextStyle(
                fontSize: 14, color: AppC.brunFonce),
            cursorColor: AppC.ocre,
            decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                    color: AppC.argile,
                    fontStyle: FontStyle.italic,
                    fontSize: 13),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: prefix != null ? 14 : 10,
                    vertical: 14)),
          )),
      if (onToggle != null)
        GestureDetector(
            onTap: onToggle,
            child: Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Icon(
                    (obscure ?? true)
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 17,
                    color: AppC.argile))),
    ]),
  );
}

class _SexeBtn extends StatelessWidget {
  final String label, emoji;
  final bool selected;
  final VoidCallback onTap;

  const _SexeBtn({
    required this.label, required this.emoji,
    required this.selected, required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 52,
      decoration: BoxDecoration(
          color: selected ? AppC.brunFonce : AppC.argentClair,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: selected
                  ? AppC.ocre.withOpacity(0.5)
                  : AppC.sable.withOpacity(0.7),
              width: selected ? 1.5 : 1),
          boxShadow: selected
              ? [BoxShadow(
              color: AppC.brun.withOpacity(0.3),
              blurRadius: 8, offset: const Offset(0, 3))]
              : []),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : AppC.argile)),
          ]),
    ),
  );
}

class _DropdownField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.icon, required this.hint,
    required this.value, required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding:
    const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
    decoration: BoxDecoration(
        color: AppC.argentClair,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: value != null
                ? AppC.ocre.withOpacity(0.5)
                : AppC.sable.withOpacity(0.7),
            width: 1.5)),
    child: Row(children: [
      Icon(icon,
          size: 16,
          color: value != null ? AppC.ocre : AppC.argile),
      const SizedBox(width: 8),
      Expanded(
          child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                  value: value,
                  isExpanded: true,
                  isDense: true,
                  dropdownColor: AppC.blanc,
                  icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color:
                      value != null ? AppC.ocre : AppC.argile,
                      size: 20),
                  style: const TextStyle(
                      color: AppC.brunFonce, fontSize: 14),
                  hint: Text(hint,
                      style: const TextStyle(
                          color: AppC.argile,
                          fontStyle: FontStyle.italic,
                          fontSize: 14)),
                  items: items
                      .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e,
                          style: const TextStyle(
                              color: AppC.brunFonce,
                              fontSize: 13))))
                      .toList(),
                  onChanged: onChanged))),
      if (value != null)
        GestureDetector(
            onTap: () => onChanged(null),
            child: Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Icon(Icons.close_rounded,
                    size: 16,
                    color: AppC.argile.withOpacity(0.7)))),
    ]),
  );
}

class _BigBtn extends StatefulWidget {
  final String label;
  final bool loading;
  final VoidCallback onTap;

  const _BigBtn({
    required this.label, required this.loading,
    required this.onTap,
  });

  @override
  State<_BigBtn> createState() => _BigBtnState();
}

class _BigBtnState extends State<_BigBtn> {
  bool _p = false;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTapDown: (_) => setState(() => _p = true),
    onTapUp: (_) => setState(() => _p = false),
    onTapCancel: () => setState(() => _p = false),
    onTap: widget.loading ? null : widget.onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      transform: Matrix4.identity()..scale(_p ? 0.97 : 1.0),
      transformAlignment: Alignment.center,
      width: double.infinity, height: 52,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: _p
                  ? [AppC.brun, AppC.brunFonce]
                  : [AppC.brunFonce, AppC.brun],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(16),
          boxShadow: _p
              ? []
              : [BoxShadow(
              color: AppC.brun.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 6))]),
      child: Center(
          child: widget.loading
              ? const SizedBox(
              width: 22, height: 22,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white))
              : Row(mainAxisSize: MainAxisSize.min, children: [
            Text(widget.label,
                style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4)),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 13, color: Colors.white),
          ])),
    ),
  );
}

class _CguBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
        color: AppC.creme,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppC.sable)),
    child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: 20, height: 20,
              margin: const EdgeInsets.only(right: 10, top: 1),
              decoration: BoxDecoration(
                  color: AppC.brunFonce,
                  borderRadius: BorderRadius.circular(6)),
              child: const Icon(Icons.check_rounded,
                  size: 13, color: Colors.white)),
          const Expanded(
              child: Text(
                "J'accepte les conditions d'utilisation et la politique de confidentialité d'ArtisDZ",
                style: TextStyle(
                    fontSize: 11.5,
                    color: AppC.argile,
                    height: 1.5),
              )),
        ]),
  );
}

class _DividerLine extends StatelessWidget {
  final String label;

  const _DividerLine({required this.label});

  @override
  Widget build(BuildContext context) => Row(children: [
    Expanded(child: Container(
        height: 1, color: AppC.sable.withOpacity(0.5))),
    Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 14),
        child: Text(label,
            style: const TextStyle(
                fontSize: 11, color: AppC.argile))),
    Expanded(child: Container(
        height: 1, color: AppC.sable.withOpacity(0.5))),
  ]);
}

class _PasswordStrength extends StatelessWidget {
  final String password;

  const _PasswordStrength({required this.password});

  int get _score {
    if (password.isEmpty) return 0;
    int s = 0;
    if (password.length >= 8) s++;
    if (password.contains(RegExp(r'[A-Z]'))) s++;
    if (password.contains(RegExp(r'[0-9]'))) s++;
    if (password.contains(RegExp(r'[!@#$%^&*()_]'))) s++;
    return s;
  }

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox();
    const colors = [
      Colors.transparent, Color(0xFFB71C1C),
      AppC.ocreClair, AppC.ocre, Color(0xFF2E7D32),
    ];
    const labels = ['', 'Faible', 'Moyen', 'Fort', 'Très fort'];
    final s = _score;
    return Row(children: [
      ...List.generate(4, (i) => Expanded(
          child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 4,
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                  color: i < s
                      ? colors[s]
                      : AppC.sable.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2))))),
      const SizedBox(width: 8),
      Text(labels[s],
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: s > 0 ? colors[s] : AppC.argile)),
    ]);
  }
}

class _PasswordMatchIndicator extends StatelessWidget {
  final bool match;

  const _PasswordMatchIndicator({required this.match});

  @override
  Widget build(BuildContext context) => Row(children: [
    Icon(
        match
            ? Icons.check_circle_outline_rounded
            : Icons.cancel_outlined,
        size: 14,
        color: match
            ? const Color(0xFF2E7D32)
            : const Color(0xFFB71C1C)),
    const SizedBox(width: 6),
    Text(
        match
            ? 'Les mots de passe correspondent ✓'
            : 'Les mots de passe ne correspondent pas',
        style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: match
                ? const Color(0xFF2E7D32)
                : const Color(0xFFB71C1C))),
  ]);
}

class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white
      ..strokeWidth = 0.7
      ..style = PaintingStyle.stroke;
    const step = 30.0;
    for (double x = -size.height;
    x < size.width + size.height;
    x += step * 1.5) {
      canvas.drawLine(
          Offset(x, 0), Offset(x + size.height, size.height), p);
      canvas.drawLine(
          Offset(x + size.height, 0), Offset(x, size.height), p);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
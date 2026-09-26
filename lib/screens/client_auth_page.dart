import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart' show AppC;
import 'main_shell.dart';

// ════════════════════════════════════════════════════════════════════════════
//  CLIENT AUTH PAGE — Inscription en étapes + Connexion
//  Retourne true via Navigator.pop(context, true) après auth réussie
// ════════════════════════════════════════════════════════════════════════════
class ClientAuthPage extends StatefulWidget {
  final bool isLogin;
  const ClientAuthPage({super.key, this.isLogin = false});

  @override
  State<ClientAuthPage> createState() => _ClientAuthPageState();
}

class _ClientAuthPageState extends State<ClientAuthPage> {

  // 0 = email  |  1 = identité  |  2 = SMS  |  10 = connexion
  late int _step;

  final _emailCtrl         = TextEditingController();
  String? _civilite;
  final _prenomCtrl        = TextEditingController();
  final _nomCtrl           = TextEditingController();
  final _dateCtrl          = TextEditingController();
  final _phoneCtrl         = TextEditingController();
  final _smsCtrl           = TextEditingController();
  bool  _smsLoading        = false;
  final _loginEmailCtrl    = TextEditingController();
  final _loginPasswordCtrl = TextEditingController();
  bool  _loginObscure      = true;
  bool  _loginLoading      = false;
  bool   _loading          = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _step = widget.isLogin ? 10 : 0;
  }

  @override
  void dispose() {
    _emailCtrl.dispose();   _prenomCtrl.dispose();
    _nomCtrl.dispose();     _dateCtrl.dispose();
    _phoneCtrl.dispose();   _smsCtrl.dispose();
    _loginEmailCtrl.dispose(); _loginPasswordCtrl.dispose();
    super.dispose();
  }

  // ── Retourner true = connecté ──────────────────────────────────────────
  void _onAuthSuccess() {
    // Pop avec true pour signaler la connexion réussie à HomePage
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainShell()),
          (route) => false,
    );  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.blanc,
      body: Column(children: [
        _buildHeader(),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            transitionBuilder: (child, anim) => SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0), end: Offset.zero,
              ).animate(CurvedAnimation(
                  parent: anim, curve: Curves.easeOutCubic)),
              child: FadeTransition(opacity: anim, child: child),
            ),
            child: _buildStep(),
          ),
        ),
      ]),
    );
  }

  Widget _buildHeader() {
    final top = MediaQuery.of(context).padding.top;
    final titles = {
      0: 'S\'inscrire', 1: 'S\'inscrire',
      2: 'Confirmation', 10: 'Se connecter',
    };
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, top + 12, 16, 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFF3D2B1F), Color(0xFF6B4226),
            Color(0xFFA0715A), Color(0xFFC8922A)],
          stops: [0.0, 0.35, 0.65, 1.0],
        ),
      ),
      child: Column(children: [
        Row(children: [
          GestureDetector(
            onTap: () {
              if (_step == 0 || _step == 10) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const MainShell()),
                      (route) => false,
                );
              } else if (_step == 1) {
                setState(() { _step = 0; _error = null; });
              } else if (_step == 2) {
                setState(() { _step = 1; _error = null; });
              }
            },
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
          Text(titles[_step] ?? '',
            style: const TextStyle(fontFamily: 'Georgia', fontSize: 18,
                color: Colors.white, fontWeight: FontWeight.w400,
                letterSpacing: 1),
          ),
          const Spacer(),
          const SizedBox(width: 38),
        ]),
        if (_step != 10) ...[
          const SizedBox(height: 16),
          Row(children: List.generate(3, (i) => Expanded(
            child: Container(
              height: 3,
              margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
              decoration: BoxDecoration(
                color: i <= _step
                    ? Colors.white : Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ))),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Étape ${_step + 1} sur 3',
                  style: TextStyle(fontSize: 10,
                      color: Colors.white.withOpacity(0.7))),
              Text(
                _step == 0 ? 'Email'
                    : _step == 1 ? 'Identité' : 'Confirmation SMS',
                style: TextStyle(fontSize: 10,
                    color: Colors.white.withOpacity(0.7)),
              ),
            ],
          ),
        ],
      ]),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:  return _buildEmail();
      case 1:  return _buildIdentite();
      case 2:  return _buildSMS();
      case 10: return _buildLogin();
      default: return const SizedBox();
    }
  }

  // ══════════════════════════════════════════════════════
  //  ÉTAPE 0 — EMAIL
  // ══════════════════════════════════════════════════════
  Widget _buildEmail() {
    return SingleChildScrollView(
      key: const ValueKey(0),
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50, height: 50,
              decoration: BoxDecoration(
                color: AppC.creme,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppC.sable),
              ),
              child: const Icon(Icons.email_outlined,
                  color: AppC.ocre, size: 24),
            ),
            const SizedBox(height: 20),
            const Text('Saisissez votre\nadresse email',
              style: TextStyle(fontFamily: 'Georgia', fontSize: 26,
                  color: AppC.brunFonce, height: 1.3),
            ),
            const SizedBox(height: 8),
            const Text(
              'Nous utilisons votre email pour sécuriser votre compte',
              style: TextStyle(fontSize: 13, color: AppC.argile,
                  height: 1.5),
            ),
            const SizedBox(height: 32),
            _label('Adresse e-mail'),
            const SizedBox(height: 8),
            _InputField(
              ctrl: _emailCtrl,
              hint: 'nom@email.com',
              icon: Icons.email_outlined,
              type: TextInputType.emailAddress,
            ),
            if (_error != null) ...[
              const SizedBox(height: 10),
              _ErrorBox(message: _error!),
            ],
            const SizedBox(height: 32),
            _ContinueBtn(
              loading: _loading,
              onTap: () {
                if (_emailCtrl.text.isEmpty ||
                    !_emailCtrl.text.contains('@')) {
                  setState(() =>
                  _error = 'Veuillez saisir un email valide');
                  return;
                }
                setState(() { _error = null; _step = 1; });
              },
            ),
            const SizedBox(height: 28),
            Center(child: GestureDetector(
              onTap: () => setState(() { _step = 10; _error = null; }),
              child: RichText(text: const TextSpan(
                style: TextStyle(fontSize: 13, color: AppC.argile),
                children: [
                  TextSpan(text: 'Déjà un compte ? '),
                  TextSpan(text: 'Se connecter',
                      style: TextStyle(color: AppC.brunFonce,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                          decorationColor: AppC.brunFonce)),
                ],
              )),
            )),
          ]),
    );
  }

  // ══════════════════════════════════════════════════════
  //  ÉTAPE 1 — IDENTITÉ
  // ══════════════════════════════════════════════════════
  Widget _buildIdentite() {
    return SingleChildScrollView(
      key: const ValueKey(1),
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppC.creme,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppC.sable),
              ),
              child: Row(children: [
                const Icon(Icons.person_outline_rounded,
                    size: 16, color: AppC.argile),
                const SizedBox(width: 10),
                Text(_emailCtrl.text,
                    style: const TextStyle(fontSize: 13,
                        color: AppC.brunFonce)),
              ]),
            ),
            const SizedBox(height: 20),
            const Text('Renseignez\nvotre identité',
              style: TextStyle(fontFamily: 'Georgia', fontSize: 26,
                  color: AppC.brunFonce, height: 1.3),
            ),
            const SizedBox(height: 6),
            const Text('Tous les champs sont obligatoires',
                style: TextStyle(fontSize: 13, color: AppC.argile)),
            const SizedBox(height: 24),
            _label('Civilité'),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: _CiviliteBtn(
                label: 'Féminin', emoji: '👩',
                selected: _civilite == 'F',
                onTap: () => setState(() => _civilite = 'F'),
              )),
              const SizedBox(width: 12),
              Expanded(child: _CiviliteBtn(
                label: 'Masculin', emoji: '👨',
                selected: _civilite == 'M',
                onTap: () => setState(() => _civilite = 'M'),
              )),
            ]),
            const SizedBox(height: 16),
            _label('Prénom'),
            const SizedBox(height: 8),
            _InputField(ctrl: _prenomCtrl,
                hint: 'Votre prénom',
                icon: Icons.person_outline_rounded),
            const SizedBox(height: 14),
            _label('Nom'),
            const SizedBox(height: 8),
            _InputField(ctrl: _nomCtrl,
                hint: 'Votre nom de famille',
                icon: Icons.person_outline_rounded),
            const SizedBox(height: 14),
            _label('Date de naissance'),
            const SizedBox(height: 8),
            _InputField(
              ctrl: _dateCtrl,
              hint: 'jj/mm/aaaa',
              icon: Icons.calendar_today_outlined,
              type: TextInputType.number,
              inputFormatters: [_DateInputFormatter()],
            ),
            const SizedBox(height: 14),
            _label('Numéro de téléphone'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppC.argentClair,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppC.sable.withOpacity(0.7)),
              ),
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppC.creme,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14),
                      bottomLeft: Radius.circular(14),
                    ),
                    border: Border(
                        right: BorderSide(color: AppC.sable)),
                  ),
                  child: const Row(mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('🇩🇿',
                            style: TextStyle(fontSize: 16)),
                        SizedBox(width: 6),
                        Text('+213',
                          style: TextStyle(fontSize: 14,
                              color: AppC.brunFonce,
                              fontWeight: FontWeight.w600),
                        ),
                      ]),
                ),
                Expanded(child: TextField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(9),
                    _PhoneFormatter(),
                  ],
                  style: const TextStyle(fontSize: 14,
                      color: AppC.brunFonce),
                  cursorColor: AppC.ocre,
                  decoration: const InputDecoration(
                    hintText: '5XX XX XX XX',
                    hintStyle: TextStyle(color: AppC.argile,
                        fontStyle: FontStyle.italic, fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                  ),
                )),
              ]),
            ),
            const SizedBox(height: 6),
            Text('Ex: 551 23 45 67  →  +213 551 23 45 67',
              style: TextStyle(fontSize: 10,
                  color: AppC.argile.withOpacity(0.7),
                  fontStyle: FontStyle.italic),
            ),
            if (_error != null) ...[
              const SizedBox(height: 10),
              _ErrorBox(message: _error!),
            ],
            const SizedBox(height: 32),
            _ContinueBtn(
              loading: _loading,
              onTap: () {
                if (_civilite == null) {
                  setState(() =>
                  _error = 'Veuillez choisir votre civilité');
                  return;
                }
                if (_prenomCtrl.text.isEmpty) {
                  setState(() =>
                  _error = 'Veuillez saisir votre prénom');
                  return;
                }
                if (_nomCtrl.text.isEmpty) {
                  setState(() =>
                  _error = 'Veuillez saisir votre nom');
                  return;
                }
                if (_phoneCtrl.text.length < 9) {
                  setState(() =>
                  _error = 'Numéro de téléphone invalide');
                  return;
                }
                setState(() { _error = null; _step = 2; });
              },
            ),
          ]),
    );
  }

  // ══════════════════════════════════════════════════════
  //  ÉTAPE 2 — SMS
  // ══════════════════════════════════════════════════════
  Widget _buildSMS() {
    return SingleChildScrollView(
      key: const ValueKey(2),
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50, height: 50,
              decoration: BoxDecoration(
                color: AppC.creme,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppC.sable),
              ),
              child: const Icon(Icons.phone_android_outlined,
                  color: AppC.ocre, size: 24),
            ),
            const SizedBox(height: 20),
            const Text('Saisissez le code\nreçu par SMS',
              style: TextStyle(fontFamily: 'Georgia', fontSize: 26,
                  color: AppC.brunFonce, height: 1.3),
            ),
            const SizedBox(height: 8),
            RichText(text: TextSpan(
              style: const TextStyle(fontSize: 13,
                  color: AppC.argile, height: 1.5),
              children: [
                const TextSpan(text: 'Nous avons envoyé un SMS au\n'),
                TextSpan(
                  text: '+213 ${_phoneCtrl.text}',
                  style: const TextStyle(color: AppC.brunFonce,
                      fontWeight: FontWeight.w600),
                ),
              ],
            )),
            const SizedBox(height: 32),
            _label('Code de vérification'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (i) => _SmsBox(
                index: i,
                onChanged: (val) {},
              )),
            ),
            const SizedBox(height: 16),
            Center(child: GestureDetector(
              onTap: () {},
              child: const Text('Vous n\'avez pas reçu de SMS ?',
                style: TextStyle(fontSize: 13, color: AppC.ocre,
                    decoration: TextDecoration.underline,
                    decorationColor: AppC.ocre),
              ),
            )),
            if (_error != null) ...[
              const SizedBox(height: 10),
              _ErrorBox(message: _error!),
            ],
            const SizedBox(height: 32),
            _ContinueBtn(
              label: 'Confirmer',
              loading: _smsLoading,
              onTap: () async {
                setState(() { _smsLoading = true; _error = null; });
                await Future.delayed(
                    const Duration(milliseconds: 1200));
                if (mounted) {
                  setState(() => _smsLoading = false);
                  _onAuthSuccess(); // ← retourne true à HomePage
                }
              },
            ),
          ]),
    );
  }

  // ══════════════════════════════════════════════════════
  //  CONNEXION
  // ══════════════════════════════════════════════════════
  Widget _buildLogin() {
    return SingleChildScrollView(
      key: const ValueKey(10),
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50, height: 50,
              decoration: BoxDecoration(
                color: AppC.creme,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppC.sable),
              ),
              child: const Icon(Icons.lock_outline_rounded,
                  color: AppC.ocre, size: 24),
            ),
            const SizedBox(height: 20),
            const Text('Bienvenue\nde retour',
              style: TextStyle(fontFamily: 'Georgia', fontSize: 26,
                  color: AppC.brunFonce, height: 1.3),
            ),
            const SizedBox(height: 8),
            const Text('Connectez-vous à votre compte ArtisDZ',
                style: TextStyle(fontSize: 13, color: AppC.argile)),
            const SizedBox(height: 32),
            _label('Adresse e-mail'),
            const SizedBox(height: 8),
            _InputField(
              ctrl: _loginEmailCtrl,
              hint: 'votre@email.com',
              icon: Icons.email_outlined,
              type: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _label('Mot de passe'),
            const SizedBox(height: 8),
            _InputField(
              ctrl: _loginPasswordCtrl,
              hint: '••••••••',
              icon: Icons.lock_outline_rounded,
              obscure: _loginObscure,
              onToggle: () =>
                  setState(() => _loginObscure = !_loginObscure),
            ),
            const SizedBox(height: 10),
            Align(alignment: Alignment.centerRight,
              child: GestureDetector(onTap: () {},
                child: const Text('Mot de passe oublié ?',
                    style: TextStyle(fontSize: 12, color: AppC.ocre,
                        decoration: TextDecoration.underline,
                        decorationColor: AppC.ocre)),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 10),
              _ErrorBox(message: _error!),
            ],
            const SizedBox(height: 28),
            _ContinueBtn(
              label: 'Se connecter',
              loading: _loginLoading,
              onTap: () async {
                if (_loginEmailCtrl.text.isEmpty ||
                    _loginPasswordCtrl.text.isEmpty) {
                  setState(() =>
                  _error = 'Remplissez tous les champs');
                  return;
                }
                setState(() {
                  _loginLoading = true; _error = null;
                });
                await Future.delayed(
                    const Duration(milliseconds: 1200));
                if (mounted) {
                  setState(() => _loginLoading = false);
                  _onAuthSuccess(); // ← retourne true à HomePage
                }
              },
            ),
            const SizedBox(height: 22),
            Row(children: [
              Expanded(child: Container(height: 1,
                  color: AppC.sable.withOpacity(0.5))),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Text('ou',
                    style: TextStyle(fontSize: 11, color: AppC.argile)),
              ),
              Expanded(child: Container(height: 1,
                  color: AppC.sable.withOpacity(0.5))),
            ]),
            const SizedBox(height: 22),
            GestureDetector(
              onTap: () =>
                  setState(() { _step = 0; _error = null; }),
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
          ]),
    );
  }

  Widget _label(String t) => Text(t,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
          color: AppC.brunFonce, letterSpacing: 0.3));
}

// ════════════════════════════════════════════════════════════════════════════
//  WIDGET — Case SMS
// ════════════════════════════════════════════════════════════════════════════
class _SmsBox extends StatefulWidget {
  final int index;
  final ValueChanged<String> onChanged;
  const _SmsBox({required this.index, required this.onChanged});
  @override
  State<_SmsBox> createState() => _SmsBoxState();
}

class _SmsBoxState extends State<_SmsBox> {
  final _ctrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46, height: 56,
      decoration: BoxDecoration(
        color: AppC.argentClair,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _ctrl.text.isNotEmpty ? AppC.ocre : AppC.sable,
          width: _ctrl.text.isNotEmpty ? 1.5 : 1,
        ),
      ),
      child: TextField(
        controller: _ctrl,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(fontSize: 22, color: AppC.brunFonce,
            fontWeight: FontWeight.w700),
        cursorColor: AppC.ocre,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (val) {
          setState(() {});
          widget.onChanged(val);
          if (val.isNotEmpty) FocusScope.of(context).nextFocus();
        },
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  COMPOSANTS
// ════════════════════════════════════════════════════════════════════════════
class _InputField extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final IconData icon;
  final TextInputType type;
  final bool? obscure;
  final VoidCallback? onToggle;
  final List<TextInputFormatter>? inputFormatters;

  const _InputField({
    required this.ctrl, required this.hint, required this.icon,
    this.type = TextInputType.text, this.obscure,
    this.onToggle, this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppC.argentClair,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppC.sable.withOpacity(0.7)),
    ),
    child: Row(children: [
      Padding(padding: const EdgeInsets.only(left: 14),
          child: Icon(icon, size: 17, color: AppC.argile)),
      Expanded(child: TextField(
        controller: ctrl,
        keyboardType: type,
        obscureText: obscure ?? false,
        inputFormatters: inputFormatters,
        style: const TextStyle(fontSize: 14, color: AppC.brunFonce),
        cursorColor: AppC.ocre,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppC.argile,
              fontStyle: FontStyle.italic, fontSize: 13),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 10, vertical: 14),
        ),
      )),
      if (onToggle != null)
        GestureDetector(onTap: onToggle,
          child: Padding(padding: const EdgeInsets.only(right: 14),
            child: Icon(
                (obscure ?? true)
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 17, color: AppC.argile),
          ),
        ),
    ]),
  );
}

class _CiviliteBtn extends StatelessWidget {
  final String label, emoji;
  final bool selected;
  final VoidCallback onTap;
  const _CiviliteBtn({required this.label, required this.emoji,
    required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 52,
      decoration: BoxDecoration(
        color: selected ? AppC.brunFonce : AppC.creme,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected ? AppC.ocre.withOpacity(0.5) : AppC.sable,
          width: selected ? 1.5 : 1,
        ),
        boxShadow: selected ? [BoxShadow(
            color: AppC.brun.withOpacity(0.3),
            blurRadius: 8, offset: const Offset(0, 3))] : [],
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 14,
            color: selected ? Colors.white : AppC.brunFonce,
            fontWeight: FontWeight.w600)),
      ]),
    ),
  );
}

class _ContinueBtn extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback onTap;
  const _ContinueBtn({
    this.label = 'Continuer',
    required this.loading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: loading ? null : onTap,
    child: Container(
      width: double.infinity, height: 54,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppC.brunFonce, AppC.brun],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(
            color: AppC.brun.withOpacity(0.4),
            blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Center(child: loading
          ? const SizedBox(width: 22, height: 22,
          child: CircularProgressIndicator(
              strokeWidth: 2, color: Colors.white))
          : Row(mainAxisSize: MainAxisSize.min, children: [
        Text(label, style: const TextStyle(fontSize: 16,
            color: Colors.white, fontWeight: FontWeight.w600,
            letterSpacing: 0.4)),
        const SizedBox(width: 8),
        const Icon(Icons.arrow_forward_ios_rounded,
            size: 13, color: Colors.white),
      ])),
    ),
  );
}

class _ErrorBox extends StatelessWidget {
  final String message;
  const _ErrorBox({required this.message});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: const Color(0xFFB71C1C).withOpacity(0.08),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
          color: const Color(0xFFB71C1C).withOpacity(0.3)),
    ),
    child: Row(children: [
      const Icon(Icons.error_outline_rounded,
          size: 16, color: Color(0xFFB71C1C)),
      const SizedBox(width: 8),
      Expanded(child: Text(message,
          style: const TextStyle(fontSize: 12,
              color: Color(0xFFB71C1C)))),
    ]),
  );
}

// ════════════════════════════════════════════════════════════════════════════
//  FORMATTERS
// ════════════════════════════════════════════════════════════════════════════
class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue old, TextEditingValue next) {
    final text = next.text.replaceAll('/', '');
    if (text.length > 8) return old;
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i == 2 || i == 4) buffer.write('/');
      buffer.write(text[i]);
    }
    final string = buffer.toString();
    return TextEditingValue(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class _PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue old, TextEditingValue next) {
    String text = next.text;
    if (text.startsWith('0')) text = text.substring(1);
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
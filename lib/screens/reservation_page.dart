import 'package:flutter/material.dart';
import '../main.dart' show AppC;
import 'resultat_recherche.dart' show ArtisanListing;

class ReservationPage extends StatefulWidget {
  final ArtisanListing artisan;
  const ReservationPage({super.key, required this.artisan});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {

  final _nomCtrl  = TextEditingController();
  final _addrCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool  _isUrgent = false;
  bool  _loading  = false;
  final List<String> _photos = []; // pour plus tard avec Firebase

  @override
  void dispose() {
    _nomCtrl.dispose();
    _addrCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppC.blanc,
      body: Column(children: [

        // ── Header ──────────────────────────────────────────────
        Container(
          padding: EdgeInsets.fromLTRB(16, top + 12, 16, 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF3D2B1F), Color(0xFF6B4226),
                Color(0xFFA0715A), Color(0xFFC8922A)],
              stops: [0.0, 0.35, 0.65, 1.0],
            ),
          ),
          child: Column(children: [
            Row(children: [
              GestureDetector(
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
              const Spacer(),
              const Text('Demande d\'intervention',
                style: TextStyle(fontFamily: 'Georgia',
                    fontSize: 16, color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),
              const Spacer(),
              const SizedBox(width: 38),
            ]),
            const SizedBox(height: 16),

            // Carte artisan résumée
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: Colors.white.withOpacity(0.2)),
              ),
              child: Row(children: [
                Text(widget.artisan.emoji,
                    style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 14),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.artisan.name,
                      style: const TextStyle(fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 3),
                    Text(widget.artisan.metier,
                      style: TextStyle(fontSize: 12,
                          color: Colors.white.withOpacity(0.7)),
                    ),
                    Text('📍 ${widget.artisan.quartier}',
                      style: TextStyle(fontSize: 11,
                          color: Colors.white.withOpacity(0.6)),
                    ),
                  ],
                )),
                // Note
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(children: [
                    const Icon(Icons.star_rounded,
                        size: 12, color: AppC.ocreClair),
                    const SizedBox(width: 3),
                    Text(widget.artisan.rating.toString(),
                      style: const TextStyle(fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ]),
                ),
              ]),
            ),
          ]),
        ),

        // ── Formulaire ───────────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ── Urgence toggle ──────────────────────────────
                GestureDetector(
                  onTap: () => setState(() => _isUrgent = !_isUrgent),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _isUrgent
                          ? const Color(0xFFB71C1C).withOpacity(0.08)
                          : AppC.creme,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _isUrgent
                            ? const Color(0xFFB71C1C).withOpacity(0.4)
                            : AppC.sable,
                        width: _isUrgent ? 1.5 : 1,
                      ),
                    ),
                    child: Row(children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 42, height: 42,
                        decoration: BoxDecoration(
                          color: _isUrgent
                              ? const Color(0xFFB71C1C).withOpacity(0.12)
                              : AppC.argentClair,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(child: Text(
                          _isUrgent ? '🚨' : '⏰',
                          style: const TextStyle(fontSize: 20),
                        )),
                      ),
                      const SizedBox(width: 14),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isUrgent ? 'Intervention urgente' : 'Intervention normale',
                            style: TextStyle(
                              fontSize: 14,
                              color: _isUrgent
                                  ? const Color(0xFFB71C1C)
                                  : AppC.brunFonce,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            _isUrgent
                                ? 'L\'artisan sera contacté immédiatement'
                                : 'Appuyez pour marquer comme urgent',
                            style: const TextStyle(
                                fontSize: 11, color: AppC.argile),
                          ),
                        ],
                      )),
                      // Toggle switch
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 44, height: 24,
                        decoration: BoxDecoration(
                          color: _isUrgent
                              ? const Color(0xFFB71C1C)
                              : AppC.sable,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(children: [
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 200),
                            left: _isUrgent ? 22 : 2,
                            top: 2,
                            child: Container(
                              width: 20, height: 20,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ]),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Section infos ───────────────────────────────
                _sectionTitle('VOS INFORMATIONS'),
                const SizedBox(height: 12),

                _label('Nom et prénom'),
                const SizedBox(height: 8),
                _Field(
                  ctrl: _nomCtrl,
                  hint: 'Ex: Mourad Benali',
                  icon: Icons.person_outline_rounded,
                ),
                const SizedBox(height: 14),

                _label('Adresse du chantier'),
                const SizedBox(height: 8),
                _Field(
                  ctrl: _addrCtrl,
                  hint: 'Ex: Rue Didouche Mourad, Alger',
                  icon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 20),

                // ── Description ─────────────────────────────────
                _sectionTitle('DESCRIPTION DU PROBLÈME'),
                const SizedBox(height: 12),

                Container(
                  decoration: BoxDecoration(
                    color: AppC.argentClair,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: AppC.sable.withOpacity(0.7)),
                  ),
                  child: TextField(
                    controller: _descCtrl,
                    maxLines: 5,
                    style: const TextStyle(
                        fontSize: 14, color: AppC.brunFonce),
                    cursorColor: AppC.ocre,
                    decoration: const InputDecoration(
                      hintText:
                      'Décrivez votre problème en détail...\nEx: Fuite d\'eau sous l\'évier, tuyau cassé...',
                      hintStyle: TextStyle(
                          color: AppC.argile,
                          fontStyle: FontStyle.italic,
                          fontSize: 13,
                          height: 1.6),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Photos ──────────────────────────────────────
                _sectionTitle('PHOTOS DU PROBLÈME'),
                const SizedBox(height: 6),
                const Text('Optionnel — max 3 photos',
                  style: TextStyle(fontSize: 11,
                      color: AppC.argile,
                      fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 12),

                Row(children: [
                  // Bouton ajouter photo
                  GestureDetector(
                    onTap: () {
                      // Firebase Storage plus tard
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                              'Photos disponibles après connexion Firebase'),
                          backgroundColor: AppC.brunFonce,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    },
                    child: Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        color: AppC.creme,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: AppC.sable,
                            style: BorderStyle.solid),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_a_photo_outlined,
                              color: AppC.argile, size: 24),
                          const SizedBox(height: 4),
                          Text('Ajouter',
                            style: TextStyle(fontSize: 10,
                                color: AppC.argile.withOpacity(0.8)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Placeholder photos
                  ...List.generate(2, (i) => Container(
                    width: 80, height: 80,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: AppC.argentClair,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: AppC.sable.withOpacity(0.5)),
                    ),
                    child: const Icon(Icons.image_outlined,
                        color: AppC.sable, size: 28),
                  )),
                ]),
                const SizedBox(height: 32),

                // ── 2 boutons contact ───────────────────────────
                _sectionTitle('CONTACTER L\'ARTISAN'),
                const SizedBox(height: 12),

                // Bouton Appeler
                GestureDetector(
                  onTap: () => _appeler(context),
                  child: Container(
                    width: double.infinity, height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppC.brunFonce, AppC.brun],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(
                          color: AppC.brun.withOpacity(0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 6))],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.phone_rounded,
                            color: Colors.white, size: 20),
                        SizedBox(width: 12),
                        Text('Appeler maintenant',
                          style: TextStyle(fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Bouton Demande de rappel
                GestureDetector(
                  onTap: () => _demanderRappel(context),
                  child: Container(
                    width: double.infinity, height: 56,
                    decoration: BoxDecoration(
                      color: AppC.creme,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppC.sable),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.phone_callback_rounded,
                            color: AppC.brunFonce, size: 20),
                        SizedBox(width: 12),
                        Text('Demande de rappel',
                          style: TextStyle(fontSize: 16,
                              color: AppC.brunFonce,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  // ── Actions ────────────────────────────────────────────────────
  void _appeler(BuildContext context) {
    if (_nomCtrl.text.isEmpty || _addrCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Remplissez votre nom et adresse'),
          backgroundColor: AppC.brunFonce,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    // Ouvre le téléphone — on ajoutera url_launcher plus tard
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppC.blanc,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: Text('Appeler ${widget.artisan.name}',
          style: const TextStyle(fontFamily: 'Georgia',
              color: AppC.brunFonce, fontSize: 18),
        ),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(widget.artisan.emoji,
              style: const TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: AppC.creme,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppC.sable),
            ),
            child: const Text('📞 05 XX XX XX XX',
              style: TextStyle(fontSize: 18,
                  color: AppC.brunFonce,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1),
            ),
          ),
        ]),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler',
                style: TextStyle(color: AppC.argile)),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              // url_launcher : tel:+213XXXXXXXXX
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppC.brunFonce,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text('Appeler',
                style: TextStyle(color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _demanderRappel(BuildContext context) {
    if (_nomCtrl.text.isEmpty || _addrCtrl.text.isEmpty ||
        _descCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              'Remplissez tous les champs avant de demander un rappel'),
          backgroundColor: AppC.brunFonce,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppC.blanc,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text('Demande envoyée ! ✅',
          style: TextStyle(fontFamily: 'Georgia',
              color: AppC.brunFonce, fontSize: 18),
        ),
        content: Column(mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Votre demande a été envoyée à l\'artisan.\nIl vous rappellera dans les plus brefs délais.',
                style: TextStyle(fontSize: 13,
                    color: AppC.argile, height: 1.6),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppC.creme,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppC.sable),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _recapRow('👤', _nomCtrl.text),
                      _recapRow('📍', _addrCtrl.text),
                      _recapRow('🚨', _isUrgent ? 'Urgent' : 'Normal'),
                    ]),
              ),
            ]),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppC.brunFonce,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text('Parfait !',
                style: TextStyle(color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recapRow(String emoji, String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(children: [
      Text(emoji, style: const TextStyle(fontSize: 14)),
      const SizedBox(width: 8),
      Expanded(child: Text(text,
        style: const TextStyle(fontSize: 12,
            color: AppC.brunFonce, fontWeight: FontWeight.w500),
        overflow: TextOverflow.ellipsis,
      )),
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
        borderRadius: BorderRadius.circular(2),
      ),
    ),
    Text(t, style: const TextStyle(fontSize: 9,
        letterSpacing: 2, color: AppC.argile,
        fontWeight: FontWeight.w600)),
  ]);

  Widget _label(String t) => Text(t,
      style: const TextStyle(fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppC.brunFonce, letterSpacing: 0.3));
}

// ════════════════════════════════════════════════════════════════
//  CHAMP TEXTE
// ════════════════════════════════════════════════════════════════
class _Field extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final IconData icon;

  const _Field({required this.ctrl, required this.hint,
    required this.icon});

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
    ]),
  );
}
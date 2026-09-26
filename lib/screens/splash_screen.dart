import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  late AnimationController _logoCtrl;
  late AnimationController _textCtrl;
  late AnimationController _circleCtrl;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<Offset>  _textSlide;
  late Animation<double> _circleScale;

  @override
  void initState() {
    super.initState();

    // Cacher la barre de status
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // Controller logo
    _logoCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut));
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _logoCtrl,
            curve: const Interval(0.0, 0.5, curve: Curves.easeIn)));

    // Controller texte
    _textCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _textCtrl, curve: Curves.easeIn));
    _textSlide = Tween<Offset>(
        begin: const Offset(0, 0.3), end: Offset.zero).animate(
        CurvedAnimation(parent: _textCtrl, curve: Curves.easeOutCubic));

    // Controller cercles décoratifs
    _circleCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    _circleScale = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _circleCtrl, curve: Curves.easeOutCubic));

    // Lancer les animations en séquence
    _startAnimations();
  }

  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _circleCtrl.forward();
    _logoCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 800));
    _textCtrl.forward();

    // Aller vers Onboarding après 3 secondes
    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const OnboardingScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _textCtrl.dispose();
    _circleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2A1A10),
              Color(0xFF3D2B1F),
              Color(0xFF6B4226),
              Color(0xFFC8922A),
            ],
            stops: [0.0, 0.3, 0.65, 1.0],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [

            // Cercles décoratifs animés
            AnimatedBuilder(
              animation: _circleScale,
              builder: (_, __) => Stack(
                alignment: Alignment.center,
                children: [
                  _buildCircle(size.width * 0.9 * _circleScale.value,
                      0.06, const Offset(-0.3, -0.35)),
                  _buildCircle(size.width * 0.6 * _circleScale.value,
                      0.08, const Offset(0.4, 0.3)),
                  _buildCircle(size.width * 1.2 * _circleScale.value,
                      0.04, Offset.zero),
                ],
              ),
            ),

            // Motif arabesque
            Opacity(
              opacity: 0.08,
              child: CustomPaint(
                size: Size(size.width, size.height),
                painter: _ArabsquePainter(),
              ),
            ),

            // Contenu central
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // Logo animé
                ScaleTransition(
                  scale: _logoScale,
                  child: FadeTransition(
                    opacity: _logoOpacity,
                    child: Container(
                      width: 110, height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFD9A84C), Color(0xFFC8922A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFC8922A).withOpacity(0.5),
                            blurRadius: 40, spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text('⚒️',
                            style: TextStyle(fontSize: 48)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Texte animé
                SlideTransition(
                  position: _textSlide,
                  child: FadeTransition(
                    opacity: _textOpacity,
                    child: Column(children: [
                      const Text('ArtisDZ',
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 42,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          letterSpacing: 4,
                          shadows: [
                            Shadow(color: Color(0xFFC8922A),
                                blurRadius: 20),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('الحرف الجزائرية الأصيلة',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.75),
                          fontWeight: FontWeight.w300,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: 60, height: 2,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.transparent,
                              Color(0xFFD9A84C), Colors.transparent],
                          ),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('Trouvez un artisan de confiance',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.6),
                          letterSpacing: 1,
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),

            // Indicateur de chargement en bas
            Positioned(
              bottom: 60,
              child: FadeTransition(
                opacity: _textOpacity,
                child: Column(children: [
                  SizedBox(
                    width: 120,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.white.withOpacity(0.1),
                      valueColor: const AlwaysStoppedAnimation(
                          Color(0xFFD9A84C)),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Chargement...',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.4),
                      letterSpacing: 1.5,
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircle(double size, double opacity, Offset offset) {
    return Transform.translate(
      offset: Offset(offset.dx * 200, offset.dy * 200),
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: Colors.white.withOpacity(opacity), width: 1),
        ),
      ),
    );
  }
}

// Painter arabesque
class _ArabsquePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), 8, p);
        canvas.drawCircle(Offset(x + step / 2, y + step / 2), 4, p);
      }
    }
    p.strokeWidth = 0.4;
    for (double x = -size.height; x < size.width + size.height; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x + size.height, size.height), p);
    }
  }
  @override bool shouldRepaint(_) => false;
}
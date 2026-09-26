import 'package:flutter/material.dart';
import 'home_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {

  final _pageCtrl = PageController();
  int _currentPage = 0;

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  final List<_OnboardData> _pages = const [
    _OnboardData(
      emoji: '🔍',
      title: 'Trouvez\nl\'artisan idéal',
      titleAr: 'ابحث عن الحرفي المثالي',
      description:
      'Recherchez parmi des centaines d\'artisans vérifiés dans votre wilaya en quelques secondes.',
      color1: Color(0xFF3D2B1F),
      color2: Color(0xFF6B4226),
    ),
    _OnboardData(
      emoji: '📅',
      title: 'Réservez\nen ligne',
      titleAr: 'احجز عبر الإنترنت',
      description:
      'Choisissez votre créneau, confirmez votre RDV et recevez une notification instantanée.',
      color1: Color(0xFF6B4226),
      color2: Color(0xFFC8922A),
    ),
    _OnboardData(
      emoji: '⭐',
      title: 'Évaluez\nvotre artisan',
      titleAr: 'قيّم الحرفي',
      description:
      'Après chaque intervention, laissez un avis pour aider la communauté ArtisDZ.',
      color1: Color(0xFFA0715A),
      color2: Color(0xFFD9A84C),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn);
    _slideAnim = Tween<Offset>(
        begin: const Offset(0.1, 0), end: Offset.zero).animate(
        CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      _goHome();
    }
  }

  // ── Navigation directe vers HomePage (plus d'AuthPage avant) ──
  void _goHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomePage(isLoggedIn: false),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          // Pages
          PageView.builder(
            controller: _pageCtrl,
            onPageChanged: (i) {
              setState(() => _currentPage = i);
              _animCtrl.reset();
              _animCtrl.forward();
            },
            itemCount: _pages.length,
            itemBuilder: (_, i) => _buildPage(_pages[i]),
          ),

          // Bouton passer
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 20,
            child: GestureDetector(
              onTap: _goHome,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.3)),
                ),
                child: Text('Passer',
                  style: TextStyle(
                    fontSize: 12, color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),

          // Bas de page — points + bouton
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  28, 24, 28, MediaQuery.of(context).padding.bottom + 32),
              decoration: BoxDecoration(
                color: const Color(0xFFFDF8F2),
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3D2B1F).withOpacity(0.12),
                    blurRadius: 30, offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // Titre
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: SlideTransition(
                      position: _slideAnim,
                      child: Column(children: [
                        Text(
                          _pages[_currentPage].title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 28,
                            color: Color(0xFF3D2B1F),
                            fontWeight: FontWeight.w400,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _pages[_currentPage].titleAr,
                          style: const TextStyle(
                            fontSize: 14, color: Color(0xFFC8922A),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _pages[_currentPage].description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14, color: Color(0xFFA0715A),
                            height: 1.6,
                          ),
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Points indicateurs
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (i) =>
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == i ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == i
                                ? const Color(0xFF3D2B1F)
                                : const Color(0xFFD9C4A0),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Bouton suivant / commencer
                  GestureDetector(
                    onTap: _nextPage,
                    child: Container(
                      width: double.infinity, height: 54,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _pages[_currentPage].color1,
                            _pages[_currentPage].color2,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: _pages[_currentPage].color2
                                .withOpacity(0.4),
                            blurRadius: 16, offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentPage == _pages.length - 1
                                ? 'Commencer'
                                : 'Suivant',
                            style: const TextStyle(
                              fontSize: 16, color: Colors.white,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            _currentPage == _pages.length - 1
                                ? Icons.rocket_launch_rounded
                                : Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: _currentPage == _pages.length - 1
                                ? 18 : 14,
                          ),
                        ],
                      ),
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

  Widget _buildPage(_OnboardData data) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [data.color1, data.color2],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: 0.08,
            child: CustomPaint(
              size: const Size(double.infinity, double.infinity),
              painter: _PatternPainter(),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            child: Text(data.emoji,
                style: const TextStyle(fontSize: 100)),
          ),
        ],
      ),
    );
  }
}

class _OnboardData {
  final String emoji, title, titleAr, description;
  final Color color1, color2;
  const _OnboardData({
    required this.emoji, required this.title,
    required this.titleAr, required this.description,
    required this.color1, required this.color2,
  });
}

class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white..strokeWidth = 0.7..style = PaintingStyle.stroke;
    const step = 35.0;
    for (double x = -size.height; x < size.width + size.height; x += step * 1.5) {
      canvas.drawLine(Offset(x, 0), Offset(x + size.height, size.height), p);
      canvas.drawLine(Offset(x + size.height, 0), Offset(x, size.height), p);
    }
  }
  @override bool shouldRepaint(_) => false;
}
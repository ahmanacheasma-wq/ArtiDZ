import 'package:flutter/material.dart';
import '../main.dart' show AppC;
import 'home_page.dart';
import 'mes_favoris.dart';
import 'mes_reservations.dart';
import 'profil_utilisateur.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(isLoggedIn: true),   // ← connecté ici
    MesFavoris(),
    MesReservations(),
    ProfilUtilisateur(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppC.blanc,
          border: Border(
              top: BorderSide(color: AppC.sable.withOpacity(0.4))),
          boxShadow: [BoxShadow(
            color: AppC.brun.withOpacity(0.08),
            blurRadius: 20, offset: const Offset(0, -4),
          )],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_rounded,
                  label: 'Accueil',
                  index: 0,
                  current: _currentIndex,
                  onTap: _onTap,
                ),
                _NavItem(
                  icon: Icons.favorite_border_rounded,
                  label: 'Favoris',
                  index: 1,
                  current: _currentIndex,
                  onTap: _onTap,
                ),
                _NavItem(
                  icon: Icons.calendar_month_outlined,
                  label: 'Réservations',
                  index: 2,
                  current: _currentIndex,
                  onTap: _onTap,
                ),
                _NavItem(
                  icon: Icons.person_outline_rounded,
                  label: 'Profil',
                  index: 3,
                  current: _currentIndex,
                  onTap: _onTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(int index) => setState(() => _currentIndex = index);
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int current;
  final void Function(int) onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.current,
    required this.onTap,
  });

  bool get _selected => index == current;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _selected ? AppC.brunFonce : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 20,
              color: _selected ? Colors.white : AppC.argile),
          if (_selected) ...[
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w600)),
          ],
        ]),
      ),
    );
  }
}
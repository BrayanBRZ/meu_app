import 'package:flutter/material.dart';
import 'package:meu_app/shared/widgets/floating_card.dart';

class BottomNav extends StatelessWidget {
  final int? currentIndex;

  const BottomNav({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/history');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/subject');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/setting');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/task/create');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingCard(
              height: MediaQuery.of(context).size.width * 0.16,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavItem(context, Icons.home_rounded, 0),
                  _buildNavItem(context, Icons.history_rounded, 1),
                  GestureDetector(
                    onTap: () => _onItemTapped(context, 4),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.purple,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purple,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.assignment_add,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                  _buildNavItem(context, Icons.menu_book_rounded, 2),
                  _buildNavItem(context, Icons.settings_rounded, 3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, int index) {
    final isSelected = currentIndex == index;

    return IconButton(
      icon: Icon(
        icon,
        color: isSelected ? const Color(0xFF9C27B0) : Colors.black45,
        size: 28,
      ),
      onPressed: () => _onItemTapped(context, index),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:meu_app/shared/widgets/bottom_nav.dart';
import 'package:meu_app/shared/widgets/floating_card.dart';
import 'package:meu_app/shared/widgets/top_bar.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const TopBar(screenName: 'Configuracoes'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 4, top: 20, bottom: 8),
                      child: Text(
                        'Organizacao',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    FloatingCard(
                      child: Column(
                        children: [
                          _Tile(
                            icon: Icons.label_outline,
                            label: 'Tags',
                            subtitle: 'Gerencie tags e seus lembretes',
                            onTap: () => Navigator.pushNamed(context, '/tags'),
                          ),
                          const Divider(height: 1, indent: 54, endIndent: 16),
                          _Tile(
                            icon: Icons.bar_chart_rounded,
                            label: 'Estatisticas',
                            subtitle: 'Resumo das suas atividades',
                            onTap: () =>
                                Navigator.pushNamed(context, '/statistics'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 3),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _Tile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE1BEE7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF9C27B0), size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.black45),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black26),
          ],
        ),
      ),
    );
  }
}

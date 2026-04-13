import 'package:flutter/material.dart';
import 'package:meu_app/shared/widgets/bottom_nav.dart';
import 'package:meu_app/shared/widgets/floating_card.dart';
import 'package:meu_app/shared/widgets/top_bar.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<StatefulWidget> createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            TopBar(screenName: 'Configurações'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // # Preferências
                    // const Padding(
                    //   padding:
                    //       EdgeInsets.only(left: 4, top: 8, bottom: 8),
                    //   child: Text(
                    //     'Preferências',
                    //     style: TextStyle(
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 13,
                    //       color: Colors.black54,
                    //     ),
                    //   ),
                    // ),
                    // FloatingCard(
                    //   child: Column(
                    //     children: [
                    //       _buildSwitch(
                    //         icon: Icons.notifications_outlined,
                    //         label: 'Notificações',
                    //         subtitle: 'Alertas de atividades próximas',
                    //         value: _notificationsEnabled,
                    //         onChanged: (v) =>
                    //             setState(() => _notificationsEnabled = v),
                    //       ),
                    //       _buildDivider(),
                    //       _buildSwitch(
                    //         icon: Icons.dark_mode_outlined,
                    //         label: 'Modo Escuro',
                    //         subtitle: 'Tema escuro para a interface',
                    //         value: _darkModeEnabled,
                    //         onChanged: (v) =>
                    //             setState(() => _darkModeEnabled = v),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    // Dados
                    const Padding(
                      padding: EdgeInsets.only(left: 4, top: 20, bottom: 8),
                      child: Text(
                        'Dados',
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
                          _buildTile(
                            icon: Icons.bar_chart_rounded,
                            label: 'Estatísticas',
                            subtitle: 'Resumo das suas atividades',
                            onTap: () =>
                                Navigator.pushNamed(context, '/statistics'),
                          ),
                          _buildDivider(),
                          _buildTile(
                            icon: Icons.delete_outline_rounded,
                            label: 'Limpar Histórico',
                            subtitle: 'Remove atividades concluídas',
                            onTap: () => _showClearDialog(),
                          ),
                        ],
                      ),
                    ),

                    // # Sobre
                    // const Padding(
                    //   padding:
                    //       EdgeInsets.only(left: 4, top: 20, bottom: 8),
                    //   child: Text(
                    //     'Sobre',
                    //     style: TextStyle(
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 13,
                    //       color: Colors.black54,
                    //     ),
                    //   ),
                    // ),
                    // FloatingCard(
                    //   child: Column(
                    //     children: [
                    //       _buildTile(
                    //         icon: Icons.info_outline_rounded,
                    //         label: 'Sobre o App',
                    //         subtitle: 'Agenda Escolar v1.0.0',
                    //         onTap: () => _showAboutDialog(),
                    //       ),
                    //       _buildDivider(),
                    //       _buildTile(
                    //         icon: Icons.star_outline_rounded,
                    //         label: 'Avaliar',
                    //         subtitle: 'Deixe sua opinião na loja',
                    //         onTap: () {},
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // const SizedBox(height: 24),

                    // Center(
                    //   child: Text(
                    //     'Agenda Escolar • v1.0.0',
                    //     style: TextStyle(
                    //       fontSize: 12,
                    //       color: Colors.black26,
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(currentIndex: 3),
    );
  }

  Widget _buildSwitch({
    required IconData icon,
    required String label,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF9C27B0),
          ),
        ],
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
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

  Widget _buildDivider() => const Divider(
    height: 1,
    indent: 54,
    endIndent: 16,
    color: Color(0xFFEEEEEE),
  );

  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Limpar Histórico'),
        content: const Text('Deseja remover todas as atividades concluídas?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Limpar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Agenda Escolar',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.menu_book_rounded,
        color: Color(0xFF9C27B0),
        size: 40,
      ),
      children: [
        const Text('Organize suas atividades acadêmicas com facilidade.'),
      ],
    );
  }
}

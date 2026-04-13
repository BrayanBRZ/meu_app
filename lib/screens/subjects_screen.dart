import 'package:flutter/material.dart';
import 'package:meu_app/shared/widgets/bottom_nav.dart';
import 'package:meu_app/shared/widgets/floating_card.dart';
import 'package:meu_app/shared/widgets/top_bar.dart';

class _Subject {
  final String name;
  final String teacher;
  final IconData icon;
  _Subject(this.name, this.teacher, this.icon);
}

class SubjectScreen extends StatefulWidget {
  const SubjectScreen({super.key});

  @override
  State<SubjectScreen> createState() => SubjectScreenState();
}

class SubjectScreenState extends State<SubjectScreen> {
  final List<_Subject> _subjects = [
    _Subject('Cálculo I', 'Prof. Rodrigo Maia', Icons.functions_outlined),
    _Subject('Física II', 'Prof. Ana Carvalho', Icons.bolt_outlined),
    _Subject('Estrutura de Dados', 'Prof. Leandro Souza', Icons.account_tree_outlined),
    _Subject('Álgebra Linear', 'Prof. Mariana Fonseca', Icons.grid_on_outlined),
    _Subject('Programação OO', 'Prof. Carlos Lima', Icons.code_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            TopBar(screenName: 'Matérias'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: FloatingCard(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.only(
                              top: 12, bottom: 0),
                          itemCount: _subjects.length,
                          separatorBuilder: (_, __) => const Divider(
                            height: 1,
                            indent: 64,
                            endIndent: 16,
                            color: Color(0xFFEEEEEE),
                          ),
                          itemBuilder: (context, index) {
                            final subject = _subjects[index];
                            return ListTile(
                              leading: Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(12),
                                ),
                                child: Icon(subject.icon, size: 22),
                              ),
                              title: Text(
                                subject.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              subtitle: Text(
                                subject.teacher,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black45),
                              ),
                              trailing: const Icon(
                                  Icons.chevron_right,
                                  color: Colors.black26),
                            );
                          },
                        ),
                      ),
                      // ── Adicionar Matéria ────────────────────────
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(
                              context, '/subject/add'),
                          child: Container(
                            height: w * 0.14,
                            decoration: BoxDecoration(
                              color: const Color(0xFF9C27B0),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purple.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_rounded,
                                    color: Colors.white, size: 22),
                                SizedBox(width: 8),
                                Text(
                                  'Adicionar Matéria',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(currentIndex: 2),
    );
  }
}
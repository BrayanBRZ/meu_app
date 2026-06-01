import 'package:flutter/material.dart';
import 'package:meu_app/data/models/subject.dart';
import 'package:meu_app/services/subject_service.dart';
import 'package:meu_app/shared/widgets/bottom_nav.dart';
import 'package:meu_app/shared/widgets/floating_card.dart';
import 'package:meu_app/shared/widgets/top_bar.dart';

class SubjectScreen extends StatefulWidget {
  const SubjectScreen({super.key});

  @override
  State<SubjectScreen> createState() => SubjectScreenState();
}

class SubjectScreenState extends State<SubjectScreen> {
  final _subjectService = SubjectService();
  late Future<List<Subject>> _future;

  @override
  void initState() {
    super.initState();
    _future = _subjectService.findAll();
  }

  void _reload() {
    setState(() => _future = _subjectService.findAll());
  }

  Future<void> _delete(Subject subject) async {
    final id = subject.id;
    if (id == null) return;

    await _subjectService.delete(id);
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const TopBar(screenName: 'Materias'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: FloatingCard(
                  child: Column(
                    children: [
                      Expanded(
                        child: FutureBuilder<List<Subject>>(
                          future: _future,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState !=
                                ConnectionState.done) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            final subjects = snapshot.data ?? const <Subject>[];
                            if (subjects.isEmpty) {
                              return const Center(
                                child: Text('Nenhuma materia cadastrada.'),
                              );
                            }

                            return ListView.separated(
                              padding: const EdgeInsets.only(top: 12),
                              itemCount: subjects.length,
                              separatorBuilder: (_, _) => const Divider(
                                height: 1,
                                indent: 64,
                                endIndent: 16,
                                color: Color(0xFFEEEEEE),
                              ),
                              itemBuilder: (context, index) {
                                final subject = subjects[index];
                                return ListTile(
                                  leading: const Icon(Icons.menu_book_rounded),
                                  title: Text(
                                    subject.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () => _delete(subject),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: GestureDetector(
                          onTap: () async {
                            await Navigator.pushNamed(context, '/subject/add');
                            _reload();
                          },
                          child: Container(
                            height: w * 0.14,
                            decoration: BoxDecoration(
                              color: const Color(0xFF9C27B0),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_rounded, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Adicionar Materia',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
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
      bottomNavigationBar: const BottomNav(currentIndex: 2),
    );
  }
}

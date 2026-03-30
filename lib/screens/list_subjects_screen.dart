import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/app_repository.dart';
import '../models/subject.dart';
import '../widgets/app_bottom_nav.dart';

class ListSubjectsScreen extends StatefulWidget {
  const ListSubjectsScreen({super.key});

  @override
  State<ListSubjectsScreen> createState() => _ListSubjectsScreenState();
}

class _ListSubjectsScreenState extends State<ListSubjectsScreen> {
  final _repo = AppRepository.instance;

  Future<void> _openForm({Subject? subject}) async {
    await context.push('/subjects/form', extra: subject);
    setState(() {});
  }

  Future<void> _confirmDelete(Subject subject) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remover Matéria'),
        content: Text('Deseja remover "${subject.name}"? Ela será desvinculada de todas as tarefas.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remover'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      _repo.removeSubject(subject.id);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('"${subject.name}" removida.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final subjects = _repo.subjects;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Matérias', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () => _openForm()),
        ],
      ),
      body: subjects.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.menu_book_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Nenhuma matéria cadastrada.', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => _openForm(),
                    icon: const Icon(Icons.add),
                    label: const Text('Adicionar Matéria'),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: subjects.length,
              separatorBuilder: (_, __) => const Divider(indent: 76, endIndent: 16),
              itemBuilder: (ctx, i) {
                final subject = subjects[i];
                final taskCount = _repo.subjectTasks(subject.id).length;

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  onTap: () => context.push('/subjects/${subject.id}'),
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: subject.color,
                    child: Text(subject.symbol,
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  title: Text(subject.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (taskCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: subject.color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$taskCount ${taskCount == 1 ? 'tarefa' : 'tarefas'}',
                            style: TextStyle(color: subject.color, fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                        ),
                      const SizedBox(width: 4),
                      PopupMenuButton<String>(
                        onSelected: (v) {
                          if (v == 'edit') _openForm(subject: subject);
                          if (v == 'delete') _confirmDelete(subject);
                        },
                        itemBuilder: (_) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: ListTile(dense: true, leading: Icon(Icons.edit), title: Text('Editar')),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: ListTile(
                              dense: true,
                              leading: Icon(Icons.delete, color: Colors.red),
                              title: Text('Remover', style: TextStyle(color: Colors.red)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
    );
  }
}
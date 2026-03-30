import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/app_repository.dart';
import '../models/task.dart';
import '../widgets/shared_widgets.dart';
import '../widgets/app_bottom_nav.dart';

// ListTasksScreen
class ListTasksScreen extends StatefulWidget {
  const ListTasksScreen({super.key});

  @override
  State<ListTasksScreen> createState() => _ListTasksScreenState();
}

class _ListTasksScreenState extends State<ListTasksScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;
  final _repo = AppRepository.instance;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas', style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabCtrl,
          tabs: const [
            Tab(text: 'Futuras', icon: Icon(Icons.upcoming)),
            Tab(text: 'Passadas', icon: Icon(Icons.history)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await context.push('/tasks/new');
              setState(() {});
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          _TaskList(
            tasks: _repo.futureTasks,
            emptyMessage: 'Nenhuma tarefa futura.',
            onTap: (t) async {
              await context.push('/tasks/${t.id}');
              setState(() {});
            },
          ),
          _TaskList(
            tasks: _repo.pastTasks,
            emptyMessage: 'Nenhuma tarefa passada.',
            onTap: (t) async {
              await context.push('/tasks/${t.id}');
              setState(() {});
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push('/tasks/new');
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }
}

class _TaskList extends StatelessWidget {
  final List<Task> tasks;
  final String emptyMessage;
  final void Function(Task) onTap;

  const _TaskList({required this.tasks, required this.emptyMessage, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Center(child: Text(emptyMessage, style: const TextStyle(color: Colors.grey)));
    }
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (ctx, i) => TaskCard(task: tasks[i], onTap: () => onTap(tasks[i])),
    );
  }
}

// FormTaskScreen
class FormTaskScreen extends StatelessWidget {
  final Task? task;
  const FormTaskScreen({super.key, this.task});

  @override
  Widget build(BuildContext context) {
    final isEditing = task != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Tarefa' : 'Nova Tarefa',
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: const Center(
        child: Text(
          'A fazer\n'
          '(Título, Descrição, Tipo, Data, Matérias)',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}

// DetailTaskScreen
class DetailTaskScreen extends StatefulWidget {
  final String taskId;
  const DetailTaskScreen({super.key, required this.taskId});

  @override
  State<DetailTaskScreen> createState() => _DetailTaskScreenState();
}

class _DetailTaskScreenState extends State<DetailTaskScreen> {
  final _repo = AppRepository.instance;

  String _fmt(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';

  @override
  Widget build(BuildContext context) {
    final task = _repo.searchTaskById(widget.taskId);

    if (task == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Tarefa não encontrada')),
        body: const Center(child: Text('Esta tarefa não existe ou foi removida.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${task.type.emoji} ${task.type.label}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await context.push('/tasks/${task.id}/editar', extra: task);
              setState(() {});
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(task.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          // Datas
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Datas', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(children: [
                    const Text('Data Original: ', style: TextStyle(color: Colors.grey)),
                    Text(
                      _fmt(task.originalDate),
                      style: TextStyle(
                        decoration: task.isPostponed ? TextDecoration.lineThrough : null,
                        color: task.isPostponed ? Colors.grey : Colors.black87,
                      ),
                    ),
                  ]),
                  if (task.isPostponed) ...[
                    const SizedBox(height: 4),
                    Row(children: [
                      const Text('Data Remarcada: ', style: TextStyle(color: Colors.deepOrange)),
                      Text(_fmt(task.currentDate),
                          style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 6),
                      const Text('⚠️'),
                    ]),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Matérias
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Matérias Vinculadas', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  task.relatedSubjects.isEmpty
                      ? const Text('Nenhuma matéria vinculada.', style: TextStyle(color: Colors.grey))
                      : Wrap(
                          spacing: 8,
                          children: task.relatedSubjects.map((s) => SubjectBadge(subject: s)).toList(),
                        ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Descrição
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Descrição', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(task.description.isEmpty ? 'Sem descrição.' : task.description),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          OutlinedButton.icon(
            icon: const Icon(Icons.event_repeat),
            label: const Text('Remarcar Data'),
            onPressed: () async {
              await context.push('/tasks/${task.id}/remark', extra: task);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}

// ChoiceDateScreen
class ChoiceDateScreen extends StatefulWidget {
  final Task task;
  const ChoiceDateScreen({super.key, required this.task});

  @override
  State<ChoiceDateScreen> createState() => _ChoiceDateScreenState();
}

class _ChoiceDateScreenState extends State<ChoiceDateScreen> {
  DateTime? _selectedDate;
  String? _error;

  void _confirm() {
    if (_selectedDate == null) {
      setState(() => _error = 'Selecione uma data.');
      return;
    }
    try {
      widget.task.remarkTask(_selectedDate!);
      AppRepository.instance.updateTask(widget.task);
      context.pop();
    } on Exception catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remarcar Tarefa', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          CalendarDatePicker(
            initialDate: widget.task.currentDate,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)),
            onDateChanged: (date) => setState(() {
              _selectedDate = date;
              _error = null;
            }),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FilledButton.icon(
              onPressed: _confirm,
              icon: const Icon(Icons.check),
              label: const Text('Confirmar Nova Data'),
              style: FilledButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            ),
          ),
        ],
      ),
    );
  }
}

// DetailSubjectScreen
class DetailSubjectScreen extends StatefulWidget {
  final String subjectId;
  const DetailSubjectScreen({super.key, required this.subjectId});

  @override
  State<DetailSubjectScreen> createState() => _DetailSubjectScreenState();
}

class _DetailSubjectScreenState extends State<DetailSubjectScreen> {
  final _repo = AppRepository.instance;

  @override
  Widget build(BuildContext context) {
    final subject = _repo.searchSubjectById(widget.subjectId);

    if (subject == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Matéria não encontrada')),
        body: const Center(child: Text('Esta matéria não existe.')),
      );
    }

    final tasks = _repo.subjectTasks(widget.subjectId);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: subject.color,
        foregroundColor: Colors.white,
        title: Text(subject.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await context.push('/subjects/form', extra: subject);
              setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: subject.color.withOpacity(0.1),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: subject.color,
                  child: Text(subject.symbol,
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(subject.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('${tasks.length} tarefa(s)', style: TextStyle(color: subject.color, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: tasks.isEmpty
                ? const Center(child: Text('Nenhuma tarefa para esta matéria.', style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (ctx, i) => TaskCard(
                      task: tasks[i],
                      onTap: () async {
                        await context.push('/tasks/${tasks[i].id}');
                        setState(() {});
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// LinkSubjectScreen
class LinkSubjectScreen extends StatefulWidget {
  final Task task;
  const LinkSubjectScreen({super.key, required this.task});

  @override
  State<LinkSubjectScreen> createState() => _LinkSubjectScreenState();
}

class _LinkSubjectScreenState extends State<LinkSubjectScreen> {
  final _repo = AppRepository.instance;
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.task.relatedSubjects.map((s) => s.id).toSet();
  }

  void _save() {
    final subjects = _repo.subjects;
    widget.task.relatedSubjects
      ..clear()
      ..addAll(subjects.where((s) => _selected.contains(s.id)));
    _repo.updateTask(widget.task);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final subjects = _repo.subjects;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vincular Matérias', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Salvar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: subjects.length,
        itemBuilder: (ctx, i) {
          final subject = subjects[i];
          return CheckboxListTile(
            value: _selected.contains(subject.id),
            onChanged: (val) => setState(() {
              if (val == true) {
                _selected.add(subject.id);
              } else {
                _selected.remove(subject.id);
              }
            }),
            secondary: CircleAvatar(
              backgroundColor: subject.color,
              child: Text(subject.symbol, style: const TextStyle(color: Colors.white)),
            ),
            title: Text(subject.name, style: const TextStyle(fontWeight: FontWeight.w500)),
            activeColor: subject.color,
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: FilledButton.icon(
          onPressed: _save,
          icon: const Icon(Icons.check),
          label: Text('Confirmar (${_selected.length} matéria(s))'),
          style: FilledButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
        ),
      ),
    );
  }
}

// SettingsScreen
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _repo = AppRepository.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        children: [
          _SectionHeader('Notificações'),
          SwitchListTile(
            title: const Text('Ativar Notificações'),
            subtitle: const Text('Receba lembretes de provas e trabalhos.'),
            secondary: Icon(
              _repo.notificacoesAtivas ? Icons.notifications_active : Icons.notifications_off,
              color: _repo.notificacoesAtivas ? Colors.amber : Colors.grey,
            ),
            value: _repo.notificacoesAtivas,
            onChanged: (_) => setState(() => _repo.toggleNotificacoes()),
          ),
          const Divider(),
          _SectionHeader('Dados'),
          ListTile(
            leading: const Icon(Icons.restore, color: Colors.blue),
            title: const Text('Restaurar Matérias Básicas'),
            subtitle: const Text('Adiciona de volta as matérias padrão sem apagar as suas.'),
            onTap: () {
              _repo.resetDefaultSubjects();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Matérias básicas restauradas!')),
              );
            },
          ),
          const Divider(),
          _SectionHeader('Sobre'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Agenda Escolar'),
            subtitle: Text('Versão 1.0.0 — Flutter + Dart POO.'),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
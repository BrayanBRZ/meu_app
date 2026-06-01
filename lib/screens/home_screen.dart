import 'package:flutter/material.dart';
import 'package:meu_app/data/models/tag.dart';
import 'package:meu_app/data/models/task.dart';
import 'package:meu_app/services/tag_service.dart';
import 'package:meu_app/services/task_service.dart';
import 'package:meu_app/shared/widgets/bottom_nav.dart';
import 'package:meu_app/shared/widgets/calendar.dart';
import 'package:meu_app/shared/widgets/task_card.dart';
import 'package:meu_app/shared/widgets/top_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _taskService = TaskService();
  final _tagService = TagService();
  late Future<_TaskData> _future;
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _future = _loadData();
  }

  Future<_TaskData> _loadData() async {
    final tasks = await _taskService.findAll();
    final tags = await _tagService.findAll();
    return _TaskData(tasks, {for (final tag in tags) tag.id!: tag});
  }

  List<Task> _tasksForSelectedDay(List<Task> tasks) {
    final selected = DateTime(
      _selectedDay.year,
      _selectedDay.month,
      _selectedDay.day,
    );
    return tasks.where((task) => task.normalizedDate == selected).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              const TopBar(screenName: 'Dashboard'),
              Expanded(
                child: FutureBuilder<_TaskData>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return _ErrorState(
                        onRetry: () => setState(() => _future = _loadData()),
                      );
                    }

                    final data = snapshot.data ?? _TaskData.empty();
                    return Column(
                      children: [
                        Calendar(
                          tasks: data.tasks,
                          tagsById: data.tagsById,
                          onDaySelected: (day) {
                            setState(() => _selectedDay = day);
                          },
                        ),
                        Expanded(
                          child: TaskCard(
                            tasks: _tasksForSelectedDay(data.tasks),
                            tagsById: data.tagsById,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 0),
    );
  }
}

class _TaskData {
  final List<Task> tasks;
  final Map<int, Tag> tagsById;

  _TaskData(this.tasks, this.tagsById);

  factory _TaskData.empty() => _TaskData(const [], const {});
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Nao foi possivel carregar as tarefas.'),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}

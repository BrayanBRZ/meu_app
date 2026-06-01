import 'package:flutter/material.dart';
import 'package:meu_app/data/models/tag.dart';
import 'package:meu_app/data/models/task.dart';
import 'package:meu_app/services/tag_service.dart';
import 'package:meu_app/services/task_service.dart';
import 'package:meu_app/shared/widgets/bottom_nav.dart';
import 'package:meu_app/shared/widgets/task_card.dart';
import 'package:meu_app/shared/widgets/top_bar.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _taskService = TaskService();
  final _tagService = TagService();
  late Future<_TaskData> _future;
  int _selectedFilterIndex = 0;

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

  List<Task> _filteredTasks(List<Task> tasks) {
    final today = DateTime.now();
    final todayNorm = DateTime(today.year, today.month, today.day);
    if (_selectedFilterIndex == 0) {
      return tasks
          .where((task) => task.normalizedDate.compareTo(todayNorm) >= 0)
          .toList()
        ..sort((a, b) => a.normalizedDate.compareTo(b.normalizedDate));
    }

    return tasks
        .where((task) => task.normalizedDate.compareTo(todayNorm) < 0)
        .toList()
      ..sort((a, b) => b.normalizedDate.compareTo(a.normalizedDate));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const TopBar(screenName: 'Atividades'),
              Container(
                height: MediaQuery.of(context).size.width * 0.16,
                padding: const EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width * 0.9,
                child: Row(
                  children: [
                    _buildFilterButton('Futuras', 0),
                    _buildFilterButton('Atrasadas', 1),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<_TaskData>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Nao foi possivel carregar as tarefas.'),
                      );
                    }

                    final data = snapshot.data ?? _TaskData.empty();
                    return TaskCard(
                      tasks: _filteredTasks(data.tasks),
                      tagsById: data.tagsById,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 1),
    );
  }

  Widget _buildFilterButton(String label, int index) {
    final isSelected = _selectedFilterIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedFilterIndex = index),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Colors.black87 : Colors.black12,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskData {
  final List<Task> tasks;
  final Map<int, Tag> tagsById;

  _TaskData(this.tasks, this.tagsById);

  factory _TaskData.empty() => _TaskData(const [], const {});
}

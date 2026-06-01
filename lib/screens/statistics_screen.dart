import 'package:flutter/material.dart';
import 'package:meu_app/data/models/task.dart';
import 'package:meu_app/services/task_service.dart';
import 'package:meu_app/shared/widgets/bottom_nav.dart';
import 'package:meu_app/shared/widgets/floating_card.dart';
import 'package:meu_app/shared/widgets/top_bar.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => StatisticsScreenState();
}

class StatisticsScreenState extends State<StatisticsScreen> {
  final _taskService = TaskService();
  late Future<List<Task>> _future;

  @override
  void initState() {
    super.initState();
    _future = _taskService.findAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              const TopBar(screenName: 'Estatisticas'),
              Expanded(
                child: FutureBuilder<List<Task>>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final tasks = snapshot.data ?? const <Task>[];
                    final today = DateTime.now();
                    final todayNorm = DateTime(
                      today.year,
                      today.month,
                      today.day,
                    );
                    final lateTasks = tasks
                        .where((task) => task.normalizedDate.isBefore(todayNorm))
                        .length;
                    final futureTasks = tasks.length - lateTasks;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Column(
                        children: [
                          _statCard('Total de tarefas', tasks.length),
                          const SizedBox(height: 12),
                          _statCard('Futuras', futureTasks),
                          const SizedBox(height: 12),
                          _statCard('Atrasadas', lateTasks),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 3),
    );
  }

  Widget _statCard(String label, int value) {
    return FloatingCard(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: MediaQuery.of(context).size.width * 0.18,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            '$value',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

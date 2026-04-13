import 'package:flutter/material.dart';
import 'package:meu_app/shared/widgets/bottom_nav.dart';
import 'package:meu_app/shared/widgets/calendar.dart';
import 'package:meu_app/shared/widgets/task_card.dart';
import 'package:meu_app/data/models/task.dart';
import 'package:meu_app/shared/widgets/top_bar.dart';

class HomeScreen extends StatefulWidget {
  final List<Task> tasks;
  
  const HomeScreen({super.key, required this.tasks});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDay = DateTime.now();

  List<Task> get _tasksForSelectedDay => widget.tasks.where((task) {
    final t = task.normalizedDate;
    final s = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);
    return t == s;
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              TopBar(screenName: 'Dashboard'),
              Calendar(
                tasks: widget.tasks,
                onDaySelected: (day) => setState(() => _selectedDay = day),
              ),
              Expanded(
                child: TaskCard(
                  tasks: _tasksForSelectedDay,
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

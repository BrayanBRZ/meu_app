import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:meu_app/data/models/task.dart';
import 'package:meu_app/shared/widgets/bottom_nav.dart';
import 'package:meu_app/shared/widgets/task_card.dart';
import 'package:meu_app/shared/widgets/top_bar.dart';

class HistoryScreen extends StatefulWidget {
  final List<Task> tasks;

  const HistoryScreen({super.key, required this.tasks});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _selectedFilterIndex = 0;

  List<Task> get _filteredTasks {
    final today = DateTime.now();
    final todayNorm = DateTime(today.year, today.month, today.day);
    if (_selectedFilterIndex == 0) {
      return widget.tasks
          .where((t) => t.normalizedDate.compareTo(todayNorm) >= 0)
          .toList()
        ..sort((a, b) => a.normalizedDate.compareTo(b.normalizedDate));
    } else {
      return widget.tasks
          .where((t) => t.normalizedDate.compareTo(todayNorm) < 0)
          .toList()
        ..sort((a, b) => b.normalizedDate.compareTo(a.normalizedDate));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              TopBar(screenName: 'Atividades'),
              Container(
                height: MediaQuery.of(context).size.width * 0.16,
                padding: const EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width * 0.9,
                child: Row(
                  children: [
                    _buildGlassButton("Futuras", 0),
                    _buildGlassButton("Atrasadas", 1),
                  ],
                ),
              ),
              Expanded(
                child: TaskCard(tasks: _filteredTasks),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(currentIndex: 1),
    );
  }

  Widget _buildGlassButton(String label, int index) {
    final bool isSelected = _selectedFilterIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedFilterIndex = index),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isSelected
                        ? [
                            Colors.black.withOpacity(0.25),
                            Colors.black.withOpacity(0.65),
                          ]
                        : [
                            Colors.black.withOpacity(0.05),
                            Colors.black.withOpacity(0.15),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? Colors.black.withOpacity(0.15)
                        : Colors.black.withOpacity(0.05),
                    width: 1.0,
                  ),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
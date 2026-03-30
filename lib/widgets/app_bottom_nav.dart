import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: (i) {
        switch (i) {
          case 0: context.go('/');
          case 1: context.go('/tasks');
          case 2: context.go('/subjects');
          case 3: context.go('/settings');
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Calendário'),
        BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Tarefas'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Matérias'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Config'),
      ],
    );
  }
}
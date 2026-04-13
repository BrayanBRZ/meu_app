import 'package:flutter/material.dart';
import 'package:meu_app/data/models/task.dart';
import 'package:meu_app/screens/confirm-action_screen.dart';
import 'package:meu_app/screens/create_task_screen.dart';
import 'package:meu_app/screens/edit_task_screen.dart';
import 'package:meu_app/screens/history_screen.dart';
import 'package:meu_app/screens/home_screen.dart';
import 'package:meu_app/screens/settings_screen.dart';
import 'package:meu_app/screens/subjects_screen.dart';

void main() async {
  runApp(const SchoolDiaryApp(title: 'Agenda Escolar'));
}

class SchoolDiaryApp extends StatelessWidget {
  final String title;

  const SchoolDiaryApp({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    List<Task> tasks = [
      Task(
        '1',
        'Prova de Cálculo',
        'Estudar derivadas',
        TaskType.test,
        DateTime.now().add(const Duration(days: 2)),
        [],
      ),
      Task(
        '2',
        'Trabalho de Física',
        'Relatório',
        TaskType.work,
        DateTime.now().add(const Duration(days: 4)),
        [],
      ),
      Task(
        '3',
        'Prova de ED',
        'Revisar árvores',
        TaskType.test,
        DateTime.now().add(const Duration(days: 7)),
        [],
      ),
      Task(
        '4',
        'Prova de Cálculo',
        'Estudar derivadas',
        TaskType.work,
        DateTime.now().add(const Duration(days: 2)),
        [],
      ),
    ];

    return MaterialApp(
      title: 'Agenda Escolar',
      theme: ThemeData.light(),
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomeScreen(tasks: tasks),
        '/history': (context) => HistoryScreen(tasks: tasks),
        '/subject': (context) => const SubjectScreen(),
        '/setting': (context) => const SettingScreen(),
        '/task/create': (context) => const CreateTaskScreen(),
        '/task/edit': (context) => const EditTaskScreen(),
        '/confirm-action': (context) => const ConfirmActionScreen(),
      },
    );
  }
}

//GoRoute

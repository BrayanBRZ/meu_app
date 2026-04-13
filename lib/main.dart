import 'package:flutter/material.dart';
import 'package:meu_app/data/models/task.dart';
import 'package:meu_app/screens/add_subject_screen.dart';
import 'package:meu_app/screens/confirm-action_screen.dart';
import 'package:meu_app/screens/create_task_screen.dart';
import 'package:meu_app/screens/edit_task_screen.dart';
import 'package:meu_app/screens/history_screen.dart';
import 'package:meu_app/screens/home_screen.dart';
import 'package:meu_app/screens/settings_screen.dart';
import 'package:meu_app/screens/statistics_screen.dart';
import 'package:meu_app/screens/subjects_screen.dart';
import 'package:meu_app/screens/task_detail_screen.dart';

void main() async {
  runApp(const SchoolDiaryApp(title: 'Agenda Escolar'));
}

class SchoolDiaryApp extends StatelessWidget {
  final String title;

  const SchoolDiaryApp({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final List<Task> tasks = [
      Task(
        '1',
        'Prova de Cálculo',
        'Estudar derivadas e integrais, capítulos 3 a 7 do livro.',
        TaskType.test,
        DateTime.now().add(const Duration(days: 2)),
        [],
      ),
      Task(
        '2',
        'Trabalho de Física',
        'Relatório sobre movimento uniformemente variado.',
        TaskType.work,
        DateTime.now().add(const Duration(days: 4)),
        [],
      ),
      Task(
        '3',
        'Prova de ED',
        'Revisar árvores binárias, grafos e hashing.',
        TaskType.test,
        DateTime.now().add(const Duration(days: 7)),
        [],
      ),
      Task(
        '4',
        'Trabalho de POO',
        'Implementar padrão de projeto Observer em Java.',
        TaskType.work,
        DateTime.now().add(const Duration(days: 2)),
        [],
      ),
      Task(
        '5',
        'Prova de Álgebra',
        'Revisão de matrizes e determinantes.',
        TaskType.test,
        DateTime.now().subtract(const Duration(days: 3)),
        [],
      ),
      Task(
        '6',
        'Trabalho de Química',
        'Relatório de experimento de titulação.',
        TaskType.work,
        DateTime.now().subtract(const Duration(days: 1)),
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
        '/subject/add': (context) => const AddSubjectScreen(),
        '/setting': (context) => const SettingScreen(),
        '/task/create': (context) => const CreateTaskScreen(),
        '/task/edit': (context) => const EditTaskScreen(),
        '/task/detail': (context) => const TaskDetailScreen(),
        '/statistics': (context) => StatisticsScreen(tasks: tasks),
        '/confirm-action': (context) => const ConfirmActionScreen(),
      },
    );
  }
}
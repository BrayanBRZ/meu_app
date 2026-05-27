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
        id : '1',
        title: 'Prova de Cálculo',
        description: 'Estudar derivadas e integrais, capítulos 3 a 7 do livro.',
        type: TaskType.test,
        currentDate: DateTime.now().add(const Duration(days: 2)),
        topicId: '1',
      ),
      Task(
        id: '2',
        title: 'Trabalho de Física',
        description: 'Relatório sobre movimento uniformemente variado.',
        type: TaskType.work,
        currentDate: DateTime.now().add(const Duration(days: 4)),
        topicId: '',
      ),
      Task(
        id: '3',
        title: 'Prova de ED',
        description: 'Revisar árvores binárias, grafos e hashing.',
        type: TaskType.test,
        currentDate: DateTime.now().add(const Duration(days: 7)),
        topicId: '',
      ),
      Task(
        id: '4',
        title: 'Trabalho de POO',
        description: 'Implementar padrão de projeto Observer em Java.',
        type: TaskType.work,
        currentDate: DateTime.now().add(const Duration(days: 2)),
        topicId: '',
      ),
      Task(
        id: '5',
        title: 'Prova de Álgebra',
        description: 'Revisão de matrizes e determinantes.',
        type: TaskType.test,
        currentDate: DateTime.now().subtract(const Duration(days: 3)),
        topicId: '',
      ),
      Task(
        id: '6',
        title: 'Trabalho de Química',
        description: 'Relatório de experimento de titulação.',
        type: TaskType.work,
        currentDate: DateTime.now().subtract(const Duration(days: 1)),
        topicId: '',
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
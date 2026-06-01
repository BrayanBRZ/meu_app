import 'package:flutter/material.dart';
import 'package:meu_app/screens/add_subject_screen.dart';
import 'package:meu_app/screens/confirm-action_screen.dart';
import 'package:meu_app/screens/create_task_screen.dart';
import 'package:meu_app/screens/edit_task_screen.dart';
import 'package:meu_app/screens/history_screen.dart';
import 'package:meu_app/screens/home_screen.dart';
import 'package:meu_app/screens/settings_screen.dart';
import 'package:meu_app/screens/statistics_screen.dart';
import 'package:meu_app/screens/subjects_screen.dart';
import 'package:meu_app/screens/tag_form_screen.dart';
import 'package:meu_app/screens/tags_screen.dart';
import 'package:meu_app/screens/task_detail_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SchoolDiaryApp());
}

class SchoolDiaryApp extends StatelessWidget {
  const SchoolDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda Escolar',
      theme: ThemeData.light(),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/history': (context) => const HistoryScreen(),
        '/subject': (context) => const SubjectScreen(),
        '/subject/add': (context) => const AddSubjectScreen(),
        '/setting': (context) => const SettingScreen(),
        '/tags': (context) => const TagsScreen(),
        '/tags/form': (context) => const TagFormScreen(),
        '/task/create': (context) => const CreateTaskScreen(),
        '/task/edit': (context) => const EditTaskScreen(),
        '/task/detail': (context) => const TaskDetailScreen(),
        '/statistics': (context) => const StatisticsScreen(),
        '/confirm-action': (context) => const ConfirmActionScreen(),
      },
    );
  }
}

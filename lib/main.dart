import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'data/app_repository.dart';
import 'models/task.dart';
import 'models/subject.dart';
import 'screens/home_dashboard.dart';
import 'screens/list_subjects_screen.dart';
import 'screens/form_subject_screen.dart';
import 'screens/skeleton_screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  AppRepository.instance.inicializar();
  runApp(const AgendaEscolarApp());
}

class AgendaEscolarApp extends StatelessWidget {
  const AgendaEscolarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Agenda Escolar',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      routerConfig: _router,
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeDashboard(),
    ),
    GoRoute(
      path: '/tasks',
      builder: (context, state) => const ListTasksScreen(),
      routes: [
        GoRoute(
          path: 'new',
          builder: (context, state) => const FormTaskScreen(),
        ),
        GoRoute(
          path: ':taskId',
          builder: (context, state) =>
              DetailTaskScreen(taskId: state.pathParameters['taskId']!),
          routes: [
            GoRoute(
              path: 'editar',
              builder: (context, state) => FormTaskScreen(task: state.extra as Task?),
            ),
            GoRoute(
              path: 'remark',
              builder: (context, state) => ChoiceDateScreen(task: state.extra as Task),
            ),
            GoRoute(
              path: 'link',
              builder: (context, state) => LinkSubjectScreen(task: state.extra as Task),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/subjects',
      builder: (context, state) => const ListSubjectsScreen(),
      routes: [
        GoRoute(
          path: 'form',
          builder: (context, state) => FormSubjectScreen(subject: state.extra as Subject?),
        ),
        GoRoute(
          path: ':subjectId',
          builder: (context, state) =>
              DetailSubjectScreen(subjectId: state.pathParameters['subjectId']!),
        ),
      ],
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Página não encontrada')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Rota "${state.uri}" não encontrada.'),
          const SizedBox(height: 24),
          FilledButton(onPressed: () => context.go('/'), child: const Text('Voltar ao Início')),
        ],
      ),
    ),
  ),
);

ThemeData _buildTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF1565C0),
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0, scrolledUnderElevation: 2),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );
}
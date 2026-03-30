import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../data/app_repository.dart';
import '../models/task.dart';
import '../widgets/shared_widgets.dart';
import '../widgets/app_bottom_nav.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  final _repo = AppRepository.instance;

  DateTime _currentMonth = DateTime.now();
  DateTime? _selectedDay;

  DateTime get _firstMonthDay => DateTime(_currentMonth.year, _currentMonth.month, 1);
  int get _daysInMonth => DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
  int get _startWeekday => _firstMonthDay.weekday % 7;

  void _prevMonth() => setState(() => _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1));
  void _nextMonth() => setState(() => _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1));

  List<Task> _dayTasks(int day) =>
      _repo.dateTasks(DateTime(_currentMonth.year, _currentMonth.month, day));

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final selectedTasks = _selectedDay != null ? _repo.dateTasks(_selectedDay!) : <Task>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda Escolar', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: Column(
        children: [
          _CalendarHeader(currentMonth: _currentMonth, onPrev: _prevMonth, onNext: _nextMonth),
          _WeekdayHeader(),
          _DayGrid(
            daysInMonth: _daysInMonth,
            startWeekday: _startWeekday,
            currentMonth: _currentMonth,
            today: today,
            selectedDay: _selectedDay,
            dayTasks: _dayTasks,
            onDayTap: (day) {
              setState(() {
                final date = DateTime(_currentMonth.year, _currentMonth.month, day);
                _selectedDay = _selectedDay?.day == day ? null : date;
              });
            },
          ),
          const Divider(height: 1),
          Expanded(
            child: _selectedDay == null
                ? _SummaryPanel(repo: _repo)
                : _DayPanel(date: _selectedDay!, tasks: selectedTasks),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push('/tasks/new');
          setState(() {});
        },
        icon: const Icon(Icons.add),
        label: const Text('Nova Tarefa'),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  final DateTime currentMonth;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _CalendarHeader({required this.currentMonth, required this.onPrev, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final title = DateFormat('MMMM yyyy', 'pt_BR').format(currentMonth);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(icon: const Icon(Icons.chevron_left), onPressed: onPrev),
          Text(
            title[0].toUpperCase() + title.substring(1),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(icon: const Icon(Icons.chevron_right), onPressed: onNext),
        ],
      ),
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  static const _labels = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: _labels
            .map((d) => Expanded(
                  child: Center(
                    child: Text(d,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey.shade600)),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class _DayGrid extends StatelessWidget {
  final int daysInMonth;
  final int startWeekday;
  final DateTime currentMonth;
  final DateTime today;
  final DateTime? selectedDay;
  final List<Task> Function(int day) dayTasks;
  final void Function(int day) onDayTap;

  const _DayGrid({
    required this.daysInMonth,
    required this.startWeekday,
    required this.currentMonth,
    required this.today,
    required this.selectedDay,
    required this.dayTasks,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    final rows = ((startWeekday + daysInMonth) / 7).ceil();
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: List.generate(rows, (row) {
          return Row(
            children: List.generate(7, (col) {
              final index = row * 7 + col;
              final day = index - startWeekday + 1;

              if (day < 1 || day > daysInMonth) {
                return const Expanded(child: SizedBox(height: 52));
              }

              final date = DateTime(currentMonth.year, currentMonth.month, day);
              final isToday = date.day == today.day && date.month == today.month && date.year == today.year;
              final isSelected = selectedDay?.day == day &&
                  selectedDay?.month == currentMonth.month &&
                  selectedDay?.year == currentMonth.year;

              final tasks = dayTasks(day);

              return Expanded(
                child: GestureDetector(
                  onTap: () => onDayTap(day),
                  child: Container(
                    height: 52,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : isToday
                              ? theme.colorScheme.primaryContainer
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$day',
                          style: TextStyle(
                            fontWeight: isToday || isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 14,
                            color: isSelected
                                ? Colors.white
                                : isToday
                                    ? theme.colorScheme.primary
                                    : null,
                          ),
                        ),
                        if (tasks.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (tasks.any((t) => t.isPostponed))
                                const Text('⚠️', style: TextStyle(fontSize: 8)),
                              if (tasks.any((t) => t.type == TaskType.test))
                                _Dot(color: isSelected ? Colors.white : Colors.red),
                              if (tasks.any((t) => t.type == TaskType.work))
                                _Dot(color: isSelected ? Colors.white70 : Colors.blue),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  const _Dot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: 5,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _DayPanel extends StatelessWidget {
  final DateTime date;
  final List<Task> tasks;

  const _DayPanel({required this.date, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final title = DateFormat('EEEE, d \'de\' MMMM', 'pt_BR').format(date);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            title[0].toUpperCase() + title.substring(1),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
        Expanded(
          child: tasks.isEmpty
              ? const Center(child: Text('Nenhuma tarefa neste dia.', style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (ctx, i) => TaskCard(
                    task: tasks[i],
                    onTap: () => context.push('/tasks/${tasks[i].id}'),
                  ),
                ),
        ),
      ],
    );
  }
}

class _SummaryPanel extends StatelessWidget {
  final AppRepository repo;
  const _SummaryPanel({required this.repo});

  @override
  Widget build(BuildContext context) {
    final upcoming = repo.futureTasks.take(3).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text('Próximas Tarefas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        ),
        Expanded(
          child: upcoming.isEmpty
              ? const Center(child: Text('Nenhuma tarefa pendente.', style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  itemCount: upcoming.length,
                  itemBuilder: (ctx, i) => TaskCard(
                    task: upcoming[i],
                    onTap: () => context.push('/tasks/${upcoming[i].id}'),
                  ),
                ),
        ),
      ],
    );
  }
}
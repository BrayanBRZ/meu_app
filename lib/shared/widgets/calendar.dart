import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:meu_app/data/models/tag.dart';
import 'package:meu_app/data/models/task.dart';
import 'package:meu_app/shared/widgets/floating_card.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  final List<Task> tasks;
  final Map<int, Tag> tagsById;
  final ValueChanged<DateTime>? onDaySelected;

  const Calendar({
    super.key,
    required this.tasks,
    this.tagsById = const {},
    this.onDaySelected,
  });

  @override
  CalendarState createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<DateTime, List<Task>> get _taskSource {
    final source = <DateTime, List<Task>>{};
    for (final task in widget.tasks) {
      source.putIfAbsent(task.normalizedDate, () => []).add(task);
    }
    return source;
  }

  @override
  Widget build(BuildContext context) {
    final taskSource = _taskSource;

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingCard(
            padding: const EdgeInsets.all(16),
            child: TableCalendar<Task>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: calendarFormat,
              rowHeight: 60,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                widget.onDaySelected?.call(selectedDay);
              },
              eventLoader: (day) {
                final normalizedDay = DateTime(day.year, day.month, day.day);
                return taskSource[normalizedDay] ?? [];
              },
              calendarBuilders: CalendarBuilders(
                selectedBuilder: (context, date, events) {
                  return Container(
                    margin: const EdgeInsets.all(4),
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
                              colors: [
                                Colors.black.withValues(alpha: 0.25),
                                Colors.black.withValues(alpha: 0.65),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.black.withValues(alpha: 0.15),
                            ),
                          ),
                          child: Text(
                            '${date.day}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                markerBuilder: (context, date, tasks) {
                  if (tasks.isEmpty) return null;
                  final tag = widget.tagsById[tasks.first.tagId];
                  return Positioned(
                    bottom: 8,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: tag?.color ?? Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: Colors.black,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: Colors.black,
                ),
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: const Color(0xFFE1BEE7),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8),
                ),
                todayTextStyle: const TextStyle(
                  color: Color(0xFF7B1FA2),
                  fontWeight: FontWeight.bold,
                ),
                selectedDecoration: BoxDecoration(
                  color: const Color(0xFF9C27B0),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8),
                ),
                defaultDecoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
                weekendDecoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
                outsideDaysVisible: false,
                defaultTextStyle: const TextStyle(color: Colors.black),
                weekendTextStyle: const TextStyle(color: Colors.black),
              ),
              pageAnimationCurve: Curves.easeInOut,
              pageAnimationDuration: const Duration(milliseconds: 500),
            ),
          ),
        ],
      ),
    );
  }
}

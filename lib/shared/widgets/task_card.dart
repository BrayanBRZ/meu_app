import 'package:flutter/material.dart';
import 'package:meu_app/data/models/task.dart';
import 'package:meu_app/shared/widgets/floating_card.dart';

class TaskCard extends StatelessWidget {
  final List<Task> tasks;

  const TaskCard({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: FloatingCard(
        child: tasks.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.event_available,
                      size: 30,
                      color: Colors.black26,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Nenhuma tarefa para este dia',
                      style: TextStyle(color: Colors.black45, fontSize: 15),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: tasks.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  final today = DateTime.now();
                  final daysLeft = task.normalizedDate
                      .difference(DateTime(today.year, today.month, today.day))
                      .inDays;

                  final String daysLabel;
                  final Color labelColor;
                  if (daysLeft < 0) {
                    daysLabel =
                        'Vencida há ${daysLeft.abs()} dia${daysLeft.abs() == 1 ? '' : 's'}';
                    labelColor = Colors.red.shade400;
                  } else if (daysLeft == 0) {
                    daysLabel = 'Vence hoje';
                    labelColor = Colors.orange.shade600;
                  } else {
                    daysLabel =
                        '$daysLeft dia${daysLeft == 1 ? '' : 's'} restantes';
                    labelColor = Colors.black54;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(
                      top: 16,
                      left: 16,
                      right: 16,
                    ),
                    child: FloatingCard(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: MediaQuery.of(context).size.width * 0.16,
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/task/detail',
                          arguments: task,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE1BEE7),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                task.type.symbol,
                                color: const Color(0xFF9C27B0),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                task.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              daysLabel,
                              style: TextStyle(fontSize: 12, color: labelColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

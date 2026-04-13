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
        // padding: const EdgeInsets.symmetric(horizontal: 16),
        child: tasks.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.event_available,
                      size: 30,
                      color: Colors.black26,
                    ),
                    Text(
                      'Nenhuma tarefa para este dia',
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: tasks.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  final daysLeft = task.normalizedDate
                      .difference(DateTime.now())
                      .inDays;

                  final String daysLabel;
                  if (daysLeft < 0) {
                    daysLabel = 'Vencida há ${daysLeft.abs()} dias';
                  } else {
                    daysLabel = '$daysLeft dias restantes';
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
                        onTap: () => Navigator.pushReplacementNamed(context, '/task/edit'),
                        child: Row(
                          children: [
                            // Ícone
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
                            // Nome — trunca com "..." se ultrapassar
                            Expanded(
                              child: Text(
                                task.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                overflow:
                                    TextOverflow.ellipsis, // ✅ "..." no final
                                maxLines: 1,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Dias restantes — tamanho fixo para não deslocar
                            Text(
                              daysLabel,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
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

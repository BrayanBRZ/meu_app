import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../models/task.dart';

// Widgets compartilhados — reutilizáveis em múltiplas telas

/// Badge colorido com o nome da matéria.
class SubjectBadge extends StatelessWidget {
  final Subject subject;
  final bool small;

  const SubjectBadge({super.key, required this.subject, this.small = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 6 : 10,
        vertical: small ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: subject.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: subject.color, width: 1.2),
      ),
      child: Text(
        subject.name,
        style: TextStyle(
          color: subject.color,
          fontSize: small ? 10 : 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Card de task reutilizável para listas.
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;

  const TaskCard({super.key, required this.task, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final corTipo = task.type == TaskType.test
        ? Colors.red.shade700
        : Colors.blue.shade700;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho: type + badge adiada
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: corTipo.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${task.type.emoji} ${task.type.label}',
                      style: TextStyle(
                        color: corTipo,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (task.isPostponed) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        '⚠️ Adiada',
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  _DiasRestantesChip(task: task),
                ],
              ),
              const SizedBox(height: 8),
              // Title
              Text(
                task.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  decoration:
                      task.isPast ? TextDecoration.lineThrough : null,
                  color: task.isPast ? Colors.grey : null,
                ),
              ),
              const SizedBox(height: 6),
              // Date
              _DataRow(task: task),
              // Related subjects
              if (task.relatedSubjects.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: task.relatedSubjects
                      .map((s) => SubjectBadge(subject: s, small: true))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Subwidgets internos

class _DiasRestantesChip extends StatelessWidget {
  final Task task;
  const _DiasRestantesChip({required this.task});

  @override
  Widget build(BuildContext context) {
    if (task.isPast) {
      return const Text('Concluída', style: TextStyle(color: Colors.grey, fontSize: 12));
    }
    final dias = task.remainingDays;
    Color cor;
    String texto;
    if (dias == 0) {
      cor = Colors.red;
      texto = 'Hoje!';
    } else if (dias <= 3) {
      cor = Colors.orange;
      texto = '$dias dias';
    } else {
      cor = Colors.green;
      texto = '$dias dias';
    }
    return Text(texto, style: TextStyle(color: cor, fontWeight: FontWeight.bold, fontSize: 12));
  }
}

class _DataRow extends StatelessWidget {
  final Task task;
  const _DataRow({required this.task});

  String _fmt(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';

  @override
  Widget build(BuildContext context) {
    if (task.isPostponed) {
      return Row(
        children: [
          const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
          const SizedBox(width: 4),
          Text(
            'Original: ${_fmt(task.originalDate)}',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward, size: 14, color: Colors.deepOrange),
          const SizedBox(width: 4),
          Text(
            _fmt(task.currentDate),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }
    return Row(
      children: [
        const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          _fmt(task.currentDate),
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
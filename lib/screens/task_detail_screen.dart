import 'package:flutter/material.dart';
import 'package:meu_app/data/models/tag.dart';
import 'package:meu_app/data/models/task.dart';
import 'package:meu_app/services/tag_service.dart';
import 'package:meu_app/services/task_service.dart';
import 'package:meu_app/shared/formatters.dart';
import 'package:meu_app/shared/widgets/floating_card.dart';
import 'package:meu_app/shared/widgets/top_bar.dart';

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({super.key});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final _taskService = TaskService();
  final _tagService = TagService();
  late Task _task;
  late Future<Tag?> _tagFuture;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _task = ModalRoute.of(context)!.settings.arguments as Task;
    _tagFuture = _tagService.findById(_task.tagId);
    _initialized = true;
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir atividade'),
        content: const Text('Deseja excluir esta atividade?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _taskService.delete(_task);
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nao foi possivel excluir a atividade.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayNorm = DateTime(today.year, today.month, today.day);
    final daysLeft = _task.normalizedDate.difference(todayNorm).inDays;
    final daysLabel = daysLeft < 0
        ? 'Vencida ha ${daysLeft.abs()} dia${daysLeft.abs() == 1 ? '' : 's'}'
        : daysLeft == 0
            ? 'Vence hoje'
            : '$daysLeft dia${daysLeft == 1 ? '' : 's'} restantes';
    final daysColor = daysLeft < 0
        ? Colors.red.shade400
        : daysLeft == 0
            ? Colors.orange.shade600
            : const Color(0xFF9C27B0);
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const TopBar(screenName: 'Detalhes'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    FutureBuilder<Tag?>(
                      future: _tagFuture,
                      builder: (context, snapshot) {
                        final tag = snapshot.data;
                        return FloatingCard(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (tag != null)
                                _InfoRow(
                                  icon: Icons.label_outline,
                                  label: tag.title,
                                  color: tag.color,
                                ),
                              const SizedBox(height: 14),
                              Text(
                                _task.title,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Descricao',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _task.hasDescription
                                    ? _task.description!
                                    : 'Sem descricao.',
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 20),
                              _InfoRow(
                                icon: Icons.calendar_month_outlined,
                                label: formatDate(_task.targetDate),
                              ),
                              const SizedBox(height: 8),
                              _InfoRow(
                                icon: Icons.repeat_rounded,
                                label: regularityLabel(_task.regularity),
                              ),
                              if (_task.reminderId != null) ...[
                                const SizedBox(height: 8),
                                const _InfoRow(
                                  icon: Icons.notifications_active_outlined,
                                  label: 'Lembrete personalizado',
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    FloatingCard(
                      height: w * 0.18,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Icon(
                            daysLeft < 0
                                ? Icons.warning_amber_rounded
                                : Icons.access_time_rounded,
                            color: daysColor,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            daysLabel,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: daysColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _ActionButton(
                            label: 'Editar',
                            icon: Icons.edit_outlined,
                            color: const Color(0xFF9C27B0),
                            onTap: () => Navigator.pushNamed(
                              context,
                              '/task/edit',
                              arguments: _task,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ActionButton(
                            label: 'Excluir',
                            icon: Icons.delete_outline_rounded,
                            color: Colors.red.shade400,
                            onTap: _delete,
                            outlined: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _ActionButton(
                      label: 'Voltar',
                      icon: Icons.arrow_back_rounded,
                      color: Colors.black54,
                      onTap: () => Navigator.pop(context),
                      outlined: true,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoRow({
    required this.icon,
    required this.label,
    this.color = const Color(0xFF9C27B0),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool outlined;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.width * 0.14,
        decoration: BoxDecoration(
          color: outlined ? Colors.white : color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: outlined ? color : Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: outlined ? color : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

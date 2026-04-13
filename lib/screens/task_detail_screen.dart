import 'package:flutter/material.dart';
import 'package:meu_app/data/models/task.dart';
import 'package:meu_app/shared/widgets/floating_card.dart';
import 'package:meu_app/shared/widgets/top_bar.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key});

  String _formatDate(DateTime date) {
    const months = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    return '${date.day} de ${months[date.month - 1]} de ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final task = ModalRoute.of(context)!.settings.arguments as Task?;
    if (task == null) {
      return const Scaffold(body: Center(child: Text('Tarefa não encontrada.')));
    }

    final today = DateTime.now();
    final todayNorm =
        DateTime(today.year, today.month, today.day);
    final daysLeft =
        task.normalizedDate.difference(todayNorm).inDays;

    final String daysLabel;
    final Color daysColor;
    if (daysLeft < 0) {
      daysLabel = 'Vencida há ${daysLeft.abs()} dia${daysLeft.abs() == 1 ? '' : 's'}';
      daysColor = Colors.red.shade400;
    } else if (daysLeft == 0) {
      daysLabel = 'Vence hoje!';
      daysColor = Colors.orange.shade600;
    } else {
      daysLabel = '$daysLeft dia${daysLeft == 1 ? '' : 's'} restantes';
      daysColor = const Color(0xFF9C27B0);
    }

    final String typeLabel =
        task.type == TaskType.test ? 'Prova' : 'Trabalho';

    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            TopBar(screenName: 'Detalhes'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    // ── Card principal ────────────────────────────────
                    FloatingCard(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tipo badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE1BEE7),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(task.type.symbol,
                                    color: const Color(0xFF9C27B0),
                                    size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  typeLabel,
                                  style: const TextStyle(
                                    color: Color(0xFF9C27B0),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          // Título
                          Text(
                            task.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Descrição
                          const Text(
                            'Descrição',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black45,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            task.description.isNotEmpty
                                ? task.description
                                : 'Sem descrição.',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Data
                          const Text(
                            'Data de Entrega',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black45,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                  Icons.calendar_month_outlined,
                                  size: 18,
                                  color: Color(0xFF9C27B0)),
                              const SizedBox(width: 8),
                              Text(
                                _formatDate(task.normalizedDate),
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── Contagem de dias ──────────────────────────────
                    FloatingCard(
                      height: w * 0.18,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20),
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

                    // ── Ações ─────────────────────────────────────────
                    Row(
                      children: [
                        // Editar
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.pushNamed(
                              context,
                              '/task/edit',
                              arguments: task,
                            ),
                            child: Container(
                              height: w * 0.14,
                              decoration: BoxDecoration(
                                color: const Color(0xFF9C27B0),
                                borderRadius:
                                    BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.purple
                                        .withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.edit_outlined,
                                      color: Colors.white, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Editar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Excluir
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.pushReplacementNamed(
                                context, '/confirm-action'),
                            child: Container(
                              height: w * 0.14,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.10),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.delete_outline_rounded,
                                      color: Colors.red.shade400,
                                      size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Excluir',
                                    style: TextStyle(
                                      color: Colors.red.shade400,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // ── Voltar ────────────────────────────────────────
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: double.infinity,
                        height: w * 0.14,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_back_rounded,
                                color: Colors.black54, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Voltar',
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
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
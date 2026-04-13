import 'package:flutter/material.dart';
import 'package:meu_app/data/models/task.dart';
import 'package:meu_app/shared/widgets/floating_card.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:ui';

class Calendar extends StatefulWidget {
  final List<Task> tasks;
  final ValueChanged<DateTime>? onDaySelected;

  const Calendar({super.key, required this.tasks, this.onDaySelected});

  @override
  CalendarState createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Task>> taskSource = {};

  @override
  void initState() {
    super.initState();
    _populateTaskSource();
  }

  void _populateTaskSource() {
    for (var task in widget.tasks) {
      final key = task.normalizedDate;
      if (taskSource[key] == null) {
        taskSource[key] = [];
      }
      taskSource[key]!.add(task);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              sixWeekMonthsEnforced: false,
              shouldFillViewport: false,
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
                  // 1. O contêiner de margem é essencial para o BackdropFilter funcionar
                  // em torno do número sem afetar o resto do calendário.
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        10,
                      ), // Bordas um pouco mais suaves
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 6,
                          sigmaY: 6,
                        ), // Desfoque um pouco mais forte
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            // --- 2. A MÁGICA DO VIDRO GRADIENTE ---
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.25),
                                Colors.black.withOpacity(0.65),
                              ],
                              // Você pode ajustar onde o gradiente troca de cor (0.0 a 1.0)
                              stops: const [0.0, 1.0],
                            ),

                            borderRadius: BorderRadius.circular(10),

                            // --- 3. A BORDA BRILHANTE (EFETIVA "BORDA DE VIDRO") ---
                            border: Border.all(
                              // Usamos branco brilhante, mas com transparência
                              color: Colors.black.withOpacity(0.15),
                              width:
                                  1.0, // Borda um pouco mais grossa para destacar
                            ),

                            // --- 4. PROFUNDIDADE (OPCIONAL, MAS DÁ UM TOQUE PREMIUM) ---
                            // Adiciona um brilho interno sutil
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.1),
                                offset: const Offset(-2, -2),
                                blurRadius: 10,
                                spreadRadius: -2,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Número do dia
                              Text(
                                '${date.day}',
                                style: const TextStyle(
                                  // Branco para contraste com o vidro roxo
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      18, // Um pouco maior para imitar o foco da imagem
                                ),
                              ),

                              // Se o dia tiver eventos, desenhe o marcador aqui
                              // (Substitua por um ícone se você tiver, senão deixe o espaço)
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                markerBuilder: (context, date, tasks) {
                  if (tasks.isNotEmpty) {
                    final isSelected = isSameDay(date, _selectedDay);
                    final hasTest = tasks.firstWhere(
                      (t) => t.type == TaskType.test,
                      orElse: () => tasks.first,
                    );
                    return Positioned(
                      bottom: 8,
                      // child: ClipRRect(
                      //   borderRadius: BorderRadius.circular(6),
                      //   child: BackdropFilter(
                      //     filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                      // child:
                      // Container(
                      //   padding: const EdgeInsets.symmetric(
                      //     horizontal: 4,
                      //     vertical: 2,
                      //   ),
                      //   decoration: BoxDecoration(
                      //     color: isSelected
                      //         ? Colors.white.withOpacity(
                      //             0.25,
                      //           ) // vidro claro no selecionado
                      //         : Colors.purple.withOpacity(
                      //             0.15,
                      //           ), // vidro roxo no normal
                      //     borderRadius: BorderRadius.circular(6),
                      //     border: Border.all(
                      //       color: isSelected
                      //           ? Colors.white.withOpacity(0.5)
                      //           : Colors.purple.withOpacity(0.3),
                      //       width: 0.8,
                      //     ),
                      //   ),
                      child: Icon(
                        hasTest.type.symbol,
                        color: isSelected
                            ? Colors.white
                            : Colors.black,
                        size: 12,
                      ),
                      // ),
                      // ),
                      // ),
                    );
                  }
                  return null; // Se não houver eventos, não mostra nada
                },
              ),

              // Estilização do Header (Meses e Setas)
              headerStyle: HeaderStyle(
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

              // Estilização dos Dias e Cores
              calendarStyle: CalendarStyle(
                // Dia Atual (Leve e claro)
                todayDecoration: BoxDecoration(
                  color: Color(0xFFE1BEE7), // Roxo bem clarinho
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8),
                ),
                todayTextStyle: TextStyle(
                  color: Color(0xFF7B1FA2),
                  fontWeight: FontWeight.bold,
                ),

                // Dia Selecionado (Roxo Vibrante)
                selectedDecoration: BoxDecoration(
                  color: Color(0xFF9C27B0), // Roxo principal
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
                defaultTextStyle: TextStyle(color: Colors.black),
                weekendTextStyle: TextStyle(color: Colors.black),
              ),

              // Animação de troca de mês
              pageAnimationCurve: Curves.easeInOut,
              pageAnimationDuration: const Duration(milliseconds: 500),
            ),
          ),
        ],
      ),
    );
  }
}

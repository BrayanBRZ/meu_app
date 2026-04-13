import 'package:flutter/material.dart';
import 'package:meu_app/shared/widgets/bottom_nav.dart';
import 'package:meu_app/shared/widgets/floating_card.dart';
import 'package:meu_app/shared/widgets/top_bar.dart';

class AddSubjectScreen extends StatefulWidget {
  const AddSubjectScreen({super.key});

  @override
  State<AddSubjectScreen> createState() => _AddSubjectScreenState();
}

class _AddSubjectScreenState extends State<AddSubjectScreen> {
  final _nameController = TextEditingController();
  final _teacherController = TextEditingController();
  int _selectedColorIndex = 0;

  // final List<Color> _colors = [
  //   const Color(0xFF9C27B0), // Roxo
  //   const Color(0xFF2196F3), // Azul
  //   const Color(0xFF4CAF50), // Verde
  //   const Color(0xFFFF9800), // Laranja
  //   const Color(0xFFF44336), // Vermelho
  //   const Color(0xFF009688), // Teal
  // ];

  final List<IconData> _icons = [
    Icons.functions_outlined,
    Icons.bolt_outlined,
    Icons.account_tree_outlined,
    Icons.grid_on_outlined,
    Icons.code_outlined,
    Icons.science_outlined,
    Icons.history_edu_outlined,
    Icons.language_outlined,
  ];

  int _selectedIconIndex = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _teacherController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe o nome da matéria.')),
      );
      return;
    }
    Navigator.pushReplacementNamed(context, '/confirm-action');
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            TopBar(screenName: 'Adicionar Matéria'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // # Nome 
                    const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 6),
                      child: Text(
                        'Nome da Matéria',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    FloatingCard(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: 'Ex: Cálculo I',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // # Professor 
                    const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 6),
                      child: Text(
                        'Professor',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    FloatingCard(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: TextField(
                        controller: _teacherController,
                        decoration: const InputDecoration(
                          hintText: 'Ex: Prof. João Silva',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // # Cor 
                    const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 10),
                      child: Text(
                        'Cor',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    // FloatingCard(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 16, vertical: 16),
                    //   child: Row(
                    //     mainAxisAlignment:
                    //         MainAxisAlignment.spaceAround,
                    //     children: List.generate(_colors.length, (i) {
                    //       final isSelected = _selectedColorIndex == i;
                    //       return GestureDetector(
                    //         onTap: () =>
                    //             setState(() => _selectedColorIndex = i),
                    //         child: AnimatedContainer(
                    //           duration:
                    //               const Duration(milliseconds: 200),
                    //           width: isSelected ? 38 : 32,
                    //           height: isSelected ? 38 : 32,
                    //           decoration: BoxDecoration(
                    //             color: _colors[i],
                    //             shape: BoxShape.circle,
                    //             boxShadow: isSelected
                    //                 ? [
                    //                     BoxShadow(
                    //                       color: _colors[i]
                    //                           .withOpacity(0.5),
                    //                       blurRadius: 10,
                    //                       spreadRadius: 2,
                    //                     ),
                    //                   ]
                    //                 : [],
                    //           ),
                    //           child: isSelected
                    //               ? const Icon(
                    //                   Icons.check_rounded,
                    //                   color: Colors.white,
                    //                   size: 18,
                    //                 )
                    //               : null,
                    //         ),
                    //       );
                    //     }),
                    //   ),
                    // ),
                    const SizedBox(height: 16),

                    // # Ícone
                    const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 10),
                      child: Text(
                        'Ícone',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    FloatingCard(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: List.generate(_icons.length, (i) {
                          // final isSelected = _selectedIconIndex == i;
                          // final color = _colors[_selectedColorIndex];
                          return GestureDetector(
                            onTap: () =>
                                setState(() => _selectedIconIndex = i),
                            child: AnimatedContainer(
                              duration:
                                  const Duration(milliseconds: 200),
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                // color: isSelected
                                //     ? color.withOpacity(0.15)
                                //     : Colors.black.withOpacity(0.04),
                                borderRadius:
                                    BorderRadius.circular(12),
                                border: Border.all(
                                  // color: isSelected
                                  //     ? color
                                  //     : Colors.transparent,
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                _icons[i],
                                // color: isSelected
                                //     ? color
                                //     : Colors.black45,
                                size: 22,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // # Preview 
                    const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 10),
                      child: Text(
                        'Prévia',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    FloatingCard(
                      height: w * 0.18,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              // color: _colors[_selectedColorIndex]
                              //     .withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _icons[_selectedIconIndex],
                              // color: _colors[_selectedColorIndex],
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                _nameController.text.isEmpty
                                    ? 'Nome da Matéria'
                                    : _nameController.text,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                _teacherController.text.isEmpty
                                    ? 'Nome do Professor'
                                    : _teacherController.text,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black45),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // # Salvar
                    GestureDetector(
                      onTap: _submit,
                      child: Container(
                        width: double.infinity,
                        height: w * 0.16,
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              // color: _colors[_selectedColorIndex]
                              //     .withOpacity(0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_rounded,
                                color: Colors.white, size: 22),
                            SizedBox(width: 8),
                            Text(
                              'Salvar Matéria',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
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
      bottomNavigationBar: BottomNav(currentIndex: null),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:meu_app/shared/widgets/floating_card.dart';

class ConfirmActionScreen extends StatelessWidget {
  const ConfirmActionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centraliza o CARD na tela
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: FloatingCard(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle_outline_rounded,
                          color: Colors.green,
                          size: 80,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Validado",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:meu_app/shared/widgets/floating_card.dart';

class TopBar extends StatelessWidget {
  final String screenName;

  const TopBar({super.key, required this.screenName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: FloatingCard(
        height: MediaQuery.of(context).size.width * 0.16,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Align(
          child: Text(
            screenName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

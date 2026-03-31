import 'package:flutter/material.dart';

void main() async {
  runApp(const SchoolDiaryApp(title: 'Agenda Escolar'));
}

class SchoolDiaryApp extends StatelessWidget {
  final String title;

  const SchoolDiaryApp({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda Escolar',
      theme: ThemeData.dark(),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  int counter = 0;

  Widget build(BuildContext) {
    return Container(
      child: Center(
        child: GestureDetector(
          child: Text('Contador: $counter'),
          onTap: () {
            setState(() {
              counter++;
            });
          }
        ),
      ),
    );
  }
}


//GoRoute
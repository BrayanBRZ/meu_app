import 'subject.dart';

enum TaskType {
  test,
  work;

  String get label => switch (this) {
    TaskType.test => 'Prova',
    TaskType.work => 'Trabalho',
  };
}

class Task {
  final String id;
  String title;
  String description;
  TaskType type;
  DateTime originalDate;
  DateTime currentDate;
  List<Subject> relatedSubjects;

  Task(
    this.id,
    this.title,
    this.description,
    this.type,
    this.originalDate,
    this.relatedSubjects,
  ) : currentDate = originalDate;

  // Getters
  bool get isPostponed => currentDate.isAfter(originalDate);

  bool get isPast => currentDate.isBefore(DateTime.now());

  String get labelType => type.label;

  int get remainingDays => currentDate.difference(DateTime.now()).inDays;

  // Business Rules
  void remarkTask(DateTime newDate) {
    if (currentDate.isBefore(newDate)) {
      print('A nova data ($newDate) deve ser hoje ou uma data futura.');
    }
    currentDate = newDate;
  }

  void remarkOriginalDate(DateTime newDate) {
    originalDate = currentDate = newDate;
  }

  void relateSubject(Subject subject) {
    if (!relatedSubjects.contains(subject)) {
      relatedSubjects.add(subject);
    }
  }

  void disconnectSubject(Subject subject) {
    if (relatedSubjects.contains(subject)) {
      relatedSubjects.remove(subject);
    }
  }

  String formattedDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

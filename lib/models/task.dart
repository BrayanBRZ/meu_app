import 'subject.dart';

// Enum de type de tarefa
enum TaskType {
  test,
  work;

  String get label => switch (this) {
    TaskType.test => 'Prova',
    TaskType.work => 'Trabalho',
  };

  String get emoji => switch (this) {
    TaskType.test => '📝',
    TaskType.work => '📁',
  };
}

/// Base para erros de negócio da [Task].
abstract class TaskException implements Exception {
  final String message;
  const TaskException(this.message);

  @override
  String toString() => message;
}

class DataInvalidaException extends TaskException {
  const DataInvalidaException(super.message);
}

/// Modelo de tarefa
class Task {
  final String id;
  String title;
  String description;
  TaskType type;

  /// [TaskType.test] ou [TaskType.work].
  DateTime originalDate;
  DateTime currentDate;
  List<Subject> relatedSubjects;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.originalDate,
    List<Subject>? relatedSubjects,
  }) : currentDate = originalDate,
       relatedSubjects = relatedSubjects ?? [];

  // Getters

  bool get isPostponed => currentDate.isAfter(
    DateTime(originalDate.year, originalDate.month, originalDate.day, 23, 59),
  );

  bool get isPast {
    final today = DateTime.now();
    return currentDate.isBefore(DateTime(today.year, today.month, today.day));
  }

  String get labelType => type.label;

  /// Quantidade de dias restantes até a data atual (negativo se passada).
  int get remainingDays {
    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);
    final normalizedDate = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
    );
    return normalizedDate.difference(todayNormalized).inDays;
  }

  // Business Rules
  void remarkCurrentDate(DateTime date) {
    currentDate = date;
  }

  void remarkOriginalDate(DateTime newDate) {
    originalDate = currentDate = newDate;
  }

  /// Remarca a tarefa para [newDate].
  /// Lança [DataInvalidaException] se [newDate] não for uma data futura.
  void remarkTask(DateTime newDate) {
    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);
    final newNormalized = DateTime(newDate.year, newDate.month, newDate.day);

    if (newNormalized.isBefore(todayNormalized)) {
      throw DataInvalidaException(
        'A nova data (${_formatarData(newDate)}) deve ser hoje ou uma data futura.',
      );
    }

    if (newNormalized ==
        DateTime(originalDate.year, originalDate.month, originalDate.day)) {
      currentDate = originalDate;
      return;
    }

    currentDate = newDate;
  }

  /// Vincula uma [Subject] à tarefa (relação N:M).
  void vincularMateria(Subject subject) {
    if (!relatedSubjects.contains(subject)) {
      relatedSubjects.add(subject);
    }
  }

  /// Remove o vínculo com uma [Subject].
  void desvincularMateria(Subject subject) {
    relatedSubjects.remove(subject);
  }

  String _formatarData(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';

  // Contratos de identidade e cópia
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subject && runtimeType == other.runtimeType && id == other.id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Task(id: $id, title: $title, type: $labelType, isAdiada: $isPast)';

  /// Permite criar uma cópia editada mantendo a imutabilidade do [id] e [originalDate].
  Task copyWith({
    String? title,
    String? description,
    TaskType? type,
    List<Subject>? relatedSubjects,
  }) {
    final copy = Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      originalDate: originalDate,
      relatedSubjects: relatedSubjects ?? List.from(this.relatedSubjects),
    );
    copy.currentDate = currentDate;
    return copy;
  }
}

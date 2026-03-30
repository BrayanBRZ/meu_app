import '../models/subject.dart';
import '../models/task.dart';

/// AppRepository — Singleton
class AppRepository {
  AppRepository._internal();
  static final AppRepository instance = AppRepository._internal();

  // Estado interno (fonte única da verdade) 
  final List<Subject> _subjects = [];
  final List<Task> _tasks = [];

  // Matérias padrão
  static final List<Subject> _defaultSubjects = [
    Subject(id: 'mat-001', name: 'Matemática', corHex: '4CAF50'),
    Subject(id: 'mat-002', name: 'Português', corHex: '2196F3'),
    Subject(id: 'mat-003', name: 'História', corHex: 'FF9800'),
    Subject(id: 'mat-004', name: 'Ciências', corHex: '9C27B0'),
    Subject(id: 'mat-005', name: 'Inglês', corHex: 'F44336'),
    Subject(id: 'mat-006', name: 'Física', corHex: '00BCD4'),
    Subject(id: 'mat-007', name: 'Química', corHex: 'FF5722'),
    Subject(id: 'mat-008', name: 'Educação Física', corHex: '8BC34A'),
  ];

  void inicializar() {
    _subjects.addAll(
      _defaultSubjects.map(
        (m) => Subject(id: m.id, name: m.name, corHex: m.corHex),
      ),
    );

    // Cria tasks mockadas
    final today = DateTime.now();
    final mat = _subjects;

    _tasks.addAll([
      Task(
        id: 'tar-001',
        title: 'Prova de Cálculo Diferencial',
        description: 'Capítulos 3 a 7 do livro — derivadas, limites e integrais.',
        type: TaskType.test,
        originalDate: today.add(const Duration(days: 5)),
        relatedSubjects: [mat[0]], // Matemática
      ),
      _criarTaskAdiada(
        id: 'tar-002',
        title: 'Trabalho de Redação',
        description:
            'Tema: Impactos das Redes Sociais na Comunicação Contemporânea.',
        type: TaskType.work,
        originalDate: today.subtract(const Duration(days: 2)),
        currentDate: today.add(const Duration(days: 8)),
        subjects: [mat[1]], // Português
      ),
      Task(
        id: 'tar-003',
        title: 'Seminário: Segunda Guerra Mundial',
        description: 'Apresentação em grupo de 20 min. Slides obrigatórios.',
        type: TaskType.work,
        originalDate: today.add(const Duration(days: 12)),
        relatedSubjects: [mat[2]], // História
      ),
      _criarTaskAdiada(
        id: 'tar-004',
        title: 'Prova Bimestral de Física',
        description:
            'Todo o conteúdo do bimestre: dinâmica, cinemática e leis de Newton.',
        type: TaskType.test,
        originalDate: today.add(const Duration(days: 3)),
        currentDate: today.add(const Duration(days: 15)),
        subjects: [mat[0], mat[5]], // Matemática + Física (N:M!)
      ),
      Task(
        id: 'tar-005',
        title: 'Relatório de Experimento Químico',
        description: 'Documentar o experimento de titulação ácido-base.',
        type: TaskType.work,
        originalDate: today.subtract(const Duration(days: 10)), // passada
        relatedSubjects: [mat[6]], // Química
      ),
      Task(
        id: 'tar-006',
        title: 'Listening Test - Present Perfect',
        description: 'Exercícios de listening e grammar — Unit 5.',
        type: TaskType.test,
        originalDate: today.add(const Duration(days: 20)),
        relatedSubjects: [mat[4]], // Inglês
      ),
      Task(
        id: 'tar-007',
        title: 'Trabalho Interdisciplinar',
        description:
            'Projeto unindo Ciências e Português: artigo científico sobre biomas.',
        type: TaskType.work,
        originalDate: today.add(const Duration(days: 30)),
        relatedSubjects: [mat[1], mat[3]], // Português + Ciências (N:M!)
      ),
    ]);
  }

  Task _criarTaskAdiada({
    required String id,
    required String title,
    required String description,
    required TaskType type,
    required DateTime originalDate,
    required DateTime currentDate,
    required List<Subject> subjects,
  }) {
    final task = Task(
      id: id,
      title: title,
      description: description,
      type: type,
      originalDate: originalDate,
      relatedSubjects: subjects,
    );
    task.remarkCurrentDate(currentDate);
    return task;
  }

  // CRUD — Matérias

  List<Subject> get subjects => List.unmodifiable(_subjects);

  Subject? searchSubjectById(String id) {
    try {
      return _subjects.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  void addSubject(Subject materia) {
    if (!_subjects.any((m) => m.id == materia.id)) {
      _subjects.add(materia);
    }
  }

  void updateSubject(Subject materia) {
    final index = _subjects.indexWhere((m) => m.id == materia.id);
    if (index != -1) {
      _subjects[index] = materia;
    }
  }

  void removeSubject(String id) {
    _subjects.removeWhere((m) => m.id == id);
    for (final task in _tasks) {
      task.relatedSubjects.removeWhere((m) => m.id == id);
    }
  }

  void resetDefaultSubjects() {
    for (final padrao in _defaultSubjects) {
      if (!_subjects.any((m) => m.id == padrao.id)) {
        _subjects.add(
          Subject(
            id: padrao.id,
            name: padrao.name,
            corHex: padrao.corHex,
          ),
        );
      }
    }
  }

  // CRUD — Tasks

  List<Task> get tasks => List.unmodifiable(_tasks);

  List<Task> get futureTasks {
    return _tasks.where((t) => !t.isPast).toList()
      ..sort((a, b) => a.currentDate.compareTo(b.currentDate));
  }

  List<Task> get pastTasks {
    return _tasks.where((t) => t.isPast).toList()
      ..sort((a, b) => b.currentDate.compareTo(a.currentDate));
  }

  List<Task> monthTasks(int ano, int mes) {
    return _tasks
        .where((t) => t.currentDate.year == ano && t.currentDate.month == mes)
        .toList();
  }

  List<Task> dateTasks(DateTime data) {
    return _tasks
        .where(
          (t) =>
              t.currentDate.year == data.year &&
              t.currentDate.month == data.month &&
              t.currentDate.day == data.day,
        )
        .toList();
  }

  List<Task> subjectTasks(String materiaId) {
    return _tasks
        .where((t) => t.relatedSubjects.any((m) => m.id == materiaId))
        .toList();
  }

  Task? searchTaskById(String id) {
    try {
      return _tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  void addTask(Task task) {
    if (!_tasks.any((t) => t.id == task.id)) {
      _tasks.add(task);
    }
  }

  void updateTask(Task task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
    }
  }

  void removeTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
  }

  bool _notificacoesAtivas = true;
  bool get notificacoesAtivas => _notificacoesAtivas;
  void toggleNotificacoes() => _notificacoesAtivas = !_notificacoesAtivas;
}

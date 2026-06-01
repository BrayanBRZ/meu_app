import 'package:flutter/material.dart';
import 'package:meu_app/data/constants/default_tags.dart';
import 'package:meu_app/data/enums/regularity.dart';
import 'package:meu_app/data/models/reminder.dart';
import 'package:meu_app/data/models/subject.dart';
import 'package:meu_app/data/models/tag.dart';
import 'package:meu_app/data/models/task.dart';
import 'package:meu_app/services/subject_service.dart';
import 'package:meu_app/services/tag_service.dart';
import 'package:meu_app/services/task_service.dart';
import 'package:meu_app/shared/formatters.dart';
import 'package:meu_app/shared/widgets/bottom_nav.dart';
import 'package:meu_app/shared/widgets/floating_card.dart';
import 'package:meu_app/shared/widgets/top_bar.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => CreateTaskScreenState();
}

class CreateTaskScreenState extends State<CreateTaskScreen> {
  final _taskService = TaskService();
  final _tagService = TagService();
  final _subjectService = SubjectService();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  late Future<_TaskFormData> _future;
  Regularity _regularity = Regularity.single;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  int _selectedTagId = DefaultTags.commonId;
  int? _selectedSubjectId;
  bool _useCustomReminder = false;
  bool _reminderActive = true;
  Regularity _reminderRegularity = Regularity.single;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 12, minute: 0);
  int _remindBeforeMinutes = 30;

  @override
  void initState() {
    super.initState();
    _future = _loadData();
  }

  Future<_TaskFormData> _loadData() async {
    final tags = await _tagService.findAll();
    final subjects = await _subjectService.findAll();
    if (tags.isNotEmpty && !tags.any((tag) => tag.id == _selectedTagId)) {
      _selectedTagId = tags.first.id!;
    }
    return _TaskFormData(tags, subjects);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF9C27B0)),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickReminderTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (picked != null) setState(() => _reminderTime = picked);
  }

  Future<void> _submit() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe o titulo da atividade.')),
      );
      return;
    }

    final task = Task(
      title: _titleController.text,
      description: _descController.text,
      regularity: _regularity,
      targetDate: _selectedDate,
      tagId: _selectedTagId,
      subjectId: _selectedSubjectId,
    );

    try {
      await _taskService.create(
        task,
        customReminder: _useCustomReminder ? _buildReminder() : null,
      );
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nao foi possivel salvar a atividade.')),
      );
    }
  }

  Reminder _buildReminder() {
    return Reminder(
      regularity: _reminderRegularity,
      regularTime: DateTime(1970, 1, 1, _reminderTime.hour, _reminderTime.minute),
      remindBefore: Duration(minutes: _remindBeforeMinutes),
      isActive: _reminderActive,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const TopBar(screenName: 'Criar Atividade'),
            Expanded(
              child: FutureBuilder<_TaskFormData>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Nao foi possivel carregar o formulario.'),
                    );
                  }
                  final data = snapshot.data ?? _TaskFormData.empty();
                  return _buildForm(data);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: null),
    );
  }

  Widget _buildForm(_TaskFormData data) {
    final w = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('Titulo'),
          _textField(_titleController, 'Ex: Prova de Calculo'),
          const SizedBox(height: 16),
          _label('Descricao'),
          _textField(_descController, 'O que precisa ser feito?', maxLines: 3),
          const SizedBox(height: 16),
          _label('Data'),
          _pickerCard(formatDate(_selectedDate), Icons.calendar_month_outlined, _pickDate),
          const SizedBox(height: 16),
          _label('Regularidade'),
          _regularityDropdown(_regularity, (value) {
            if (value != null) setState(() => _regularity = value);
          }),
          const SizedBox(height: 16),
          _label('Tag'),
          _tagDropdown(data.tags),
          const SizedBox(height: 16),
          _label('Materia'),
          _subjectDropdown(data.subjects),
          const SizedBox(height: 16),
          _reminderSection(),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: _submit,
            child: Container(
              width: double.infinity,
              height: w * 0.16,
              decoration: BoxDecoration(
                color: const Color(0xFF9C27B0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_rounded, color: Colors.white, size: 22),
                  SizedBox(width: 8),
                  Text(
                    'Salvar Atividade',
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
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _textField(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return FloatingCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(hintText: hint, border: InputBorder.none),
      ),
    );
  }

  Widget _pickerCard(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: FloatingCard(
        height: MediaQuery.of(context).size.width * 0.16,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
            Icon(icon, color: const Color(0xFF9C27B0)),
          ],
        ),
      ),
    );
  }

  Widget _regularityDropdown(
    Regularity value,
    ValueChanged<Regularity?> onChanged,
  ) {
    return FloatingCard(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Regularity>(
          value: value,
          isExpanded: true,
          items: Regularity.values
              .map(
                (regularity) => DropdownMenuItem(
                  value: regularity,
                  child: Text(regularityLabel(regularity)),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _tagDropdown(List<Tag> tags) {
    return FloatingCard(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: tags.any((tag) => tag.id == _selectedTagId)
              ? _selectedTagId
              : null,
          isExpanded: true,
          items: tags
              .map(
                (tag) => DropdownMenuItem<int>(
                  value: tag.id,
                  child: Text(tag.title),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) setState(() => _selectedTagId = value);
          },
        ),
      ),
    );
  }

  Widget _subjectDropdown(List<Subject> subjects) {
    return FloatingCard(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int?>(
          value: _selectedSubjectId,
          isExpanded: true,
          items: [
            const DropdownMenuItem<int?>(
              value: null,
              child: Text('Sem materia'),
            ),
            ...subjects.map(
              (subject) => DropdownMenuItem<int?>(
                value: subject.id,
                child: Text(subject.title),
              ),
            ),
          ],
          onChanged: (value) => setState(() => _selectedSubjectId = value),
        ),
      ),
    );
  }

  Widget _reminderSection() {
    return FloatingCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Lembrete personalizado'),
            value: _useCustomReminder,
            onChanged: (value) => setState(() => _useCustomReminder = value),
          ),
          if (_useCustomReminder) ...[
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Ativo'),
              value: _reminderActive,
              onChanged: (value) => setState(() => _reminderActive = value),
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton<Regularity>(
                value: _reminderRegularity,
                isExpanded: true,
                items: Regularity.values
                    .map(
                      (regularity) => DropdownMenuItem(
                        value: regularity,
                        child: Text(regularityLabel(regularity)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _reminderRegularity = value);
                  }
                },
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Horario'),
              trailing: Text(_reminderTime.format(context)),
              onTap: _pickReminderTime,
            ),
            const SizedBox(height: 8),
            DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _remindBeforeMinutes,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 10, child: Text('10 min antes')),
                  DropdownMenuItem(value: 30, child: Text('30 min antes')),
                  DropdownMenuItem(value: 60, child: Text('1 hora antes')),
                  DropdownMenuItem(value: 1440, child: Text('1 dia antes')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _remindBeforeMinutes = value);
                  }
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TaskFormData {
  final List<Tag> tags;
  final List<Subject> subjects;

  _TaskFormData(this.tags, this.subjects);

  factory _TaskFormData.empty() => _TaskFormData(const [], const []);
}

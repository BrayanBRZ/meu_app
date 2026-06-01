import 'package:flutter/material.dart';
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

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({super.key});

  @override
  State<EditTaskScreen> createState() => EditTaskScreenState();
}

class EditTaskScreenState extends State<EditTaskScreen> {
  final _taskService = TaskService();
  final _tagService = TagService();
  final _subjectService = SubjectService();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late Future<_TaskFormData> _future;
  late Task _task;
  bool _initialized = false;

  Regularity _regularity = Regularity.single;
  DateTime _selectedDate = DateTime.now();
  int? _selectedTagId;
  int? _selectedSubjectId;
  bool _useCustomReminder = false;
  bool _reminderActive = true;
  Regularity _reminderRegularity = Regularity.single;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 12, minute: 0);
  int _remindBeforeMinutes = 30;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    _task = ModalRoute.of(context)!.settings.arguments as Task;
    _titleController = TextEditingController(text: _task.title);
    _descController = TextEditingController(text: _task.description ?? '');
    _regularity = _task.regularity;
    _selectedDate = _task.targetDate;
    _selectedTagId = _task.tagId;
    _selectedSubjectId = _task.subjectId;
    _future = _loadData();
    _initialized = true;
  }

  Future<_TaskFormData> _loadData() async {
    final tags = await _tagService.findAll();
    final subjects = await _subjectService.findAll();
    final reminder = await _taskService.findCustomReminder(_task);
    if (reminder != null) _applyReminder(reminder);
    return _TaskFormData(tags, subjects);
  }

  void _applyReminder(Reminder reminder) {
    _useCustomReminder = true;
    _reminderActive = reminder.isActive;
    _reminderRegularity = reminder.regularity;
    _reminderTime = TimeOfDay(
      hour: reminder.regularTime.hour,
      minute: reminder.regularTime.minute,
    );
    _remindBeforeMinutes = reminder.remindBefore.inMinutes;
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
      id: _task.id,
      title: _titleController.text,
      description: _descController.text,
      regularity: _regularity,
      targetDate: _selectedDate,
      tagId: _selectedTagId ?? _task.tagId,
      subjectId: _selectedSubjectId,
    );

    try {
      await _taskService.update(
        task,
        customReminder: _useCustomReminder ? _buildReminder() : null,
        previousReminderId: _task.reminderId,
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
            const TopBar(screenName: 'Editar Atividade'),
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
                  return _buildForm(snapshot.data ?? _TaskFormData.empty());
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
          _textField(_titleController, 'Titulo'),
          const SizedBox(height: 16),
          _label('Descricao'),
          _textField(_descController, 'Descricao', maxLines: 3),
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
                    'Salvar Alteracoes',
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

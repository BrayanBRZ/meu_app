import 'package:flutter/material.dart';
import 'package:meu_app/data/enums/regularity.dart';
import 'package:meu_app/data/models/reminder.dart';
import 'package:meu_app/data/models/tag.dart';
import 'package:meu_app/services/tag_service.dart';
import 'package:meu_app/shared/formatters.dart';
import 'package:meu_app/shared/widgets/bottom_nav.dart';
import 'package:meu_app/shared/widgets/floating_card.dart';
import 'package:meu_app/shared/widgets/top_bar.dart';

class TagFormScreen extends StatefulWidget {
  const TagFormScreen({super.key});

  @override
  State<TagFormScreen> createState() => _TagFormScreenState();
}

class _TagFormScreenState extends State<TagFormScreen> {
  final _tagService = TagService();
  final _titleController = TextEditingController();
  final _colors = const [
    Colors.white,
    Colors.red,
    Colors.orange,
    Colors.green,
    Colors.blue,
    Colors.purple,
  ];

  Tag? _tag;
  Color _selectedColor = Colors.white;
  bool _reminderActive = true;
  Regularity _reminderRegularity = Regularity.single;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 12, minute: 0);
  int _remindBeforeMinutes = 30;
  bool _initialized = false;
  late Future<void> _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    _tag = ModalRoute.of(context)!.settings.arguments as Tag?;
    final tag = _tag;
    if (tag != null) {
      _titleController.text = tag.title;
      _selectedColor = tag.color;
    }
    _future = _loadReminder();
    _initialized = true;
  }

  Future<void> _loadReminder() async {
    final tag = _tag;
    if (tag == null) return;
    final reminder = await _tagService.findReminder(tag);
    if (reminder == null) return;
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
    super.dispose();
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
        const SnackBar(content: Text('Informe o nome da tag.')),
      );
      return;
    }

    final currentTag = _tag;
    final tag = Tag(
      id: currentTag?.id,
      title: _titleController.text,
      color: _selectedColor,
      reminderId: currentTag?.reminderId,
      isDefault: currentTag?.isDefault ?? false,
    );

    try {
      if (currentTag == null) {
        await _tagService.create(tag, _buildReminder());
      } else {
        await _tagService.update(tag, _buildReminder());
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nao foi possivel salvar a tag.')),
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
            TopBar(screenName: _tag == null ? 'Criar Tag' : 'Editar Tag'),
            Expanded(
              child: FutureBuilder<void>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return _buildForm();
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: null),
    );
  }

  Widget _buildForm() {
    final w = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('Nome'),
          FloatingCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Ex: Seminario',
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _label('Cor'),
          Wrap(
            spacing: 10,
            children: _colors.map((color) {
              final selected = color.toARGB32() == _selectedColor.toARGB32();
              return GestureDetector(
                onTap: () => setState(() => _selectedColor = color),
                child: CircleAvatar(
                  backgroundColor: color,
                  child: selected ? const Icon(Icons.check) : null,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          _label('Lembrete da Tag'),
          FloatingCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
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
            ),
          ),
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
                  Icon(Icons.check_rounded, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Salvar Tag',
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
}

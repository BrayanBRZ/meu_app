import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../data/app_repository.dart';
import '../models/subject.dart';

class FormSubjectScreen extends StatefulWidget {
  final Subject? subject;

  const FormSubjectScreen({super.key, this.subject});

  @override
  State<FormSubjectScreen> createState() => _FormSubjectScreenState();
}

class _FormSubjectScreenState extends State<FormSubjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _repo = AppRepository.instance;
  final _uuid = const Uuid();

  late final TextEditingController _nameCtrl;
  late String _selectedHex;

  bool get _isEditing => widget.subject != null;

  static const _palette = [
    _ColorOption('4CAF50', 'Verde'),
    _ColorOption('2196F3', 'Azul'),
    _ColorOption('F44336', 'Vermelho'),
    _ColorOption('FF9800', 'Laranja'),
    _ColorOption('9C27B0', 'Roxo'),
    _ColorOption('00BCD4', 'Ciano'),
    _ColorOption('FF5722', 'Laranja Escuro'),
    _ColorOption('8BC34A', 'Verde Claro'),
    _ColorOption('E91E63', 'Rosa'),
    _ColorOption('607D8B', 'Cinza'),
    _ColorOption('795548', 'Marrom'),
    _ColorOption('FFC107', 'Amarelo'),
  ];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.subject?.name ?? '');
    _selectedHex = widget.subject?.corHex ?? _palette.first.hex;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Color get _currentColor {
    final h = _selectedHex.padLeft(6, '0');
    return Color(int.parse('FF$h', radix: 16));
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    if (_isEditing) {
      _repo.updateSubject(widget.subject!.copyWith(name: _nameCtrl.text.trim(), corHex: _selectedHex));
    } else {
      _repo.addSubject(Subject(id: _uuid.v4(), name: _nameCtrl.text.trim(), corHex: _selectedHex));
    }

    if (mounted) context.pop();
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remover Matéria'),
        content: Text('Deseja remover "${widget.subject!.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remover'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      _repo.removeSubject(widget.subject!.id);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Matéria' : 'Nova Matéria',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: _delete,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Preview do avatar
            Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: _currentColor,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: _currentColor.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: Center(
                  child: Text(
                    _nameCtrl.text.isNotEmpty ? _nameCtrl.text[0].toUpperCase() : '?',
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Campo: Nome
            _Label('Nome da Matéria'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                hintText: 'Ex: Matemática, Física...',
                prefixIcon: Icon(Icons.book_outlined),
              ),
              onChanged: (_) => setState(() {}),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Informe o nome da matéria.';
                if (v.trim().length < 2) return 'Nome muito curto.';
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Seletor de cor
            _Label('Cor da Matéria'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _palette.map((option) {
                final color = Color(int.parse('FF${option.hex}', radix: 16));
                final isSelected = option.hex == _selectedHex;
                return Tooltip(
                  message: option.name,
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedHex = option.hex),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Theme.of(context).colorScheme.onSurface, width: 3)
                            : null,
                        boxShadow: isSelected
                            ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 8, offset: const Offset(0, 2))]
                            : null,
                      ),
                      child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 22) : null,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 40),

            // Botão salvar
            FilledButton.icon(
              onPressed: _save,
              icon: Icon(_isEditing ? Icons.save : Icons.check),
              label: Text(_isEditing ? 'Salvar Alterações' : 'Criar Matéria',
                  style: const TextStyle(fontSize: 16)),
              style: FilledButton.styleFrom(
                backgroundColor: _currentColor,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 13,
        color: Theme.of(context).colorScheme.primary,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _ColorOption {
  final String hex;
  final String name;
  const _ColorOption(this.hex, this.name);
}
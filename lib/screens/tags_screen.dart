import 'package:flutter/material.dart';
import 'package:meu_app/data/models/tag.dart';
import 'package:meu_app/services/tag_service.dart';
import 'package:meu_app/shared/widgets/bottom_nav.dart';
import 'package:meu_app/shared/widgets/floating_card.dart';
import 'package:meu_app/shared/widgets/top_bar.dart';

class TagsScreen extends StatefulWidget {
  const TagsScreen({super.key});

  @override
  State<TagsScreen> createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
  final _tagService = TagService();
  late Future<List<Tag>> _future;

  @override
  void initState() {
    super.initState();
    _future = _tagService.findAll();
  }

  void _reload() {
    setState(() => _future = _tagService.findAll());
  }

  Future<void> _delete(Tag tag) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir tag'),
        content: Text('Deseja excluir "${tag.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await _tagService.delete(tag);
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const TopBar(screenName: 'Tags'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: FloatingCard(
                  child: Column(
                    children: [
                      Expanded(
                        child: FutureBuilder<List<Tag>>(
                          future: _future,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState !=
                                ConnectionState.done) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            final tags = snapshot.data ?? const <Tag>[];
                            return ListView.separated(
                              padding: const EdgeInsets.only(top: 12),
                              itemCount: tags.length,
                              separatorBuilder: (_, _) => const Divider(
                                height: 1,
                                indent: 64,
                                endIndent: 16,
                              ),
                              itemBuilder: (context, index) {
                                final tag = tags[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        tag.color.withValues(alpha: 0.2),
                                    child: Icon(
                                      Icons.label_outline,
                                      color: tag.color,
                                    ),
                                  ),
                                  title: Text(tag.title),
                                  subtitle: Text(
                                    tag.isDefault
                                        ? 'Padrao bloqueada'
                                        : 'Personalizada',
                                  ),
                                  trailing: tag.isDefault
                                      ? const Icon(Icons.lock_outline)
                                      : Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit_outlined,
                                              ),
                                              onPressed: () async {
                                                await Navigator.pushNamed(
                                                  context,
                                                  '/tags/form',
                                                  arguments: tag,
                                                );
                                                _reload();
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete_outline,
                                              ),
                                              onPressed: () => _delete(tag),
                                            ),
                                          ],
                                        ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: GestureDetector(
                          onTap: () async {
                            await Navigator.pushNamed(context, '/tags/form');
                            _reload();
                          },
                          child: Container(
                            height: w * 0.14,
                            decoration: BoxDecoration(
                              color: const Color(0xFF9C27B0),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_rounded, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Adicionar Tag',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
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
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 3),
    );
  }
}

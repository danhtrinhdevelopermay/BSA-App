import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_theme.dart';
import '../../providers/app_provider.dart';
import '../../providers/study_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppProvider, StudyProvider>(
      builder: (context, appProvider, studyProvider, child) {
        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          appBar: AppBar(
            title: Text(appProvider.t('notes')),
            backgroundColor: AppTheme.backgroundColor,
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(appProvider.t('coming_soon'))),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  _showCreateNoteDialog(context, appProvider, studyProvider);
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => studyProvider.loadNotes(),
            child: studyProvider.notesLoading
                ? const Center(child: CircularProgressIndicator())
                : studyProvider.notes.isEmpty
                    ? _buildEmptyState(context, appProvider)
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: studyProvider.notes.length,
                        itemBuilder: (context, index) {
                          final note = studyProvider.notes[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.left(
                                color: note.isPinned ? AppTheme.accentColor : AppTheme.primaryColor,
                                width: 4,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        note.title,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    if (note.isPinned)
                                      Icon(
                                        Icons.push_pin,
                                        size: 16,
                                        color: AppTheme.accentColor,
                                      ),
                                    PopupMenuButton(
                                      icon: Icon(
                                        Icons.more_vert,
                                        color: AppTheme.textSecondaryColor,
                                      ),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          child: Text(appProvider.t('edit')),
                                          onTap: () {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(appProvider.t('coming_soon')),
                                              ),
                                            );
                                          },
                                        ),
                                        PopupMenuItem(
                                          child: Text(appProvider.t('delete')),
                                          onTap: () async {
                                            final success = await studyProvider.deleteNote(note.id);
                                            if (context.mounted && success) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Xóa ghi chú thành công')),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  note.content,
                                  style: TextStyle(
                                    color: AppTheme.textSecondaryColor,
                                    fontSize: 14,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (note.tags.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    children: note.tags.map((tag) => 
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppTheme.primaryColor.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          '#$tag',
                                          style: TextStyle(
                                            color: AppTheme.primaryColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ).toList(),
                                  ),
                                ],
                                const SizedBox(height: 8),
                                Text(
                                  'Cập nhật: ${_formatDate(note.updatedAt)}',
                                  style: TextStyle(
                                    color: AppTheme.textSecondaryColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, AppProvider appProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note,
            size: 80,
            color: AppTheme.textSecondaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có ghi chú nào',
            style: TextStyle(
              fontSize: 18,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tạo ghi chú để lưu trữ kiến thức',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 32),
          CustomButton(
            text: appProvider.t('create_note'),
            onPressed: () {
              _showCreateNoteDialog(context, appProvider, context.read<StudyProvider>());
            },
            icon: Icons.add,
            width: 200,
          ),
        ],
      ),
    );
  }

  void _showCreateNoteDialog(BuildContext context, AppProvider appProvider, StudyProvider studyProvider) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: Text(appProvider.t('create_note')),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: titleController,
                label: appProvider.t('note_title'),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: contentController,
                label: appProvider.t('note_content'),
                maxLines: 5,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(appProvider.t('cancel')),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                final success = await studyProvider.createNote(
                  titleController.text,
                  contentController.text,
                );
                if (context.mounted) {
                  Navigator.pop(context);
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tạo ghi chú thành công')),
                    );
                  }
                }
              }
            },
            child: Text(appProvider.t('create')),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
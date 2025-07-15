import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_theme.dart';
import '../../providers/app_provider.dart';
import '../../providers/study_provider.dart';
import '../../widgets/custom_button.dart';

class FlashcardsScreen extends StatelessWidget {
  const FlashcardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppProvider, StudyProvider>(
      builder: (context, appProvider, studyProvider, child) {
        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          appBar: AppBar(
            title: Text(appProvider.t('flashcards')),
            backgroundColor: AppTheme.backgroundColor,
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  _showCreateDeckDialog(context, appProvider, studyProvider);
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => studyProvider.loadFlashcardDecks(),
            child: studyProvider.flashcardsLoading
                ? const Center(child: CircularProgressIndicator())
                : studyProvider.flashcardDecks.isEmpty
                    ? _buildEmptyState(context, appProvider)
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: studyProvider.flashcardDecks.length,
                        itemBuilder: (context, index) {
                          final deck = studyProvider.flashcardDecks[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.left(
                                color: AppTheme.primaryColor,
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
                                        deck.title,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        '${deck.flashcardCount} thẻ',
                                        style: TextStyle(
                                          color: AppTheme.primaryColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (deck.description != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    deck.description!,
                                    style: TextStyle(
                                      color: AppTheme.textSecondaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomButton(
                                        text: appProvider.t('study_now'),
                                        onPressed: () {
                                          // TODO: Navigate to study session
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(appProvider.t('coming_soon')),
                                            ),
                                          );
                                        },
                                        height: 40,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: CustomButton(
                                        text: 'Quản lý',
                                        onPressed: () {
                                          // TODO: Navigate to manage deck
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(appProvider.t('coming_soon')),
                                            ),
                                          );
                                        },
                                        isOutlined: true,
                                        height: 40,
                                      ),
                                    ),
                                  ],
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
            Icons.credit_card,
            size: 80,
            color: AppTheme.textSecondaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có bộ thẻ nào',
            style: TextStyle(
              fontSize: 18,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tạo bộ thẻ đầu tiên để bắt đầu học',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 32),
          CustomButton(
            text: appProvider.t('create_deck'),
            onPressed: () {
              _showCreateDeckDialog(context, appProvider, context.read<StudyProvider>());
            },
            icon: Icons.add,
            width: 200,
          ),
        ],
      ),
    );
  }

  void _showCreateDeckDialog(BuildContext context, AppProvider appProvider, StudyProvider studyProvider) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: Text(appProvider.t('create_deck')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: appProvider.t('deck_title'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: appProvider.t('deck_description'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(appProvider.t('cancel')),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty) {
                final success = await studyProvider.createFlashcardDeck(
                  titleController.text,
                  descriptionController.text.isEmpty ? null : descriptionController.text,
                );
                if (context.mounted) {
                  Navigator.pop(context);
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Tạo bộ thẻ thành công')),
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
}
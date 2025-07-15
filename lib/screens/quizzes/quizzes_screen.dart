import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_theme.dart';
import '../../providers/app_provider.dart';
import '../../providers/study_provider.dart';
import '../../widgets/custom_button.dart';

class QuizzesScreen extends StatelessWidget {
  const QuizzesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppProvider, StudyProvider>(
      builder: (context, appProvider, studyProvider, child) {
        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          appBar: AppBar(
            title: Text(appProvider.t('quizzes')),
            backgroundColor: AppTheme.backgroundColor,
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(appProvider.t('coming_soon'))),
                  );
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => studyProvider.loadQuizzes(),
            child: studyProvider.quizzesLoading
                ? const Center(child: CircularProgressIndicator())
                : studyProvider.quizzes.isEmpty
                    ? _buildEmptyState(context, appProvider)
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: studyProvider.quizzes.length,
                        itemBuilder: (context, index) {
                          final quiz = studyProvider.quizzes[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.left(
                                color: AppTheme.secondaryColor,
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
                                        quiz.title,
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
                                        color: AppTheme.secondaryColor.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        '${quiz.questions.length} câu hỏi',
                                        style: TextStyle(
                                          color: AppTheme.secondaryColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (quiz.description != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    quiz.description!,
                                    style: TextStyle(
                                      color: AppTheme.textSecondaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.timer,
                                      size: 16,
                                      color: AppTheme.textSecondaryColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${quiz.timeLimit} phút',
                                      style: TextStyle(
                                        color: AppTheme.textSecondaryColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Icon(
                                      Icons.star,
                                      size: 16,
                                      color: AppTheme.textSecondaryColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Mức độ ${quiz.difficulty}',
                                      style: TextStyle(
                                        color: AppTheme.textSecondaryColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomButton(
                                        text: appProvider.t('start_quiz'),
                                        onPressed: () {
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
                                        text: 'Lịch sử',
                                        onPressed: () {
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
            Icons.quiz,
            size: 80,
            color: AppTheme.textSecondaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có bài kiểm tra nào',
            style: TextStyle(
              fontSize: 18,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tạo bài kiểm tra để đánh giá kiến thức',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 32),
          CustomButton(
            text: appProvider.t('create_quiz'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(appProvider.t('coming_soon'))),
              );
            },
            icon: Icons.add,
            width: 200,
          ),
        ],
      ),
    );
  }
}
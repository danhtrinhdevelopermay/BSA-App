import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_theme.dart';
import '../../providers/app_provider.dart';
import '../../providers/study_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../models/assignment_model.dart';

class AssignmentsScreen extends StatelessWidget {
  const AssignmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppProvider, StudyProvider>(
      builder: (context, appProvider, studyProvider, child) {
        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          appBar: AppBar(
            title: Text(appProvider.t('assignments')),
            backgroundColor: AppTheme.backgroundColor,
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(appProvider.t('coming_soon'))),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  _showCreateAssignmentDialog(context, appProvider, studyProvider);
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => studyProvider.loadAssignments(),
            child: studyProvider.assignmentsLoading
                ? const Center(child: CircularProgressIndicator())
                : studyProvider.assignments.isEmpty
                    ? _buildEmptyState(context, appProvider)
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: studyProvider.assignments.length,
                        itemBuilder: (context, index) {
                          final assignment = studyProvider.assignments[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.left(
                                color: _getPriorityColor(assignment.priority),
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
                                        assignment.title,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          decoration: assignment.status == AssignmentStatus.completed
                                              ? TextDecoration.lineThrough
                                              : null,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(assignment.status).withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        assignment.status.displayName,
                                        style: TextStyle(
                                          color: _getStatusColor(assignment.status),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (assignment.description != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    assignment.description!,
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
                                      assignment.isOverdue ? Icons.warning : Icons.schedule,
                                      size: 16,
                                      color: assignment.isOverdue ? Colors.red : AppTheme.textSecondaryColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      assignment.isOverdue ? 'Quá hạn' : assignment.timeUntilDue,
                                      style: TextStyle(
                                        color: assignment.isOverdue ? Colors.red : AppTheme.textSecondaryColor,
                                        fontSize: 12,
                                        fontWeight: assignment.isOverdue ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Icon(
                                      Icons.priority_high,
                                      size: 16,
                                      color: _getPriorityColor(assignment.priority),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      assignment.priority.displayName,
                                      style: TextStyle(
                                        color: _getPriorityColor(assignment.priority),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    if (assignment.status != AssignmentStatus.completed)
                                      Expanded(
                                        child: CustomButton(
                                          text: appProvider.t('mark_complete'),
                                          onPressed: () async {
                                            final success = await studyProvider.updateAssignment(
                                              assignment.id,
                                              {'status': AssignmentStatus.completed.name},
                                            );
                                            if (context.mounted && success) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Đánh dấu hoàn thành')),
                                              );
                                            }
                                          },
                                          height: 40,
                                        ),
                                      )
                                    else
                                      Expanded(
                                        child: CustomButton(
                                          text: appProvider.t('mark_incomplete'),
                                          onPressed: () async {
                                            final success = await studyProvider.updateAssignment(
                                              assignment.id,
                                              {'status': AssignmentStatus.pending.name},
                                            );
                                            if (context.mounted && success) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Đánh dấu chưa hoàn thành')),
                                              );
                                            }
                                          },
                                          isOutlined: true,
                                          height: 40,
                                        ),
                                      ),
                                    const SizedBox(width: 12),
                                    CustomButton(
                                      text: appProvider.t('delete'),
                                      onPressed: () async {
                                        final success = await studyProvider.deleteAssignment(assignment.id);
                                        if (context.mounted && success) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Xóa bài tập thành công')),
                                          );
                                        }
                                      },
                                      backgroundColor: Colors.red,
                                      width: 80,
                                      height: 40,
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
            Icons.assignment,
            size: 80,
            color: AppTheme.textSecondaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có bài tập nào',
            style: TextStyle(
              fontSize: 18,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tạo bài tập để quản lý công việc học tập',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 32),
          CustomButton(
            text: appProvider.t('create_assignment'),
            onPressed: () {
              _showCreateAssignmentDialog(context, appProvider, context.read<StudyProvider>());
            },
            icon: Icons.add,
            width: 200,
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(AssignmentPriority priority) {
    switch (priority) {
      case AssignmentPriority.low:
        return Colors.green;
      case AssignmentPriority.medium:
        return Colors.orange;
      case AssignmentPriority.high:
        return Colors.red;
      case AssignmentPriority.urgent:
        return Colors.purple;
    }
  }

  Color _getStatusColor(AssignmentStatus status) {
    switch (status) {
      case AssignmentStatus.pending:
        return Colors.grey;
      case AssignmentStatus.inProgress:
        return Colors.blue;
      case AssignmentStatus.completed:
        return Colors.green;
      case AssignmentStatus.cancelled:
        return Colors.red;
    }
  }

  void _showCreateAssignmentDialog(BuildContext context, AppProvider appProvider, StudyProvider studyProvider) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    AssignmentPriority selectedPriority = AssignmentPriority.medium;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: AppTheme.cardColor,
          title: Text(appProvider.t('create_assignment')),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  controller: titleController,
                  label: appProvider.t('assignment_title'),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: descriptionController,
                  label: appProvider.t('assignment_description'),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (date != null) {
                            setState(() {
                              selectedDate = date;
                            });
                          }
                        },
                        child: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButton<AssignmentPriority>(
                        value: selectedPriority,
                        onChanged: (value) {
                          setState(() {
                            selectedPriority = value!;
                          });
                        },
                        items: AssignmentPriority.values.map((priority) => 
                          DropdownMenuItem(
                            value: priority,
                            child: Text(priority.displayName),
                          ),
                        ).toList(),
                      ),
                    ),
                  ],
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
                if (titleController.text.isNotEmpty) {
                  final success = await studyProvider.createAssignment(
                    titleController.text,
                    selectedDate,
                    description: descriptionController.text.isEmpty ? null : descriptionController.text,
                    priority: selectedPriority.name,
                  );
                  if (context.mounted) {
                    Navigator.pop(context);
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tạo bài tập thành công')),
                      );
                    }
                  }
                }
              },
              child: Text(appProvider.t('create')),
            ),
          ],
        ),
      ),
    );
  }
}
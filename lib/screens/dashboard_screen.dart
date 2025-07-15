import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_theme.dart';
import '../providers/app_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/study_provider.dart';
import '../widgets/custom_button.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<AppProvider, AuthProvider, StudyProvider>(
      builder: (context, appProvider, authProvider, studyProvider, child) {
        final user = authProvider.user;
        final userStats = authProvider.getUserStats();
        final upcomingAssignments = studyProvider.getUpcomingAssignments();

        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          appBar: AppBar(
            title: Text(appProvider.t('dashboard')),
            backgroundColor: AppTheme.backgroundColor,
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  // TODO: Navigate to notifications
                },
              ),
              PopupMenuButton(
                icon: CircleAvatar(
                  backgroundImage: user?.avatar != null
                      ? NetworkImage(user!.avatar!)
                      : null,
                  child: user?.avatar == null
                      ? Text(user?.username.substring(0, 1).toUpperCase() ?? 'U')
                      : null,
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text(appProvider.t('profile')),
                    onTap: () {
                      // TODO: Navigate to profile
                    },
                  ),
                  PopupMenuItem(
                    child: Text(appProvider.t('settings')),
                    onTap: () {
                      // TODO: Navigate to settings
                    },
                  ),
                  PopupMenuItem(
                    child: Text(appProvider.t('logout')),
                    onTap: () async {
                      await authProvider.logout();
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(context, '/login');
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await studyProvider.loadDashboardData();
              await authProvider.init();
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryColor.withOpacity(0.8),
                          AppTheme.secondaryColor.withOpacity(0.6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${appProvider.t('welcome_back')}, ${user?.displayName ?? user?.username ?? ''}!',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          appProvider.t('study_progress'),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Stats cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          appProvider.t('level'),
                          '${userStats['level'] ?? 1}',
                          Icons.star,
                          AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          appProvider.t('total_xp'),
                          '${userStats['xp'] ?? 0}',
                          Icons.emoji_events,
                          AppTheme.secondaryColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          appProvider.t('study_streak'),
                          '${studyProvider.dashboardData['studyStreak'] ?? 0}',
                          Icons.local_fire_department,
                          AppTheme.accentColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          appProvider.t('completed_today'),
                          '${studyProvider.dashboardData['completedToday'] ?? 0}',
                          Icons.check_circle,
                          Colors.green,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Quick actions
                  Text(
                    'Hành động nhanh',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickActionCard(
                          context,
                          appProvider.t('study_now'),
                          Icons.play_arrow,
                          AppTheme.primaryColor,
                          () {
                            // TODO: Navigate to study session
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildQuickActionCard(
                          context,
                          appProvider.t('create_note'),
                          Icons.note_add,
                          AppTheme.secondaryColor,
                          () {
                            // TODO: Navigate to create note
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Upcoming assignments
                  Text(
                    appProvider.t('upcoming_assignments'),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  if (upcomingAssignments.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.assignment_turned_in,
                            size: 48,
                            color: AppTheme.textSecondaryColor,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Không có bài tập sắp tới',
                            style: TextStyle(
                              color: AppTheme.textSecondaryColor,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...upcomingAssignments.take(3).map((assignment) => 
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.left(
                            color: assignment.priority == assignment.priority
                                ? Colors.red
                                : AppTheme.primaryColor,
                            width: 4,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    assignment.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Hạn: ${assignment.timeUntilDue}',
                                    style: TextStyle(
                                      color: AppTheme.textSecondaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: AppTheme.textSecondaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Recent activity
                  Text(
                    appProvider.t('recent_activity'),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.history,
                          size: 48,
                          color: AppTheme.textSecondaryColor,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          appProvider.t('coming_soon'),
                          style: TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, 
      IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(BuildContext context, String title, IconData icon, 
      Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
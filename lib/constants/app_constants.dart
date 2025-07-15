// App constants cho Bright Starts Academy
class AppConstants {
  // App Info
  static const String appName = 'BSA';
  static const String appFullName = 'Bright Starts Academy';
  static const String version = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'https://brightstarts.onrender.com';
  static const String apiUrl = '$baseUrl/api';
  
  // Colors
  static const int primaryColor = 0xFF6366F1;
  static const int secondaryColor = 0xFF8B5CF6;
  static const int accentColor = 0xFFEC4899;
  static const int backgroundColor = 0xFF0F172A;
  static const int cardColor = 0xFF1E293B;
  static const int textColor = 0xFFFFFFFF;
  static const int textSecondaryColor = 0xFF94A3B8;
  
  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  
  // Font Sizes
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeXLarge = 18.0;
  static const double fontSizeXXLarge = 24.0;
  
  // Animation Duration
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration animationDurationLong = Duration(milliseconds: 500);
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userIdKey = 'user_id';
  static const String languageKey = 'language';
  static const String themeKey = 'theme';
  
  // Languages
  static const String vietnamese = 'vi';
  static const String english = 'en';
  
  // Routes
  static const String homeRoute = '/';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String dashboardRoute = '/dashboard';
  static const String flashcardsRoute = '/flashcards';
  static const String quizzesRoute = '/quizzes';
  static const String notesRoute = '/notes';
  static const String assignmentsRoute = '/assignments';
  static const String studyGroupsRoute = '/study-groups';
  static const String profileRoute = '/profile';
  static const String settingsRoute = '/settings';
  static const String chatRoute = '/chat';
  
  // Achievement Types
  static const String achievementFlashcards = 'flashcards';
  static const String achievementQuizzes = 'quizzes';
  static const String achievementStudyStreak = 'study_streak';
  static const String achievementXpMilestone = 'xp_milestone';
  
  // Study Tools
  static const int maxFlashcardsPerDeck = 100;
  static const int maxQuizQuestions = 50;
  static const int studyStreakGoal = 7;
  static const int xpPerCorrectAnswer = 10;
  static const int xpPerCompletedQuiz = 50;
  static const int xpPerCreatedFlashcard = 5;
}
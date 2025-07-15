import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_theme.dart';
import '../providers/app_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/study_provider.dart';
import 'dashboard_screen.dart';
import 'flashcards/flashcards_screen.dart';
import 'quizzes/quizzes_screen.dart';
import 'notes/notes_screen.dart';
import 'assignments/assignments_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late PageController _pageController;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const FlashcardsScreen(),
    const QuizzesScreen(),
    const NotesScreen(),
    const AssignmentsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadInitialData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    final studyProvider = context.read<StudyProvider>();
    
    // Load initial data
    await Future.wait([
      studyProvider.loadDashboardData(),
      studyProvider.loadFlashcardDecks(),
      studyProvider.loadQuizzes(),
      studyProvider.loadNotes(),
      studyProvider.loadAssignments(),
    ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            children: _screens,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,
              backgroundColor: AppTheme.cardColor,
              selectedItemColor: AppTheme.primaryColor,
              unselectedItemColor: AppTheme.textSecondaryColor,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.dashboard),
                  label: appProvider.t('dashboard'),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.credit_card),
                  label: appProvider.t('flashcards'),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.quiz),
                  label: appProvider.t('quizzes'),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.note),
                  label: appProvider.t('notes'),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.assignment),
                  label: appProvider.t('assignments'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
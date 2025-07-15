import 'package:flutter/foundation.dart';
import '../models/flashcard_model.dart';
import '../models/quiz_model.dart';
import '../models/note_model.dart';
import '../models/assignment_model.dart';
import '../services/api_service.dart';

// Study Provider for managing study-related data
class StudyProvider with ChangeNotifier {
  // Flashcards
  List<FlashcardDeck> _flashcardDecks = [];
  List<Flashcard> _currentFlashcards = [];
  bool _flashcardsLoading = false;
  
  // Quizzes
  List<Quiz> _quizzes = [];
  List<QuizAttempt> _quizAttempts = [];
  bool _quizzesLoading = false;
  
  // Notes
  List<Note> _notes = [];
  bool _notesLoading = false;
  
  // Assignments
  List<Assignment> _assignments = [];
  bool _assignmentsLoading = false;
  
  // General
  String? _error;
  Map<String, dynamic> _dashboardData = {};

  // Getters
  List<FlashcardDeck> get flashcardDecks => _flashcardDecks;
  List<Flashcard> get currentFlashcards => _currentFlashcards;
  bool get flashcardsLoading => _flashcardsLoading;
  
  List<Quiz> get quizzes => _quizzes;
  List<QuizAttempt> get quizAttempts => _quizAttempts;
  bool get quizzesLoading => _quizzesLoading;
  
  List<Note> get notes => _notes;
  bool get notesLoading => _notesLoading;
  
  List<Assignment> get assignments => _assignments;
  bool get assignmentsLoading => _assignmentsLoading;
  
  String? get error => _error;
  Map<String, dynamic> get dashboardData => _dashboardData;

  // ==== FLASHCARDS ====
  
  // Load flashcard decks
  Future<void> loadFlashcardDecks() async {
    _flashcardsLoading = true;
    _error = null;
    notifyListeners();

    try {
      _flashcardDecks = await ApiService.getFlashcardDecks();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _flashcardsLoading = false;
      notifyListeners();
    }
  }

  // Create flashcard deck
  Future<bool> createFlashcardDeck(String title, String? description) async {
    try {
      final deck = await ApiService.createFlashcardDeck(title, description);
      _flashcardDecks.add(deck);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Load flashcards for a deck
  Future<void> loadFlashcards(int deckId) async {
    _flashcardsLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentFlashcards = await ApiService.getFlashcards(deckId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _flashcardsLoading = false;
      notifyListeners();
    }
  }

  // Create flashcard
  Future<bool> createFlashcard(int deckId, String front, String back, String? hint) async {
    try {
      final flashcard = await ApiService.createFlashcard(deckId, front, back, hint);
      _currentFlashcards.add(flashcard);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Delete flashcard
  Future<bool> deleteFlashcard(int flashcardId) async {
    try {
      await ApiService.deleteFlashcard(flashcardId);
      _currentFlashcards.removeWhere((card) => card.id == flashcardId);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ==== QUIZZES ====
  
  // Load quizzes
  Future<void> loadQuizzes() async {
    _quizzesLoading = true;
    _error = null;
    notifyListeners();

    try {
      _quizzes = await ApiService.getQuizzes();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _quizzesLoading = false;
      notifyListeners();
    }
  }

  // Create quiz
  Future<bool> createQuiz(String title, String? description, List<Map<String, dynamic>> questions) async {
    try {
      final quiz = await ApiService.createQuiz(title, description, questions);
      _quizzes.add(quiz);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Submit quiz attempt
  Future<QuizAttempt?> submitQuizAttempt(int quizId, List<Map<String, dynamic>> answers) async {
    try {
      final attempt = await ApiService.submitQuizAttempt(quizId, answers);
      _quizAttempts.add(attempt);
      notifyListeners();
      return attempt;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Load quiz attempts
  Future<void> loadQuizAttempts([int? quizId]) async {
    try {
      _quizAttempts = await ApiService.getQuizAttempts(quizId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // ==== NOTES ====
  
  // Load notes
  Future<void> loadNotes() async {
    _notesLoading = true;
    _error = null;
    notifyListeners();

    try {
      _notes = await ApiService.getNotes();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _notesLoading = false;
      notifyListeners();
    }
  }

  // Create note
  Future<bool> createNote(String title, String content, {List<String>? tags, String? category}) async {
    try {
      final note = await ApiService.createNote(title, content, tags: tags, category: category);
      _notes.add(note);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Update note
  Future<bool> updateNote(int noteId, Map<String, dynamic> updates) async {
    try {
      final updatedNote = await ApiService.updateNote(noteId, updates);
      final index = _notes.indexWhere((note) => note.id == noteId);
      if (index != -1) {
        _notes[index] = updatedNote;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Delete note
  Future<bool> deleteNote(int noteId) async {
    try {
      await ApiService.deleteNote(noteId);
      _notes.removeWhere((note) => note.id == noteId);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ==== ASSIGNMENTS ====
  
  // Load assignments
  Future<void> loadAssignments() async {
    _assignmentsLoading = true;
    _error = null;
    notifyListeners();

    try {
      _assignments = await ApiService.getAssignments();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _assignmentsLoading = false;
      notifyListeners();
    }
  }

  // Create assignment
  Future<bool> createAssignment(String title, DateTime dueDate, 
      {String? description, String? priority, String? subject}) async {
    try {
      final assignment = await ApiService.createAssignment(
        title, dueDate, 
        description: description, 
        priority: priority, 
        subject: subject
      );
      _assignments.add(assignment);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Update assignment
  Future<bool> updateAssignment(int assignmentId, Map<String, dynamic> updates) async {
    try {
      final updatedAssignment = await ApiService.updateAssignment(assignmentId, updates);
      final index = _assignments.indexWhere((assignment) => assignment.id == assignmentId);
      if (index != -1) {
        _assignments[index] = updatedAssignment;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Delete assignment
  Future<bool> deleteAssignment(int assignmentId) async {
    try {
      await ApiService.deleteAssignment(assignmentId);
      _assignments.removeWhere((assignment) => assignment.id == assignmentId);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ==== DASHBOARD ====
  
  // Load dashboard data
  Future<void> loadDashboardData() async {
    try {
      _dashboardData = await ApiService.getDashboardData();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // ==== UTILITY METHODS ====
  
  // Get upcoming assignments
  List<Assignment> getUpcomingAssignments() {
    final now = DateTime.now();
    return _assignments
        .where((assignment) => 
            assignment.status != AssignmentStatus.completed && 
            assignment.dueDate.isAfter(now))
        .toList()
        ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  // Get overdue assignments
  List<Assignment> getOverdueAssignments() {
    return _assignments
        .where((assignment) => assignment.isOverdue)
        .toList()
        ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  // Get notes by category
  List<Note> getNotesByCategory(String category) {
    return _notes.where((note) => note.category == category).toList();
  }

  // Search notes
  List<Note> searchNotes(String query) {
    final lowerQuery = query.toLowerCase();
    return _notes.where((note) => 
        note.title.toLowerCase().contains(lowerQuery) ||
        note.content.toLowerCase().contains(lowerQuery) ||
        note.tags.any((tag) => tag.toLowerCase().contains(lowerQuery))
    ).toList();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
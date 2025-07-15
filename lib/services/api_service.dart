import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../models/user_model.dart';
import '../models/flashcard_model.dart';
import '../models/quiz_model.dart';
import '../models/note_model.dart';
import '../models/assignment_model.dart';

// API Service for Bright Starts Academy
class ApiService {
  static const String baseUrl = AppConstants.apiUrl;
  static const Duration timeout = Duration(seconds: 30);

  // Get auth token
  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.userTokenKey);
  }

  // Helper method to build headers
  static Future<Map<String, String>> _buildHeaders() async {
    final token = await getAuthToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Generic GET request
  static Future<http.Response> get(String endpoint) async {
    final headers = await _buildHeaders();
    final uri = Uri.parse('$baseUrl$endpoint');
    
    try {
      final response = await http.get(uri, headers: headers).timeout(timeout);
      return response;
    } catch (e) {
      throw Exception('Lỗi kết nối mạng: $e');
    }
  }

  // Generic POST request
  static Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    final headers = await _buildHeaders();
    final uri = Uri.parse('$baseUrl$endpoint');
    
    try {
      final response = await http.post(
        uri,
        headers: headers,
        body: json.encode(data),
      ).timeout(timeout);
      return response;
    } catch (e) {
      throw Exception('Lỗi kết nối mạng: $e');
    }
  }

  // Generic PUT request
  static Future<http.Response> put(String endpoint, Map<String, dynamic> data) async {
    final headers = await _buildHeaders();
    final uri = Uri.parse('$baseUrl$endpoint');
    
    try {
      final response = await http.put(
        uri,
        headers: headers,
        body: json.encode(data),
      ).timeout(timeout);
      return response;
    } catch (e) {
      throw Exception('Lỗi kết nối mạng: $e');
    }
  }

  // Generic DELETE request
  static Future<http.Response> delete(String endpoint) async {
    final headers = await _buildHeaders();
    final uri = Uri.parse('$baseUrl$endpoint');
    
    try {
      final response = await http.delete(uri, headers: headers).timeout(timeout);
      return response;
    } catch (e) {
      throw Exception('Lỗi kết nối mạng: $e');
    }
  }

  // Handle API response
  static dynamic handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isNotEmpty) {
        return json.decode(response.body);
      }
      return null;
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Có lỗi xảy ra');
    }
  }

  // ==== Auth API ====
  static Future<User> login(String email, String password) async {
    final response = await post('/auth/login', {
      'email': email,
      'password': password,
    });
    
    final data = handleResponse(response);
    
    // Save auth token
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.userTokenKey, data['token']);
    await prefs.setInt(AppConstants.userIdKey, data['user']['id']);
    
    return User.fromJson(data['user']);
  }

  static Future<User> register(String username, String email, String password) async {
    final response = await post('/auth/register', {
      'username': username,
      'email': email,
      'password': password,
    });
    
    final data = handleResponse(response);
    
    // Save auth token
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.userTokenKey, data['token']);
    await prefs.setInt(AppConstants.userIdKey, data['user']['id']);
    
    return User.fromJson(data['user']);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.userTokenKey);
    await prefs.remove(AppConstants.userIdKey);
  }

  // ==== User API ====
  static Future<User> getCurrentUser() async {
    final response = await get('/users/me');
    final data = handleResponse(response);
    return User.fromJson(data);
  }

  static Future<User> updateUser(Map<String, dynamic> updates) async {
    final response = await put('/users/me', updates);
    final data = handleResponse(response);
    return User.fromJson(data);
  }

  // ==== Flashcards API ====
  static Future<List<FlashcardDeck>> getFlashcardDecks() async {
    final response = await get('/flashcards/decks');
    final data = handleResponse(response);
    return (data as List).map((deck) => FlashcardDeck.fromJson(deck)).toList();
  }

  static Future<FlashcardDeck> createFlashcardDeck(String title, String? description) async {
    final response = await post('/flashcards/decks', {
      'title': title,
      'description': description,
    });
    final data = handleResponse(response);
    return FlashcardDeck.fromJson(data);
  }

  static Future<List<Flashcard>> getFlashcards(int deckId) async {
    final response = await get('/flashcards/decks/$deckId/cards');
    final data = handleResponse(response);
    return (data as List).map((card) => Flashcard.fromJson(card)).toList();
  }

  static Future<Flashcard> createFlashcard(int deckId, String front, String back, String? hint) async {
    final response = await post('/flashcards/decks/$deckId/cards', {
      'front': front,
      'back': back,
      'hint': hint,
    });
    final data = handleResponse(response);
    return Flashcard.fromJson(data);
  }

  static Future<void> deleteFlashcard(int flashcardId) async {
    await delete('/flashcards/cards/$flashcardId');
  }

  // ==== Quizzes API ====
  static Future<List<Quiz>> getQuizzes() async {
    final response = await get('/quizzes');
    final data = handleResponse(response);
    return (data as List).map((quiz) => Quiz.fromJson(quiz)).toList();
  }

  static Future<Quiz> createQuiz(String title, String? description, List<Map<String, dynamic>> questions) async {
    final response = await post('/quizzes', {
      'title': title,
      'description': description,
      'questions': questions,
    });
    final data = handleResponse(response);
    return Quiz.fromJson(data);
  }

  static Future<QuizAttempt> submitQuizAttempt(int quizId, List<Map<String, dynamic>> answers) async {
    final response = await post('/quizzes/$quizId/attempts', {
      'answers': answers,
    });
    final data = handleResponse(response);
    return QuizAttempt.fromJson(data);
  }

  static Future<List<QuizAttempt>> getQuizAttempts(int? quizId) async {
    final endpoint = quizId != null ? '/quizzes/$quizId/attempts' : '/quizzes/attempts';
    final response = await get(endpoint);
    final data = handleResponse(response);
    return (data as List).map((attempt) => QuizAttempt.fromJson(attempt)).toList();
  }

  // ==== Notes API ====
  static Future<List<Note>> getNotes() async {
    final response = await get('/notes');
    final data = handleResponse(response);
    return (data as List).map((note) => Note.fromJson(note)).toList();
  }

  static Future<Note> createNote(String title, String content, {List<String>? tags, String? category}) async {
    final response = await post('/notes', {
      'title': title,
      'content': content,
      'tags': tags ?? [],
      'category': category,
    });
    final data = handleResponse(response);
    return Note.fromJson(data);
  }

  static Future<Note> updateNote(int noteId, Map<String, dynamic> updates) async {
    final response = await put('/notes/$noteId', updates);
    final data = handleResponse(response);
    return Note.fromJson(data);
  }

  static Future<void> deleteNote(int noteId) async {
    await delete('/notes/$noteId');
  }

  // ==== Assignments API ====
  static Future<List<Assignment>> getAssignments() async {
    final response = await get('/assignments');
    final data = handleResponse(response);
    return (data as List).map((assignment) => Assignment.fromJson(assignment)).toList();
  }

  static Future<Assignment> createAssignment(String title, DateTime dueDate, 
      {String? description, String? priority, String? subject}) async {
    final response = await post('/assignments', {
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority ?? 'medium',
      'subject': subject,
    });
    final data = handleResponse(response);
    return Assignment.fromJson(data);
  }

  static Future<Assignment> updateAssignment(int assignmentId, Map<String, dynamic> updates) async {
    final response = await put('/assignments/$assignmentId', updates);
    final data = handleResponse(response);
    return Assignment.fromJson(data);
  }

  static Future<void> deleteAssignment(int assignmentId) async {
    await delete('/assignments/$assignmentId');
  }

  // ==== Posts API ====
  static Future<List<Map<String, dynamic>>> getPosts() async {
    final response = await get('/posts');
    final data = handleResponse(response);
    return List<Map<String, dynamic>>.from(data);
  }

  static Future<Map<String, dynamic>> createPost(String content, List<Map<String, dynamic>>? mediaUrls) async {
    final response = await post('/posts', {
      'content': content,
      'mediaUrls': mediaUrls ?? [],
    });
    final data = handleResponse(response);
    return data;
  }

  static Future<void> likePost(int postId) async {
    await post('/posts/$postId/like', {});
  }

  static Future<void> unlikePost(int postId) async {
    await delete('/posts/$postId/like');
  }

  // ==== Dashboard API ====
  static Future<Map<String, dynamic>> getDashboardData() async {
    final response = await get('/dashboard');
    final data = handleResponse(response);
    return data;
  }
}
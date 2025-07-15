// Quiz models for Bright Starts Academy
class Quiz {
  final int id;
  final String title;
  final String? description;
  final int userId;
  final List<QuizQuestion> questions;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPublic;
  final int timeLimit; // in minutes
  final String? category;
  final int difficulty; // 1-5 scale

  Quiz({
    required this.id,
    required this.title,
    this.description,
    required this.userId,
    required this.questions,
    required this.createdAt,
    required this.updatedAt,
    this.isPublic = false,
    this.timeLimit = 30,
    this.category,
    this.difficulty = 1,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      userId: json['userId'],
      questions: (json['questions'] as List<dynamic>?)
          ?.map((q) => QuizQuestion.fromJson(q))
          .toList() ?? [],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isPublic: json['isPublic'] ?? false,
      timeLimit: json['timeLimit'] ?? 30,
      category: json['category'],
      difficulty: json['difficulty'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'userId': userId,
      'questions': questions.map((q) => q.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isPublic': isPublic,
      'timeLimit': timeLimit,
      'category': category,
      'difficulty': difficulty,
    };
  }
}

class QuizQuestion {
  final int id;
  final int quizId;
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String? explanation;
  final int points;

  QuizQuestion({
    required this.id,
    required this.quizId,
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.explanation,
    this.points = 10,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'],
      quizId: json['quizId'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correctAnswer'],
      explanation: json['explanation'],
      points: json['points'] ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quizId': quizId,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'points': points,
    };
  }
}

class QuizAttempt {
  final int id;
  final int quizId;
  final int userId;
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final DateTime completedAt;
  final int timeSpent; // in seconds
  final List<QuizAnswer> answers;

  QuizAttempt({
    required this.id,
    required this.quizId,
    required this.userId,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.completedAt,
    required this.timeSpent,
    required this.answers,
  });

  factory QuizAttempt.fromJson(Map<String, dynamic> json) {
    return QuizAttempt(
      id: json['id'],
      quizId: json['quizId'],
      userId: json['userId'],
      score: json['score'],
      totalQuestions: json['totalQuestions'],
      correctAnswers: json['correctAnswers'],
      completedAt: DateTime.parse(json['completedAt']),
      timeSpent: json['timeSpent'],
      answers: (json['answers'] as List<dynamic>?)
          ?.map((a) => QuizAnswer.fromJson(a))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quizId': quizId,
      'userId': userId,
      'score': score,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'completedAt': completedAt.toIso8601String(),
      'timeSpent': timeSpent,
      'answers': answers.map((a) => a.toJson()).toList(),
    };
  }

  double get percentage {
    if (totalQuestions == 0) return 0.0;
    return (correctAnswers / totalQuestions) * 100;
  }
}

class QuizAnswer {
  final int questionId;
  final int selectedAnswer;
  final bool isCorrect;
  final int timeSpent; // in seconds

  QuizAnswer({
    required this.questionId,
    required this.selectedAnswer,
    required this.isCorrect,
    required this.timeSpent,
  });

  factory QuizAnswer.fromJson(Map<String, dynamic> json) {
    return QuizAnswer(
      questionId: json['questionId'],
      selectedAnswer: json['selectedAnswer'],
      isCorrect: json['isCorrect'],
      timeSpent: json['timeSpent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'selectedAnswer': selectedAnswer,
      'isCorrect': isCorrect,
      'timeSpent': timeSpent,
    };
  }
}
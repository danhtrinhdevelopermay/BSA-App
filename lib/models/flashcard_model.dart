// Flashcard models for Bright Starts Academy
class FlashcardDeck {
  final int id;
  final String title;
  final String? description;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int flashcardCount;
  final String? color;
  final bool isPublic;

  FlashcardDeck({
    required this.id,
    required this.title,
    this.description,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.flashcardCount = 0,
    this.color,
    this.isPublic = false,
  });

  factory FlashcardDeck.fromJson(Map<String, dynamic> json) {
    return FlashcardDeck(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      userId: json['userId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      flashcardCount: json['flashcardCount'] ?? 0,
      color: json['color'],
      isPublic: json['isPublic'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'flashcardCount': flashcardCount,
      'color': color,
      'isPublic': isPublic,
    };
  }
}

class Flashcard {
  final int id;
  final int deckId;
  final String front;
  final String back;
  final String? hint;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int reviewCount;
  final int correctCount;
  final DateTime? lastReviewedAt;
  final double difficulty;

  Flashcard({
    required this.id,
    required this.deckId,
    required this.front,
    required this.back,
    this.hint,
    required this.createdAt,
    required this.updatedAt,
    this.reviewCount = 0,
    this.correctCount = 0,
    this.lastReviewedAt,
    this.difficulty = 1.0,
  });

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      id: json['id'],
      deckId: json['deckId'],
      front: json['front'],
      back: json['back'],
      hint: json['hint'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      reviewCount: json['reviewCount'] ?? 0,
      correctCount: json['correctCount'] ?? 0,
      lastReviewedAt: json['lastReviewedAt'] != null 
          ? DateTime.parse(json['lastReviewedAt']) 
          : null,
      difficulty: json['difficulty']?.toDouble() ?? 1.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deckId': deckId,
      'front': front,
      'back': back,
      'hint': hint,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'reviewCount': reviewCount,
      'correctCount': correctCount,
      'lastReviewedAt': lastReviewedAt?.toIso8601String(),
      'difficulty': difficulty,
    };
  }

  double get successRate {
    if (reviewCount == 0) return 0.0;
    return correctCount / reviewCount;
  }

  bool get needsReview {
    if (lastReviewedAt == null) return true;
    final daysSinceReview = DateTime.now().difference(lastReviewedAt!).inDays;
    return daysSinceReview >= (difficulty * 7).round();
  }
}
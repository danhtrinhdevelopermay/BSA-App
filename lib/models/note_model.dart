// Note model for Bright Starts Academy
class Note {
  final int id;
  final String title;
  final String content;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;
  final String? category;
  final bool isPinned;
  final String? color;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
    this.category,
    this.isPinned = false,
    this.color,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      userId: json['userId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      tags: List<String>.from(json['tags'] ?? []),
      category: json['category'],
      isPinned: json['isPinned'] ?? false,
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'tags': tags,
      'category': category,
      'isPinned': isPinned,
      'color': color,
    };
  }

  Note copyWith({
    int? id,
    String? title,
    String? content,
    int? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
    String? category,
    bool? isPinned,
    String? color,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
      category: category ?? this.category,
      isPinned: isPinned ?? this.isPinned,
      color: color ?? this.color,
    );
  }
}
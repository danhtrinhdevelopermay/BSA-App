// User model for Bright Starts Academy
class User {
  final int id;
  final String firebaseUid;
  final String username;
  final String email;
  final String? displayName;
  final String? avatar;
  final int xp;
  final int level;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? bio;
  final bool isVerified;
  final String? location;
  final Map<String, dynamic>? preferences;

  User({
    required this.id,
    required this.firebaseUid,
    required this.username,
    required this.email,
    this.displayName,
    this.avatar,
    required this.xp,
    required this.level,
    required this.createdAt,
    required this.updatedAt,
    this.bio,
    this.isVerified = false,
    this.location,
    this.preferences,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firebaseUid: json['firebaseUid'],
      username: json['username'],
      email: json['email'],
      displayName: json['displayName'],
      avatar: json['avatar'],
      xp: json['xp'] ?? 0,
      level: json['level'] ?? 1,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      bio: json['bio'],
      isVerified: json['isVerified'] ?? false,
      location: json['location'],
      preferences: json['preferences'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firebaseUid': firebaseUid,
      'username': username,
      'email': email,
      'displayName': displayName,
      'avatar': avatar,
      'xp': xp,
      'level': level,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'bio': bio,
      'isVerified': isVerified,
      'location': location,
      'preferences': preferences,
    };
  }

  User copyWith({
    int? id,
    String? firebaseUid,
    String? username,
    String? email,
    String? displayName,
    String? avatar,
    int? xp,
    int? level,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? bio,
    bool? isVerified,
    String? location,
    Map<String, dynamic>? preferences,
  }) {
    return User(
      id: id ?? this.id,
      firebaseUid: firebaseUid ?? this.firebaseUid,
      username: username ?? this.username,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatar: avatar ?? this.avatar,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      bio: bio ?? this.bio,
      isVerified: isVerified ?? this.isVerified,
      location: location ?? this.location,
      preferences: preferences ?? this.preferences,
    );
  }
}
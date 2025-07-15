// Assignment model for Bright Starts Academy
class Assignment {
  final int id;
  final String title;
  final String? description;
  final int userId;
  final DateTime dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final AssignmentPriority priority;
  final AssignmentStatus status;
  final String? subject;
  final String? notes;
  final int? reminderMinutes;

  Assignment({
    required this.id,
    required this.title,
    this.description,
    required this.userId,
    required this.dueDate,
    required this.createdAt,
    required this.updatedAt,
    this.priority = AssignmentPriority.medium,
    this.status = AssignmentStatus.pending,
    this.subject,
    this.notes,
    this.reminderMinutes,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      userId: json['userId'],
      dueDate: DateTime.parse(json['dueDate']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      priority: AssignmentPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => AssignmentPriority.medium,
      ),
      status: AssignmentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => AssignmentStatus.pending,
      ),
      subject: json['subject'],
      notes: json['notes'],
      reminderMinutes: json['reminderMinutes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'userId': userId,
      'dueDate': dueDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'priority': priority.name,
      'status': status.name,
      'subject': subject,
      'notes': notes,
      'reminderMinutes': reminderMinutes,
    };
  }

  Assignment copyWith({
    int? id,
    String? title,
    String? description,
    int? userId,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    AssignmentPriority? priority,
    AssignmentStatus? status,
    String? subject,
    String? notes,
    int? reminderMinutes,
  }) {
    return Assignment(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      subject: subject ?? this.subject,
      notes: notes ?? this.notes,
      reminderMinutes: reminderMinutes ?? this.reminderMinutes,
    );
  }

  bool get isOverdue {
    return status != AssignmentStatus.completed && 
           DateTime.now().isAfter(dueDate);
  }

  bool get isDueSoon {
    final now = DateTime.now();
    final hoursUntilDue = dueDate.difference(now).inHours;
    return hoursUntilDue <= 24 && hoursUntilDue > 0;
  }

  String get timeUntilDue {
    final now = DateTime.now();
    final duration = dueDate.difference(now);
    
    if (duration.isNegative) {
      return 'Overdue';
    }
    
    if (duration.inDays > 0) {
      return '${duration.inDays} ngày';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} giờ';
    } else {
      return '${duration.inMinutes} phút';
    }
  }
}

enum AssignmentPriority {
  low('Thấp'),
  medium('Trung bình'),
  high('Cao'),
  urgent('Khẩn cấp');

  const AssignmentPriority(this.displayName);
  final String displayName;
}

enum AssignmentStatus {
  pending('Chờ'),
  inProgress('Đang làm'),
  completed('Hoàn thành'),
  cancelled('Hủy');

  const AssignmentStatus(this.displayName);
  final String displayName;
}
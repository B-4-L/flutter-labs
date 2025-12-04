class Habit {
  final String id;
  final String title;
  final String description;
  final int streak;
  final bool completed;
  final DateTime createdAt;
  final DateTime? lastCompletedAt;

  Habit({
    required this.id,
    required this.title,
    required this.description,
    required this.streak,
    required this.completed,
    required this.createdAt,
    this.lastCompletedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'streak': streak,
      'completed': completed,
      'createdAt': createdAt.toIso8601String(),
      'lastCompletedAt': lastCompletedAt?.toIso8601String(),
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      streak: json['streak'] ?? 0,
      completed: json['completed'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      lastCompletedAt: json['lastCompletedAt'] != null
          ? DateTime.parse(json['lastCompletedAt'])
          : null,
    );
  }

  Habit copyWith({
    String? id,
    String? title,
    String? description,
    int? streak,
    bool? completed,
    DateTime? createdAt,
    DateTime? lastCompletedAt,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      streak: streak ?? this.streak,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
      lastCompletedAt: lastCompletedAt ?? this.lastCompletedAt,
    );
  }
}
class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool completed;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.completed,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? completed,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      completed: completed ?? this.completed,
    );
  }
}
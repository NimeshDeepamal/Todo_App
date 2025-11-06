import 'package:todo_app/data/models/task_dto.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool completed;
  final String userId;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.completed,
    required this.userId,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? completed,
    String? userId,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      completed: completed ?? this.completed,
      userId: userId ?? this.userId,
    );
  }

  /// Convert Task entity to TaskDto for local DB
  TaskDto toDto() {
    return TaskDto(
      id: id,
      title: title,
      description: description,
      dueDate: dueDate.millisecondsSinceEpoch,
      completed: completed ? 1 : 0,
      userId: userId,
    );
  }

  /// Convert TaskDto back to Task entity
  factory Task.fromDto(TaskDto dto) {
    return Task(
      id: dto.id,
      title: dto.title,
      description: dto.description,
      dueDate: DateTime.fromMillisecondsSinceEpoch(dto.dueDate),
      completed: dto.completed == 1,
      userId: dto.userId,
    );
  }
}

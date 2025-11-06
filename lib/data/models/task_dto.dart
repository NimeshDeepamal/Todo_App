import 'package:todo_app/domain/entities/task.dart';

class TaskDto {
  final String id;
  final String title;
  final String description;
  final int dueDate;
  final int completed;
  final String userId;

  TaskDto({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.completed,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'completed': completed,
      'userId': userId,
    };
  }

  factory TaskDto.fromMap(Map<String, dynamic> map) => TaskDto(
        id: map['id'] as String,
        title: map['title'] as String,
        description: map['description'] as String,
        dueDate: map['dueDate'] as int,
        completed: map['completed'] as int,
        userId: map['userId'] as String,
      );

  factory TaskDto.fromEntity(Task task) => TaskDto(
        id: task.id,
        title: task.title,
        description: task.description,
        dueDate: task.dueDate.millisecondsSinceEpoch,
        completed: task.completed ? 1 : 0,
        userId: task.userId,
      );

  Task toEntity() => Task(
        id: id,
        title: title,
        description: description,
        dueDate: DateTime.fromMillisecondsSinceEpoch(dueDate),
        completed: completed == 1,
        userId: userId,
      );
}

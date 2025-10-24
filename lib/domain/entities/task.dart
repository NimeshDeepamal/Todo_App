import 'package:flutter/foundation.dart';

@immutable
class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool completed;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.completed = false,
  });

  Task copyWith({String? title, String? description, DateTime? dueDate, bool? completed}) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      completed: completed ?? this.completed,
    );
  }
}

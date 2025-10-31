

class TaskDto {
  final String id;
  final String title;
  final String description;
  final int dueDate;
  final int completed;

  TaskDto({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.completed,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'completed': completed,
    };
  }

  factory TaskDto.fromMap(Map<String, dynamic> map) {
    return TaskDto(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      dueDate: map['dueDate'] as int,
      completed: map['completed'] as int,
    );
  }
}
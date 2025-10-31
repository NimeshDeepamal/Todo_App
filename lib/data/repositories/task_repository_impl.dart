import 'package:todo_app/data/datasources/local_db.dart';
import 'package:todo_app/data/models/task_dto.dart';
import 'package:todo_app/domain/entities/task.dart';
import 'package:todo_app/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  @override
  Future<List<Task>> getAllTasks() async {
    final taskDtos = await LocalDb.getAllTasks();
    return taskDtos.map((dto) => Task(
          id: dto.id,
          title: dto.title,
          description: dto.description,
          dueDate: DateTime.fromMillisecondsSinceEpoch(dto.dueDate),
          completed: dto.completed == 1,
        )).toList();
  }

  @override
  Future<void> addTask(Task task) async {
    final dto = TaskDto(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate.millisecondsSinceEpoch,
      completed: task.completed ? 1 : 0,
    );
    await LocalDb.insertTask(dto);
  }

  @override
  Future<void> updateTask(Task task) async {
    final dto = TaskDto(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate.millisecondsSinceEpoch,
      completed: task.completed ? 1 : 0,
    );
    await LocalDb.updateTask(dto);
  }

  @override
  Future<void> deleteTask(String id) async {
    await LocalDb.deleteTask(id);
  }
}
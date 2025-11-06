import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/task.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../data/datasources/local_db.dart';

final _repoProvider = Provider((ref) => TaskRepositoryImpl());

class TaskListState {
  final List<Task> tasks;
  final bool? filter;

  TaskListState({required this.tasks, this.filter});

  TaskListState copyWith({List<Task>? tasks, bool? filter}) {
    return TaskListState(
      tasks: tasks ?? this.tasks,
      filter: filter ?? this.filter,
    );
  }
}

class TaskListNotifier extends AsyncNotifier<TaskListState> {
  List<Task> _allTasks = [];

  String get _userId {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");
    return user.uid;
  }

  @override
  Future<TaskListState> build() async {
    await loadTasks();
    return TaskListState(tasks: _allTasks, filter: null);
  }

  Future<void> loadTasks() async {
    state = const AsyncLoading();
    final userId = _userId;

    try {
      final tasks = await ref.read(_repoProvider).getAllTasks();
      _allTasks = tasks.where((t) => t.userId == userId).toList();
      _applyFilter(state.value?.filter);
    } catch (e) {
      debugPrint("Load tasks failed: $e");
    }
  }

  Future<Task> addTask({
    required String title,
    required String description,
    required DateTime dueDate,
  }) async {
    final userId = _userId;
    final newTask = Task(
      id: const Uuid().v4(),
      title: title,
      description: description,
      dueDate: dueDate,
      completed: false,
      userId: userId,
    );

    _allTasks.add(newTask);
    _applyFilter(state.value?.filter);

    await LocalDb.insertTask(newTask.toDto());

    ref.read(_repoProvider).addTask(newTask).catchError((error) {
      debugPrint("Failed to sync task to Firebase: $error");
    });

    return newTask;
  }

  Future<void> updateTask(Task task) async {
    final index = _allTasks.indexWhere((t) => t.id == task.id);
    if (index != -1) _allTasks[index] = task;

    _applyFilter(state.value?.filter);

    await ref.read(_repoProvider).updateTask(task);
    await LocalDb.updateTask(task.toDto());
  }

  Future<void> deleteTask(String id) async {
    _allTasks.removeWhere((t) => t.id == id);
    _applyFilter(state.value?.filter);

    await ref.read(_repoProvider).deleteTask(id);
    await LocalDb.deleteTask(id, _userId);
  }

  Future<void> toggleComplete(Task task) async {
    final updated = task.copyWith(completed: !task.completed);
    await updateTask(updated);
  }

  void setFilter(bool? filter) => _applyFilter(filter);

  void _applyFilter(bool? filter) {
    final filteredTasks = filter == null
        ? _allTasks
        : _allTasks.where((t) => t.completed == filter).toList();

    state = AsyncData(TaskListState(tasks: filteredTasks, filter: filter));
  }

  Future<void> clearAllTasks() async {
    _allTasks = [];
    state = AsyncData(TaskListState(tasks: [], filter: null));
    try {
      await LocalDb.clearTasks(_userId);
    } catch (e) {
      debugPrint("Failed to clear local tasks: $e");
    }
  }

  Future<void> logoutAndClearTasks() async {
    final userId = _userId;
    if (userId != null) {
      await LocalDb.clearTasks(userId);
    }

    _allTasks = [];
    state = AsyncData(TaskListState(tasks: [], filter: null));
  }
}

final taskListProvider = AsyncNotifierProvider<TaskListNotifier, TaskListState>(
  () => TaskListNotifier(),
);

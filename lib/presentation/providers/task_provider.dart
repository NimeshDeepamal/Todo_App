import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/task.dart';
import '../../data/repositories/task_repository_impl.dart';

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

  @override
  Future<TaskListState> build() async {
    await loadTasks();
    return TaskListState(tasks: _allTasks, filter: null);
  }

  bool? get currentFilter => state.value?.filter;

  Future<void> loadTasks() async {
    final currentFilter = state.value?.filter;
    state = const AsyncLoading();
    final tasks = await ref.read(_repoProvider).getAllTasks();
    _allTasks = List.from(tasks);
    print(
      'Loaded tasks: ${_allTasks.map((t) => 'Task(id: ${t.id}, title: ${t.title}, completed: ${t.completed})').toList()}',
    );
    _applyFilter(currentFilter);
  }

  Future<void> addTask({
    required String title,
    required String description,
    required DateTime dueDate,
  }) async {
    final newTask = Task(
      id: const Uuid().v4(),
      title: title,
      description: description,
      dueDate: dueDate,
      completed: false,
    );
    await ref.read(_repoProvider).addTask(newTask);
    await loadTasks();
    ref.invalidateSelf();
  }

  /// ✅ FIXED: Allow editing any task (complete or incomplete) without breaking filters
  Future<void> updateTask(Task t) async {
    final currentFilter = state.value?.filter;
    print('Updating task ${t.id} (keep filter: $currentFilter)');
    await ref.read(_repoProvider).updateTask(t);
    await loadTasks(); // reload latest list
    _applyFilter(currentFilter); // keep the same filter
    print('Task ${t.id} updated successfully with preserved filter.');
  }

  Future<void> deleteTask(String id) async {
    await ref.read(_repoProvider).deleteTask(id);
    await loadTasks();
    ref.invalidateSelf();
  }

  Future<void> toggleComplete(Task t) async {
    final currentFilter = state.value?.filter;
    print('Toggling task ${t.id}, preserving filter: $currentFilter');
    final updated = t.copyWith(completed: !t.completed);
    await ref.read(_repoProvider).updateTask(updated);
    await loadTasks();
    _applyFilter(currentFilter);
    print('Toggle complete finished, filter: $currentFilter');
  }

  void setFilter(bool? filter) {
    print('Setting filter to: $filter');
    if (filter == null) {
      print('All filter triggered in setFilter');
    }
    final currentState =
        state.value ?? TaskListState(tasks: _allTasks, filter: null);
    state = AsyncData(currentState.copyWith(filter: filter, tasks: []));
    if (filter == null) {
      print('All filter applied, forcing state refresh');
      ref.invalidateSelf();
    }
    _applyFilter(filter);
    print('setFilter completed for filter: $filter');
  }

  void _applyFilter(bool? filter) {
    final currentState =
        state.value ?? TaskListState(tasks: _allTasks, filter: filter);
    print('Applying filter: $filter');
    print(
      'All tasks before filter: ${_allTasks.map((t) => 'Task(id: ${t.id}, title: ${t.title}, completed: ${t.completed})').toList()}',
    );
    if (filter == null) {
      state = AsyncData(
        currentState.copyWith(
          tasks: List.unmodifiable(_allTasks),
          filter: filter,
        ),
      );
    } else {
      state = AsyncData(
        currentState.copyWith(
          tasks: List.unmodifiable(
            _allTasks.where((t) => t.completed == filter).toList(),
          ),
          filter: filter,
        ),
      );
    }
    print(
      'Filtered tasks: ${state.value?.tasks.map((t) => 'Task(id: ${t.id}, title: ${t.title}, completed: ${t.completed})').toList()}',
    );
  }
}

final taskListProvider = AsyncNotifierProvider<TaskListNotifier, TaskListState>(
  () {
    return TaskListNotifier();
  },
);

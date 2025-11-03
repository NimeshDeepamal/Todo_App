import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';
import 'task_card.dart';
import '../screens/add_edit_task_screen.dart';

class TaskListComponent extends ConsumerStatefulWidget {
  const TaskListComponent({super.key});

  @override
  ConsumerState<TaskListComponent> createState() => _TaskListComponentState();
}

class _TaskListComponentState extends ConsumerState<TaskListComponent> {
  int _selectedIndex = 0;
  final List<bool?> _filterOptions = [null, false, true];

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskListProvider);
    final currentFilter = _filterOptions[_selectedIndex];

    return Column(
      children: [
        SizedBox(
          height: 50,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: _filterOptions.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final isActive = _selectedIndex == index;
              final label = index == 0
                  ? 'All'
                  : index == 1
                  ? 'Incomplete'
                  : 'Completed';

              return ElevatedButton(
                onPressed: () {
                  setState(() => _selectedIndex = index);
                  ref
                      .read(taskListProvider.notifier)
                      .setFilter(_filterOptions[index]);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isActive
                      ? const Color.fromARGB(255, 7, 106, 255)
                      : const Color.fromARGB(255, 248, 248, 248),
                  foregroundColor: isActive ? Colors.white : Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                ),
                child: Text(label),
              );
            },
          ),
        ),

        const SizedBox(height: 8),

        Expanded(
          child: taskState.when(
            data: (state) {
              final tasks = state.tasks;
              if (tasks.isEmpty) {
                return const Center(
                  child: Text('No tasks yet. Tap + to add one.'),
                );
              }

              return GridView.builder(
                key: ValueKey(currentFilter),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return TaskCard(
                    task: task,
                    onToggle: () {
                      ref.read(taskListProvider.notifier).toggleComplete(task);
                    },
                    onDelete: () {
                      ref.read(taskListProvider.notifier).deleteTask(task.id);
                    },
                    onEdit: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AddEditTaskScreen(task: task),
                        ),
                      );
                      await ref.read(taskListProvider.notifier).loadTasks();
                    },
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }
}

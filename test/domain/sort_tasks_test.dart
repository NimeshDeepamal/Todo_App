import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/domain/entities/task.dart';

void main() {
  test('Tasks sort ascending by due date', () {
    final t1 = Task(
      id: '1',
      title: 'Task 1',
      description: 'First task',
      dueDate: DateTime(2025, 1, 2),
      completed: false,
      userId: 'user1',
    );

    final t2 = Task(
      id: '2',
      title: 'Task 2',
      description: 'Second task',
      dueDate: DateTime(2025, 1, 1),
      completed: false,
      userId: 'user1',
    );

    final list = [t1, t2];
    list.sort((a, b) => a.dueDate.compareTo(b.dueDate));

    expect(list[0].id, '2');
    expect(list[1].id, '1');
  });
}

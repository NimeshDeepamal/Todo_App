import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/domain/entities/task.dart';

void main() {
  test('Tasks sort ascending by due date', () {
    final t1 = Task(
      id: '1',
      title: '1',
      description: '',
      dueDate: DateTime(2025, 1, 2),
      completed: false, 
    );
    final t2 = Task(
      id: '2',
      title: '2',
      description: '',
      dueDate: DateTime(2025, 1, 1),
      completed: false, 
    );
    final list = [t1, t2];
    list.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    expect(list[0].id, '2');
  });
}
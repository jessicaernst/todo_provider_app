import 'package:flutter/material.dart';
import 'package:todo_provider_app/features/to_do_list/data/todo_notifier.dart';
import 'package:todo_provider_app/features/to_do_list/models/todo.dart';
import 'package:todo_provider_app/features/to_do_list/widgets/todo_tile.dart';

class OpenTodosSection extends StatelessWidget {
  const OpenTodosSection({
    super.key, // super.key hinzugefügt
    required this.todos,
    required this.notifier,
  });

  final List<Todo> todos;
  final TodoNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Offen',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ...todos.map((todo) {
          return TodoTile(
            key: ValueKey('open_${todo.id}'),
            todo: todo,
            onToggle: () => notifier.toggleTodo(todo),
            onDelete: () => notifier.removeTodo(todo),
          );
        }),
      ],
    );
  }
}

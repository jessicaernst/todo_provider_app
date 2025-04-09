import 'package:flutter/material.dart';
import 'package:todo_provider_app/features/to_do_list/models/todo.dart';
import 'package:todo_provider_app/features/to_do_list/widgets/todo_tile.dart';

class OpenTodosSection extends StatelessWidget {
  const OpenTodosSection({
    super.key,
    required this.todos,
    required this.onToggle,
    required this.onDelete,
  });

  final List<Todo> todos;
  final ValueChanged<Todo> onDelete;
  final ValueChanged<Todo> onToggle;

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
            onToggle: () => onToggle(todo),
            onDelete: () => onDelete(todo),
          );
        }),
      ],
    );
  }
}

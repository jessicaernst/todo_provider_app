import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_provider_app/features/to_do_list/data/todo_notifier.dart';

Future<void> showAddTodoDialog(BuildContext context) {
  final controller = TextEditingController();

  void addTodoAndClose() {
    final title = controller.text.trim();
    if (title.isNotEmpty) {
      context.read<TodoNotifier>().addTodo(title);
    }
    Navigator.of(context).pop();
  }

  return showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Neue Aufgabe'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Was steht an?'),
          onSubmitted: (_) => addTodoAndClose(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: addTodoAndClose,
            child: const Text('Hinzufügen'),
          ),
        ],
      );
    },
  );
}

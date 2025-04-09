import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_provider_app/features/to_do_list/data/todo_notifier.dart';
import 'package:todo_provider_app/features/to_do_list/widgets/add_todo_dialog.dart';
import 'package:todo_provider_app/features/to_do_list/widgets/completed_todos_section.dart';
import 'package:todo_provider_app/features/to_do_list/widgets/empty_list_message.dart';
import 'package:todo_provider_app/features/to_do_list/widgets/open_todos_section.dart';

class ToDoHomePage extends StatelessWidget {
  const ToDoHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Consumer<TodoNotifier>(
        // Consumer um die Listen zu holen
        builder: (context, todoNotifier, _) {
          final openTodos = todoNotifier.openTodos;
          final completedTodos = todoNotifier.completedTodos;

          final bool hasOpenTodos = openTodos.isNotEmpty;
          final bool hasCompletedTodos = completedTodos.isNotEmpty;
          final bool hasAnyTodos = hasOpenTodos || hasCompletedTodos;

          if (!hasAnyTodos) {
            return const EmptyListMessage();
          }

          // Baue die ListView mit den ausgelagerten Sektions-Widgets
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              if (hasOpenTodos)
                // Verwende das ausgelagerte Widget für offene Todos
                OpenTodosSection(todos: openTodos, notifier: todoNotifier),

              if (hasOpenTodos && hasCompletedTodos)
                const Divider(height: 30, thickness: 1),

              if (hasCompletedTodos)
                // Verwende das ausgelagerte Widget für erledigte Todos
                CompletedTodosSection(
                  todos: completedTodos,
                  notifier: todoNotifier,
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Rufe die ausgelagerte Funktion auf, um den Dialog anzuzeigen
          showAddTodoDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

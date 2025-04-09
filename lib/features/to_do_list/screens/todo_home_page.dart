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

      // Der Consumer lauscht auf Änderungen im TodoNotifier.
      // Wenn sich dort etwas ändert (z. B. eine Aufgabe wird erledigt),
      // wird nur dieser Teil neu gebaut – nicht die ganze App.
      body: Consumer<TodoNotifier>(
        builder: (context, todoNotifier, _) {
          // Zugriff auf die Listen aus dem Notifier
          final openTodos = todoNotifier.openTodos;
          final completedTodos = todoNotifier.completedTodos;

          // Prüfen, ob es Aufgaben gibt (offen oder erledigt)
          final bool hasOpenTodos = openTodos.isNotEmpty;
          final bool hasCompletedTodos = completedTodos.isNotEmpty;
          final bool hasAnyTodos = hasOpenTodos || hasCompletedTodos;

          // Wenn keine Aufgaben vorhanden sind, zeige stattdessen eine leere Nachricht
          if (!hasAnyTodos) {
            return const EmptyListMessage();
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Abschnitt mit offenen Aufgaben
              if (hasOpenTodos)
                OpenTodosSection(
                  todos: openTodos,

                  // onToggle bekommt eine einzelne Aufgabe (todo)
                  // und ruft im Notifier toggleTodo(todo) auf,
                  // um den Status (erledigt / offen) zu wechseln
                  onToggle: (todo) => todoNotifier.toggleTodo(todo),

                  // Entfernt die Aufgabe aus der Liste
                  onDelete: (todo) => todoNotifier.removeTodo(todo),
                ),

              // Wenn es beide Listen gibt, trenne sie optisch
              if (hasOpenTodos && hasCompletedTodos)
                const Divider(height: 30, thickness: 1),

              // Abschnitt mit erledigten Aufgaben
              if (hasCompletedTodos)
                CompletedTodosSection(
                  todos: completedTodos,

                  // Gleiches Prinzip wie oben: Wir übergeben eine Funktion,
                  // die dem Notifier sagt: „Diese Aufgabe umschalten.“
                  onToggle: (todo) => todoNotifier.toggleTodo(todo),

                  // Und auch löschen geht so – alles über Notifier
                  onDelete: (todo) => todoNotifier.removeTodo(todo),
                ),
            ],
          );
        },
      ),

      // FloatingActionButton öffnet einen Dialog zum Hinzufügen einer neuen Aufgabe
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Diese Funktion zeigt ein Eingabefeld – siehe separate Dialog-Funktion
          showAddTodoDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

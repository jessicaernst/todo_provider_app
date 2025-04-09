import 'package:flutter/material.dart';
import 'package:todo_provider_app/features/to_do_list/models/todo.dart';
import 'package:todo_provider_app/features/to_do_list/widgets/todo_tile.dart';

// Dieses Widget zeigt alle erledigten Aufgaben (Todos), also mit isDone = true.
// Es ist ein sogenanntes "Präsentations-Widget": Es zeigt nur UI und reicht Nutzerinteraktionen weiter.
// Die tatsächliche Logik (z. B. was passiert, wenn man etwas löscht) liegt nicht hier.
class CompletedTodosSection extends StatelessWidget {
  const CompletedTodosSection({
    super.key,
    required this.todos, // Liste der erledigten Todos
    required this.onDelete, // Wird aufgerufen, wenn ein Todo gelöscht wird
    required this.onToggle, // Wird aufgerufen, wenn ein Todo "zurückgesetzt" wird (also wieder offen)
  });

  final List<Todo> todos;

  // ValueChanged<Todo> ist eine Typdefinition aus Flutter:
  // Es bedeutet: eine Funktion, die ein Todo entgegennimmt und void (nichts) zurückgibt.
  //
  // Das erlaubt es dem Widget, von außen eine Funktion zu bekommen,
  // z. B. todoNotifier.removeTodo(todo), ohne zu wissen, *was* genau dabei passiert.
  final ValueChanged<Todo> onDelete;
  final ValueChanged<Todo> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Überschrift: "Erledigt"
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Erledigt',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),

        // Für jedes erledigte Todo wird ein TodoTile angezeigt
        // Die drei Punkte ... entpacken die Liste als einzelne Widgets
        ...todos.map((todo) {
          return TodoTile(
            key: ValueKey(
              'completed_${todo.id}',
            ), // Key zur eindeutigen Identifikation (wichtig bei ListView)

            todo: todo,

            // onToggle ruft die übergebene Funktion mit dem aktuellen Todo auf.
            // So kann z. B. das Eltern-Widget (z. B. ToDoHomePage) sagen:
            // "Wenn das gedrückt wird, schalte den Status zurück auf offen."
            onToggle: () => onToggle(todo),

            // Gleiches Prinzip für das Löschen
            onDelete: () => onDelete(todo),
          );
        }),
      ],
    );
  }
}

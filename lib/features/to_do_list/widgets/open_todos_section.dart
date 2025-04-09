import 'package:flutter/material.dart';
import 'package:todo_provider_app/features/to_do_list/models/todo.dart';
import 'package:todo_provider_app/features/to_do_list/widgets/todo_tile.dart';

// Dieses Widget zeigt alle offenen Todos in einer Liste.
// Die Logik (z. B. "Todo löschen" oder "als erledigt markieren") wird
// nicht hier ausgeführt, sondern per Callback (Funktion) nach oben gegeben.
class OpenTodosSection extends StatelessWidget {
  const OpenTodosSection({
    super.key,
    required this.todos, // Liste offener Todos
    required this.onToggle, // Wird aufgerufen, wenn ein Todo angehakt wird
    required this.onDelete, // Wird aufgerufen, wenn ein Todo gelöscht wird
  });

  final List<Todo> todos;

  // ValueChanged<Todo> ist ein vordefinierter Typ in Flutter.
  // Es ist nur ein Kürzel für: void Function(Todo)
  //
  // → Du gibst eine Funktion weiter, die ein Todo entgegennimmt und nichts zurückgibt.
  // So kann z. B. das Eltern-Widget (ToDoHomePage) sagen, was bei einem Klick passieren soll.
  final ValueChanged<Todo> onDelete;
  final ValueChanged<Todo> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Überschrift "Offen"
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Offen',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),

        // Für jedes offene Todo wird ein eigenes Tile (Listeneintrag) angezeigt.
        // Die drei Punkte ... "entpacken" die Liste direkt als Widgets.
        ...todos.map((todo) {
          return TodoTile(
            key: ValueKey(
              'open_${todo.id}',
            ), // Optional: gibt jedem Tile einen eindeutigen Key

            todo: todo,

            // Wenn z. B. die Checkbox geklickt wird,
            // ruft TodoTile → onToggle() → das hier auf → ruft dann onToggle(todo)
            // Das heißt: "Das übergebene Todo umschalten (done/offen)"
            onToggle: () => onToggle(todo),

            // Gleiches Prinzip für Löschen
            onDelete: () => onDelete(todo),
          );
        }),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:todo_provider_app/features/to_do_list/models/todo.dart';

// Dieses Widget stellt eine einzelne Todo-Zeile dar (Checkbox, Titel, Delete-Button).
// Es ist rein zuständig für Darstellung + Benutzerinteraktion,
// aber es speichert keinen eigenen Zustand (StatelessWidget).
class TodoTile extends StatelessWidget {
  const TodoTile({
    super.key,
    required this.todo, // Die aktuelle Aufgabe, die angezeigt wird
    required this.onToggle, // Wird aufgerufen, wenn Checkbox geklickt wird
    required this.onDelete, // Wird aufgerufen, wenn das Icon gedrückt wird
  });

  final Todo todo;

  // VoidCallback ist eine vordefinierte Typbezeichnung in Flutter:
  // void Function() → also eine Funktion ohne Parameter und ohne Rückgabe.
  //
  // Das reicht hier völlig aus, weil:
  // - TodoTile bekommt schon *das passende Todo* als Parameter (siehe oben)
  // - onToggle & onDelete müssen daher **nicht wissen**, welches Todo gemeint ist
  // - sie "wissen" das schon durch den Scope (Closure)

  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // Checkbox zeigt den Zustand (erledigt/offen) an
      // onChanged feuert onToggle(), das kommt z. B. aus OpenTodosSection
      leading: Checkbox(
        value: todo.isDone,
        onChanged: (_) => onToggle(), // kein Wert wird übergeben – reicht!
      ),

      // Titel der Aufgabe, durchgestrichen wenn erledigt
      title: Text(
        todo.title,
        style: TextStyle(
          decoration: todo.isDone ? TextDecoration.lineThrough : null,
        ),
      ),

      // Delete-Button ruft onDelete() auf – Funktion kommt von außen
      trailing: IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
    );
  }
}

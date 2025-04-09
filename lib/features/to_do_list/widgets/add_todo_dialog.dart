import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_provider_app/features/to_do_list/data/todo_notifier.dart';

/// Diese Funktion zeigt einen Dialog an, um ein neues Todo hinzuzufügen.
/// Sie ist **keine eigene Widget-Klasse**, sondern eine Funktion – und das aus gutem Grund:
///
/// ✅ Warum als Funktion?
/// - Der Dialog ist **temporär** und gehört **nicht dauerhaft** zum UI-Baum.
/// - Die zugehörige Logik (`TextEditingController`, `addTodoAndClose`) ist **lokal und kurzlebig**.
/// - Die Funktion ist übersichtlich, schnell aufrufbar und braucht keinen eigenen State.
///
/// 🧠 Warum kein Widget?
/// - Ein eigenes Widget mit `StatefulWidget` würde **mehr Boilerplate** bedeuten.
/// - Wir müssten dort `initState()` und `dispose()` manuell pflegen.
/// - Für ein so kurzes, einfaches UI-Element lohnt sich das **nicht**.
///
/// 🧼 Warum muss der TextEditingController hier NICHT disposed werden?
/// - Der Controller ist in einer **lokalen Funktion**.
/// - Er lebt **nur während der Dauer des Dialogs**.
/// - Sobald `showDialog()` geschlossen wird, wird der komplette Dialog (inkl. Controller) vom Garbage Collector entsorgt.
/// - Flutter kann hier **automatisch aufräumen**, da nichts langfristig referenziert wird.
///
/// 👉 Merksatz:
/// Wenn du einen Controller **in einem StatefulWidget verwendest**, musst du ihn **selbst dispose()n**.
/// Wenn du ihn **lokal in einer Funktion** nutzt (wie hier), **musst du das nicht tun**.
Future<void> showAddTodoDialog(BuildContext context) {
  // Controller für das Texteingabefeld – damit kannst du den Inhalt später lesen
  final controller = TextEditingController();

  // Innere Hilfsfunktion: Holt den eingegebenen Text, speichert ihn und schließt den Dialog
  void addTodoAndClose() {
    final title = controller.text.trim();

    if (title.isNotEmpty) {
      // Hier verwenden wir Provider, um den neuen Todo in den globalen State zu speichern
      context.read<TodoNotifier>().addTodo(title);
    }

    // Dialog schließen
    Navigator.of(context).pop();
  }

  // Jetzt wird der Dialog selbst angezeigt:
  return showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      // Rückgabe ist ein AlertDialog – ein eingebautes Flutter-Dialog-Widget
      return AlertDialog(
        title: const Text('Neue Aufgabe'),

        // Eingabefeld für die neue Aufgabe
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Was steht an?'),

          // Wenn der Benutzer Enter drückt → gleiche Logik wie bei Button
          onSubmitted: (_) => addTodoAndClose(),
        ),

        // Buttons unten im Dialog
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

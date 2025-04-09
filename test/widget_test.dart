import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:todo_provider_app/app/to_do_app.dart';
import 'package:todo_provider_app/features/to_do_list/data/todo_notifier.dart';
import 'package:todo_provider_app/features/to_do_list/widgets/todo_tile.dart';

void main() {
  // Hilfsfunktion, um die App mit einem Provider zu starten
  // Gibt den Notifier zurück, falls wir ihn direkt manipulieren wollen (selten nötig in Widget-Tests)
  Future<TodoNotifier> pumpToDoApp(WidgetTester tester) async {
    final notifier = TodoNotifier();
    await tester.pumpWidget(
      ChangeNotifierProvider<TodoNotifier>.value(
        value: notifier,
        child: const ToDoApp(), // Starte deine Haupt-App
      ),
    );
    await tester.pumpAndSettle(); // Warte auf Initialisierung/Animationen
    return notifier;
  }

  group('ToDo App Widget Tests', () {
    testWidgets('1. Initial state shows empty message', (
      WidgetTester tester,
    ) async {
      // Arrange: App starten
      await pumpToDoApp(tester);

      // Assert: Überprüfen, ob die "Leer"-Nachricht angezeigt wird
      expect(find.text('Füge deine erste Aufgabe hinzu!'), findsOneWidget);
      expect(find.text('Offen'), findsNothing); // Keine Überschriften
      expect(find.text('Erledigt'), findsNothing);
      expect(find.byType(Divider), findsNothing); // Kein Trennstrich
      expect(find.byType(TodoTile), findsNothing); // Keine Todo-Einträge
    });

    testWidgets('2. Add a new todo appears in "Offen" section', (
      WidgetTester tester,
    ) async {
      // Arrange: App starten
      await pumpToDoApp(tester);

      // Act: Floating Action Button tippen, um Dialog zu öffnen
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle(); // Warten bis Dialog erscheint

      // Act: Text eingeben und hinzufügen
      const newTodoTitle = 'Erstes Todo Testen';
      await tester.enterText(find.byType(TextField), newTodoTitle);
      await tester.tap(find.text('Hinzufügen'));
      await tester
          .pumpAndSettle(); // Warten bis Dialog schließt & Liste aktualisiert

      // Assert: Überprüfen
      expect(
        find.text('Füge deine erste Aufgabe hinzu!'),
        findsNothing,
      ); // Leer-Nachricht weg
      expect(find.text('Offen'), findsOneWidget); // Überschrift "Offen" da
      expect(
        find.text('Erledigt'),
        findsNothing,
      ); // Überschrift "Erledigt" nicht da
      expect(find.byType(Divider), findsNothing); // Kein Trennstrich
      expect(
        find.text(newTodoTitle),
        findsOneWidget,
      ); // Neuer Todo-Text sichtbar

      // Assert: Sicherstellen, dass das Todo im richtigen Abschnitt (unter "Offen") ist
      final openSectionFinder = find.ancestor(
        of: find.text('Offen'),
        matching: find.byType(Column), // Die Spalte der OpenTodosSection
      );
      final todoTileFinder = find.descendant(
        of: openSectionFinder,
        matching: find.text(newTodoTitle),
      );
      expect(todoTileFinder, findsOneWidget);
    });

    testWidgets('3. Toggle an open todo moves it to "Erledigt"', (
      WidgetTester tester,
    ) async {
      // Arrange: App starten und ein Todo hinzufügen
      await pumpToDoApp(tester);
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      const todoTitle = 'Todo zum Umschalten';
      await tester.enterText(find.byType(TextField), todoTitle);
      await tester.tap(find.text('Hinzufügen'));
      await tester.pumpAndSettle();

      // Act: Checkbox des Todos finden und tippen
      // Finde das TodoTile anhand des Textes und dann die Checkbox darin
      final todoTileFinder = find.ancestor(
        of: find.text(todoTitle),
        matching: find.byType(TodoTile),
      );
      final checkboxFinder = find.descendant(
        of: todoTileFinder,
        matching: find.byType(Checkbox),
      );
      expect(
        checkboxFinder,
        findsOneWidget,
      ); // Sicherstellen, dass wir sie finden
      await tester.tap(checkboxFinder);
      await tester.pumpAndSettle(); // Warten auf UI-Update

      // Assert: Überprüfen
      expect(find.text('Offen'), findsNothing); // "Offen" sollte weg sein
      expect(
        find.text('Erledigt'),
        findsOneWidget,
      ); // "Erledigt" sollte da sein
      expect(find.text(todoTitle), findsOneWidget); // Text noch da
      expect(find.byType(Divider), findsNothing); // Immer noch kein Trennstrich

      // Assert: Sicherstellen, dass das Todo im "Erledigt"-Abschnitt ist
      final completedSectionFinder = find.ancestor(
        of: find.text('Erledigt'),
        matching: find.byType(Column), // Die Spalte der CompletedTodosSection
      );
      final todoInCompletedFinder = find.descendant(
        of: completedSectionFinder,
        matching: find.text(todoTitle),
      );
      expect(todoInCompletedFinder, findsOneWidget);

      // Optional: Checkbox-Status prüfen
      final checkboxWidget = tester.widget<Checkbox>(checkboxFinder);
      expect(checkboxWidget.value, isTrue); // Sollte jetzt angehakt sein
    });

    testWidgets('4. Toggle a completed todo moves it back to "Offen"', (
      WidgetTester tester,
    ) async {
      // Arrange: App starten, Todo hinzufügen, Todo umschalten
      await pumpToDoApp(tester);
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      const todoTitle = 'Todo zurück umschalten';
      await tester.enterText(find.byType(TextField), todoTitle);
      await tester.tap(find.text('Hinzufügen'));
      await tester.pumpAndSettle();
      // Finde Checkbox und tippe sie (wie in Test 3)
      final todoTileFinder = find.ancestor(
        of: find.text(todoTitle),
        matching: find.byType(TodoTile),
      );
      final checkboxFinder = find.descendant(
        of: todoTileFinder,
        matching: find.byType(Checkbox),
      );
      await tester.tap(checkboxFinder);
      await tester.pumpAndSettle();
      // Kurze Prüfung, ob es in "Erledigt" ist
      expect(find.text('Erledigt'), findsOneWidget);

      // Act: Checkbox erneut tippen
      await tester.tap(checkboxFinder);
      await tester.pumpAndSettle();

      // Assert: Überprüfen
      expect(find.text('Offen'), findsOneWidget); // "Offen" wieder da
      expect(find.text('Erledigt'), findsNothing); // "Erledigt" weg
      expect(find.text(todoTitle), findsOneWidget); // Text noch da
      expect(find.byType(Divider), findsNothing);

      // Assert: Sicherstellen, dass das Todo wieder im "Offen"-Abschnitt ist
      final openSectionFinder = find.ancestor(
        of: find.text('Offen'),
        matching: find.byType(Column),
      );
      final todoInOpenFinder = find.descendant(
        of: openSectionFinder,
        matching: find.text(todoTitle),
      );
      expect(todoInOpenFinder, findsOneWidget);

      // Optional: Checkbox-Status prüfen
      final checkboxWidget = tester.widget<Checkbox>(checkboxFinder);
      expect(checkboxWidget.value, isFalse); // Sollte nicht mehr angehakt sein
    });

    testWidgets('5. Delete an open todo removes it', (
      WidgetTester tester,
    ) async {
      // Arrange: App starten und ein Todo hinzufügen
      await pumpToDoApp(tester);
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      const todoTitle = 'Todo zum Löschen';
      await tester.enterText(find.byType(TextField), todoTitle);
      await tester.tap(find.text('Hinzufügen'));
      await tester.pumpAndSettle();
      expect(
        find.text(todoTitle),
        findsOneWidget,
      ); // Sicherstellen, dass es da ist

      // Act: Delete-Button finden und tippen
      final todoTileFinder = find.ancestor(
        of: find.text(todoTitle),
        matching: find.byType(TodoTile),
      );
      final deleteButtonFinder = find.descendant(
        of: todoTileFinder,
        matching: find.byIcon(Icons.delete),
      );
      expect(deleteButtonFinder, findsOneWidget);
      await tester.tap(deleteButtonFinder);
      await tester.pumpAndSettle(); // Warten auf UI-Update

      // Assert: Überprüfen
      expect(find.text(todoTitle), findsNothing); // Todo ist weg
      expect(
        find.text('Füge deine erste Aufgabe hinzu!'),
        findsOneWidget,
      ); // Leer-Nachricht wieder da
      expect(find.text('Offen'), findsNothing);
      expect(find.text('Erledigt'), findsNothing);
    });

    testWidgets('6. Delete a completed todo removes it', (
      WidgetTester tester,
    ) async {
      // Arrange: App starten, Todo hinzufügen, Todo umschalten
      await pumpToDoApp(tester);
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      const todoTitle = 'Erledigtes Todo löschen';
      await tester.enterText(find.byType(TextField), todoTitle);
      await tester.tap(find.text('Hinzufügen'));
      await tester.pumpAndSettle();
      // Umschalten
      final todoTileFinder = find.ancestor(
        of: find.text(todoTitle),
        matching: find.byType(TodoTile),
      );
      final checkboxFinder = find.descendant(
        of: todoTileFinder,
        matching: find.byType(Checkbox),
      );
      await tester.tap(checkboxFinder);
      await tester.pumpAndSettle();
      expect(
        find.text('Erledigt'),
        findsOneWidget,
      ); // Sicherstellen, dass es erledigt ist

      // Act: Delete-Button finden und tippen (Finder ist noch gültig)
      final deleteButtonFinder = find.descendant(
        of: todoTileFinder,
        matching: find.byIcon(Icons.delete),
      );
      expect(deleteButtonFinder, findsOneWidget);
      await tester.tap(deleteButtonFinder);
      await tester.pumpAndSettle();

      // Assert: Überprüfen
      expect(find.text(todoTitle), findsNothing); // Todo ist weg
      expect(
        find.text('Füge deine erste Aufgabe hinzu!'),
        findsOneWidget,
      ); // Leer-Nachricht wieder da
      expect(find.text('Offen'), findsNothing);
      expect(find.text('Erledigt'), findsNothing);
    });

    testWidgets('7. Divider appears when both sections have todos', (
      WidgetTester tester,
    ) async {
      // Arrange: App starten
      await pumpToDoApp(tester);

      // Arrange: Erstes Todo hinzufügen (bleibt offen)
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      const openTodoTitle = 'Offenes Todo';
      await tester.enterText(find.byType(TextField), openTodoTitle);
      await tester.tap(find.text('Hinzufügen'));
      await tester.pumpAndSettle();

      // Arrange: Zweites Todo hinzufügen
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      const completedTodoTitle = 'Erledigtes Todo';
      await tester.enterText(find.byType(TextField), completedTodoTitle);
      await tester.tap(find.text('Hinzufügen'));
      await tester.pumpAndSettle();

      // Arrange: Zweites Todo umschalten
      final todoTileFinder = find.ancestor(
        of: find.text(completedTodoTitle),
        matching: find.byType(TodoTile),
      );
      final checkboxFinder = find.descendant(
        of: todoTileFinder,
        matching: find.byType(Checkbox),
      );
      await tester.tap(checkboxFinder);
      await tester.pumpAndSettle();

      // Assert: Überprüfen
      expect(find.text('Offen'), findsOneWidget);
      expect(find.text('Erledigt'), findsOneWidget);
      expect(find.text(openTodoTitle), findsOneWidget);
      expect(find.text(completedTodoTitle), findsOneWidget);
      expect(
        find.byType(Divider),
        findsOneWidget,
      ); // Jetzt sollte der Trennstrich da sein!
    });
  });
}

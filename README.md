# Todo App mit Provider

Eine einfache To-Do-Listen-Anwendung, die das `provider`-Paket für das State Management in Flutter demonstriert. Der Fokus liegt auf der funktionalen Implementierung und einer sauberen Code-Struktur gemäß den Best Practices für Provider.

![Screenshot 2025-04-09 at 13 15 31](https://github.com/user-attachments/assets/ae75c4a8-627e-4e04-9649-db9e85886488)

## Funktionen

*   Hinzufügen neuer Aufgaben über einen Dialog (Floating Action Button).
*   Anzeigen von Aufgaben in getrennten Abschnitten: "Offen" und "Erledigt".
*   Markieren von Aufgaben als erledigt (Checkbox), was sie visuell in den "Erledigt"-Abschnitt verschiebt.
*   Rückgängigmachen des Erledigt-Status, was die Aufgabe zurück in den "Offen"-Abschnitt verschiebt.
*   Löschen von Aufgaben über einen Löschen-Button pro Eintrag.
*   Anzeige einer Nachricht, wenn keine Aufgaben vorhanden sind.
*   Ein visueller Trenner (`Divider`) wird nur angezeigt, wenn sowohl offene als auch erledigte Aufgaben vorhanden sind.

## Technische Details

*   **State Management:** Verwendet das `provider`-Paket (`ChangeNotifierProvider`, `ChangeNotifier`, `Consumer`, `context.read`). Der `TodoNotifier` verwaltet den Zustand der Aufgabenliste.
*   **Architektur:**
    *   Modularer Aufbau mit ausgelagerten Widgets für eine bessere Lesbarkeit und Wartbarkeit (z.B. `OpenTodosSection`, `CompletedTodosSection`, `TodoTile`, `AddTodoDialog`, `EmptyListMessage`).
    *   Verwendung von Callbacks (`ValueChanged<Todo>`, `VoidCallback`) zur Entkopplung der UI-Komponenten vom State Management (`TodoNotifier`). Die Widgets erhalten nur die Daten und Funktionen, die sie benötigen.
*   **Tests:** Enthält Widget-Tests (`test/widget_test.dart`), die die Kernfunktionalitäten abdecken (Hinzufügen, Umschalten, Löschen, Anzeige der verschiedenen Zustände).

## Projektstruktur

<details>
<summary><strong>Projektbaum anzeigen</strong></summary>

```txt
lib/
├── app/
│   └── to_do_app.dart                         # App-Konfiguration & Provider-Setup
├── features/
│   └── to_do_list/                            # Feature: To-Do-Liste
│       ├── data/
│       │   └── todo_notifier.dart             # ChangeNotifier für die Verwaltung der To-Dos
│       ├── models/
│       │   └── todo.dart                      # Datenmodell für ein einzelnes To-Do
│       ├── screens/
│       │   └── todo_home_page.dart            # Hauptseite der App mit Listenanzeige
│       └── widgets/
│           ├── add_todo_dialog.dart           # Dialog zum Hinzufügen eines neuen To-Dos
│           ├── completed_todos_section.dart   # Abschnitt für erledigte Aufgaben
│           ├── empty_list_message.dart        # Hinweis bei leerer Liste
│           ├── open_todos_section.dart        # Abschnitt für offene Aufgaben
│           └── todo_tile.dart                 # Darstellung eines einzelnen To-Do-Eintrags
├── main.dart  

```
</details>



import 'package:flutter/material.dart';
import 'package:todo_provider_app/features/to_do_list/models/todo.dart';

class TodoNotifier extends ChangeNotifier {
  final List<Todo> _todos = [];

  // Getter für offene Todos
  List<Todo> get openTodos =>
      List.unmodifiable(_todos.where((todo) => !todo.isDone));

  // Getter für erledigte Todos
  List<Todo> get completedTodos =>
      List.unmodifiable(_todos.where((todo) => todo.isDone));

  void addTodo(String title) {
    _todos.add(Todo(id: DateTime.now().toString(), title: title));
    // Sortieren, damit neue immer oben bei "Offen" erscheinen
    _todos.sort((a, b) => a.isDone == b.isDone ? 0 : (a.isDone ? 1 : -1));
    notifyListeners();
  }

  void toggleTodo(Todo todo) {
    // Finde das Todo in der Liste anhand der ID, um sicherzustellen,
    // dass wir das Original ändern.
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      _todos[index].isDone = !_todos[index].isDone;
      // Neu sortieren, damit es in die richtige Sektion wandert
      _todos.sort((a, b) => a.isDone == b.isDone ? 0 : (a.isDone ? 1 : -1));
      notifyListeners();
    }
  }

  void removeTodo(Todo todo) {
    _todos.removeWhere((t) => t.id == todo.id);
    notifyListeners(); // Sortieren nicht nötig beim Entfernen
  }
}

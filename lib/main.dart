import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_provider_app/app/to_do_app.dart';
import 'package:todo_provider_app/features/to_do_list/data/todo_notifier.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TodoNotifier(),
      child: const ToDoApp(),
    ),
  );
}

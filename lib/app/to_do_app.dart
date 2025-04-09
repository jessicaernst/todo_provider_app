import 'package:flutter/material.dart';
import 'package:todo_provider_app/features/to_do_list/screens/todo_home_page.dart';

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ToDoHomePage(title: 'To-Do List'),
    );
  }
}

import 'package:app_todo_gemini/env.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

const basePrompt =
    'Create a list of cleaning tasks from the following prompt, where each item is output in a list where each item is the todo description itself. Do not include any other text. Here is the one word prompt:';

final model = GenerativeModel(
  model: 'gemini-1.5-flash-latest',
  apiKey: Env.apiKey,
);

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final Set<String> messages = {};
  final List<String> todos = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // TODO: Add AppBar
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              /// TODO: Add title with theme headlineLarge
              _TodoList(todos: todos),

              /// TODO: Add title with theme headlineLarge
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Enter a prompt',
                ),
                onSubmitted: _generatePrompts,
              ),
              Expanded(
                child: _ListPrompts(messages: messages.toList()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Generate the prompts and add the todos to the list
  void _generatePrompts(String prompt) async {
    final content = [Content.text('$basePrompt $prompt')];
    final response = await model.generateContent(content);
    _processPrompt(response.text);
  }

  /// Process the prompt and add the todos to the list
  void _processPrompt(String? text) {
    messages.clear();
    final list = text?.split('\n');
    for (var element in list ?? []) {
      messages.add(element);
    }
    setState(() {});
  }

  /// Add a todo to the list
  /// TODO: Add onTap to remove the todo
  void _addTodo(String message) {
    setState(() {
      todos.add(message);
      messages.remove(message);
    });
  }

  /// Remove a todo from the list
  /// TODO: Add onTap to remove the todo
  void _removeTodo(String todo) {
    setState(() {
      todos.remove(todo);
    });
  }
}

class _ListPrompts extends StatelessWidget {
  final List<String> messages;

  const _ListPrompts({required this.messages});

  String messageAtIndex(int index) => messages[index];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(messages.toList()[index]),
        // TODO: Add onTap to add the todo
      ),
    );
  }
}

class _TodoList extends StatelessWidget {
  const _TodoList({
    required this.todos,
  });

  final List<String> todos;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(todos[index]),
        // TODO: Add onTap to remove the todo
      ),
    );
  }
}

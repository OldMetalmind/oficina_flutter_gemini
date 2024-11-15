import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

const basePrompt =
    'Create a list of cleaning tasks from the following prompt, where each item is output in a list where each item is the todo description itself. Do not include any other text. Here is the one word prompt:';

final model = GenerativeModel(
  model: 'gemini-1.5-flash-latest',
  apiKey: '<API_KEY>',
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
      theme: FlexThemeData.light(scheme: FlexScheme.outerSpace),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Cleaning Tasks App'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                'Todos',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(todos[index]),
                    onTap: () => _removeTodo(todos[index]),
                  ),
                ),
              ),
              Text(
                'Create Tasks',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Enter a prompt',
                ),
                onSubmitted: _generatePrompts,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages.toList()[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.all(3),
                      title: Text(message),
                      onTap: () => _addTodo(message),
                    );
                  },
                ),
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
  void _addTodo(String message) {
    todos.add(message);
    messages.remove(message);
    setState(() {});
  }

  /// Remove a todo from the list
  void _removeTodo(String todo) {
    todos.remove(todo);
    setState(() {});
  }
}

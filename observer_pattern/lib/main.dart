import 'package:flutter/material.dart';

import 'counter_controller.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final CounterController _counterController = CounterController();

  @override
  void dispose() {
    _counterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Stream Counter')),
        body: Center(
          child: StreamBuilder<int>(
            stream: _counterController.counterStream,
            initialData: 0,
            builder: (context, snapshot) {
              return Text(
                '${snapshot.data}',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                _counterController.eventSink.add(EventType.decrement);
              },
              heroTag: 'decrement',
              child: const Icon(Icons.remove),
            ),
            const SizedBox(width: 12),
            FloatingActionButton(
              onPressed: () {
                _counterController.eventSink.add(EventType.increment);
              },
              heroTag: 'increment',
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}

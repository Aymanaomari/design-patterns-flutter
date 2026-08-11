import 'package:flutter/material.dart';

import 'game_manager.dart';
import 'timer_handler.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const GameOfLifePage(),
    );
  }
}

class GameOfLifePage extends StatefulWidget {
  const GameOfLifePage({super.key});

  @override
  State<GameOfLifePage> createState() => _GameOfLifePageState();
}

class _GameOfLifePageState extends State<GameOfLifePage> {
  static const int _boardColumns = 20;
  static const int _boardRows = 20;
  static const Duration _tickDuration = Duration(milliseconds: 250);

  final GameManager _gameManager = GameManager();
  late final TimerHandler _timerHandler;

  @override
  void initState() {
    super.initState();
    _gameManager.initialize(
      const GameConfiguration(columns: _boardColumns, rows: _boardRows),
    );

    _timerHandler = TimerHandler(
      interval: _tickDuration,
      onTick: () {
        if (!mounted) {
          return;
        }

        setState(() {
          _gameManager.next();
        });
      },
    );
  }

  @override
  void dispose() {
    _timerHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Colors.white,
                height: 300,
                width: 300,
                child: GridView.builder(
                  itemCount: _gameManager.cells.length,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _gameManager.columns,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    return _gameManager.cells[index];
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text('Step: ${_gameManager.steps}'),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _gameManager.canPrevious
                        ? () {
                            setState(() {
                              _gameManager.previous();
                            });
                          }
                        : null,
                    child: const Text('Previous'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _gameManager.next();
                      });
                    },
                    child: const Text('Next'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _timerHandler.toggle();
                      });
                    },
                    child: Text(_timerHandler.isRunning ? 'Pause' : 'Play'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

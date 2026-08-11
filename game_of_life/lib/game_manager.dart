import 'dart:collection';
import 'dart:math';

import 'cell.dart';

class GameManager {
  GameManager._();

  static final GameManager _instance = GameManager._();

  factory GameManager() => _instance;

  final _GameHistory _history = _GameHistory();
  List<Cell> _cells = <Cell>[];
  int _columns = 0;
  int _steps = 0;

  UnmodifiableListView<Cell> get cells => UnmodifiableListView(_cells);
  int get steps => _steps;
  int get columns => _columns;
  int get rows => _columns == 0 ? 0 : _cells.length ~/ _columns;
  bool get canPrevious => _history.hasStates;

  void initialize(GameConfiguration configuration) {
    assert(configuration.columns > 0, 'columns must be greater than 0');
    assert(configuration.rows > 0, 'rows must be greater than 0');

    _columns = configuration.columns;
    _cells = _buildInitialCells(configuration);
    _steps = 0;
    _history.clear();
  }

  void next() {
    if (_cells.isEmpty) {
      return;
    }

    _history.push(_GameMemento(cells: _encodeCells(_cells), steps: _steps));

    final nextCells = List<Cell>.generate(_cells.length, (index) {
      return _cells[index].toNextState(_buildCellContext(index));
    });

    _cells = nextCells;
    _steps++;
  }

  bool previous() {
    final previousState = _history.pop();
    if (previousState == null) {
      return false;
    }

    _cells = _decodeCells(previousState.cells);
    _steps = previousState.steps;
    return true;
  }

  List<Cell> _buildInitialCells(GameConfiguration configuration) {
    final random = configuration.seed == null
        ? Random()
        : Random(configuration.seed);
    final totalCells = configuration.columns * configuration.rows;

    return List<Cell>.generate(totalCells, (_) {
      final isAlive = random.nextDouble() < configuration.initialAliveRatio;
      return isAlive ? const AlivedCell() : const DeadCell();
    }, growable: false);
  }

  CellContext _buildCellContext(int index) {
    final neighbors = _neighborIndexes(
      index,
    ).map((neighborIndex) => _cells[neighborIndex]).toList(growable: false);

    return CellContext(neighbors: neighbors);
  }

  List<int> _neighborIndexes(int index) {
    final row = index ~/ _columns;
    final column = index % _columns;

    final neighborIndexes = <int>[];

    for (var rowOffset = -1; rowOffset <= 1; rowOffset++) {
      for (var columnOffset = -1; columnOffset <= 1; columnOffset++) {
        if (rowOffset == 0 && columnOffset == 0) {
          continue;
        }

        final neighborRow = row + rowOffset;
        final neighborColumn = column + columnOffset;

        if (neighborRow < 0 ||
            neighborRow >= rows ||
            neighborColumn < 0 ||
            neighborColumn >= _columns) {
          continue;
        }

        final neighborIndex = (neighborRow * _columns) + neighborColumn;
        neighborIndexes.add(neighborIndex);
      }
    }

    return neighborIndexes;
  }

  List<bool> _encodeCells(List<Cell> cells) {
    return cells.map((cell) => cell is AlivedCell).toList(growable: false);
  }

  List<Cell> _decodeCells(List<bool> aliveStates) {
    return aliveStates
        .map((isAlive) => isAlive ? const AlivedCell() : const DeadCell())
        .toList(growable: false);
  }
}

class _GameMemento {
  const _GameMemento({required this.cells, required this.steps});

  final List<bool> cells;
  final int steps;
}

class _GameHistory {
  final List<_GameMemento> _states = <_GameMemento>[];

  bool get hasStates => _states.isNotEmpty;

  void push(_GameMemento state) {
    _states.add(state);
  }

  void clear() {
    _states.clear();
  }

  _GameMemento? pop() {
    if (_states.isEmpty) {
      return null;
    }

    return _states.removeLast();
  }
}

class GameConfiguration {
  const GameConfiguration({
    required this.columns,
    required this.rows,
    this.initialAliveRatio = 0.30,
    this.seed,
  }) : assert(
         initialAliveRatio >= 0 && initialAliveRatio <= 1,
         'initialAliveRatio should be between 0 and 1',
       );

  final int columns;
  final int rows;
  final double initialAliveRatio;
  final int? seed;
}

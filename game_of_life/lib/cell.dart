import 'package:flutter/material.dart';

abstract class Cell extends StatelessWidget {
  const Cell({super.key});

  Cell toNextState(CellContext cellContext);
}

class AlivedCell extends Cell {
  const AlivedCell({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.grey);
  }

  @override
  Cell toNextState(CellContext cellContext) {
    if (cellContext.has2Or3AliveNeighbors) {
      return const AlivedCell();
    }

    return const DeadCell();
  }
}

class DeadCell extends Cell {
  const DeadCell({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.black);
  }

  @override
  Cell toNextState(CellContext cellContext) {
    if (cellContext.hasExactlyAliveNeighbors(3)) {
      return const AlivedCell();
    }

    return const DeadCell();
  }
}

class CellContext {
  CellContext({required List<Cell> neighbors})
    : _neighbors = List<Cell>.unmodifiable(neighbors);

  final List<Cell> _neighbors;

  List<Cell> get neighbors => _neighbors;

  int get aliveNeighborsCount => _neighbors.whereType<AlivedCell>().length;

  bool hasExactlyAliveNeighbors(int count) {
    return aliveNeighborsCount == count;
  }

  bool get has2Or3AliveNeighbors {
    return hasExactlyAliveNeighbors(2) || hasExactlyAliveNeighbors(3);
  }
}

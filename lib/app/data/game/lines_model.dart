import 'package:flutter/material.dart';

enum BallColor {
  red,
  green,
  blue,
  yellow,
  none
}

class Ball {
  final BallColor color;
  
  Ball({this.color = BallColor.none});
  
  bool get isEmpty => color == BallColor.none;
  
  Color get displayColor {
    switch (color) {
      case BallColor.red:
        return Colors.red;
      case BallColor.green:
        return Colors.green;
      case BallColor.blue:
        return Colors.blue;
      case BallColor.yellow:
        return Colors.yellow;
      case BallColor.none:
        return Colors.transparent;
    }
  }
}

class LinesModel {
  static const int gridSize = 7;
  static const int minLineLength = 5;
  
  List<List<Ball>> grid;
  List<Ball> nextBalls;
  int score;
  
  LinesModel()
      : grid = List.generate(
          gridSize,
          (i) => List.generate(
            gridSize,
            (j) => Ball(),
          ),
        ),
        nextBalls = [],
        score = 0;

  bool isValidPosition(int row, int col) {
    return row >= 0 && row < gridSize && col >= 0 && col < gridSize;
  }

  bool isCellEmpty(int row, int col) {
    return grid[row][col].isEmpty;
  }

  void clear() {
    grid = List.generate(
      gridSize,
      (i) => List.generate(
        gridSize,
        (j) => Ball(),
      ),
    );
    nextBalls = [];
    score = 0;
  }
}
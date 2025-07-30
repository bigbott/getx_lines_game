import 'package:flutter/material.dart';
import 'package:getx_lines_game/app/data/value_locator.dart';

enum BallColor {
  red,
  green,
  blue,
  yellow,
  pink,
  black,
  none
}

class Ball {
  final BallColor color;
  
  Ball({this.color = BallColor.none});
  
  bool get isEmpty => color == BallColor.none;
  
  Color get displayColor {
    switch (color) {
      case BallColor.red:
        return Colors.red.shade500;
      case BallColor.green:
        return Colors.green.shade700;
      case BallColor.blue:
        return Colors.blue.shade700;
      case BallColor.yellow:
        return Colors.yellow.shade900;
       case BallColor.pink:
        return Colors.pink.shade900;
      case BallColor.black:
        return Colors.black54;  
      case BallColor.none:
        return Colors.transparent;
    }
  }
}

class LinesModel {
  //static const int gridSize = 7;
  static final int gridWidth = VL.find(VL.GRID_WIDTH);
  static final int gridHeight =  VL.find(VL.GRID_HEIGHT);
  static const int minLineLength = 5;
  
  List<List<Ball>> grid;
  List<Ball> nextBalls;
  int score;
  
  LinesModel()
      : grid = List.generate(
          gridWidth,
          (i) => List.generate(
            gridHeight,
            (j) => Ball(),
          ),
        ),
        nextBalls = [],
        score = 0;

  bool isValidPosition(int row, int col) {
    return row >= 0 && row < gridWidth && col >= 0 && col < gridHeight;
  }

  bool isCellEmpty(int row, int col) {
    return grid[row][col].isEmpty;
  }

  void clear() {
    grid = List.generate(
      gridWidth,
      (i) => List.generate(
        gridHeight,
        (j) => Ball(),
      ),
    );
    nextBalls = [];
    score = 0;
  }
}
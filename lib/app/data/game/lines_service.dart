import 'dart:math' as math;
import 'lines_model.dart';

class LinesService {
  final _random = math.Random();

  List<List<bool>> _visited = [];
  List<List<int>> _pathfindingGrid = [];

  void _initPathfinding() {
    _visited = List.generate(
      LinesModel.gridWidth,
      (i) => List.generate(LinesModel.gridHeight, (j) => false),
    );
    _pathfindingGrid = List.generate(
      LinesModel.gridWidth,
      (i) => List.generate(LinesModel.gridHeight, (j) => -1),
    );
  }

  BallColor _getRandomColor() {
    final colors = [
      BallColor.red,
      BallColor.green,
      BallColor.blue,
      BallColor.yellow,
    ];
    return colors[_random.nextInt(colors.length)];
  }

  void generateNextBalls(LinesModel model, int count) {
    model.nextBalls = List.generate(count, (index) => Ball(color: _getRandomColor()));
  }

  ({bool hasLines,  int removedCount}) placeBalls(LinesModel model) {
    if (model.nextBalls.isEmpty) return (hasLines:true, removedCount: 0);

    for (var ball in model.nextBalls) {
      bool placed = false;
      while (!placed) {
        int row = _random.nextInt(LinesModel.gridWidth);
        int col = _random.nextInt(LinesModel.gridHeight);
        
        if (model.isCellEmpty(row, col)) {
          model.grid[row][col] = ball;
          placed = true;
        }
      }
    }
    model.nextBalls.clear();
    return checkLines(model);
  }

  bool canMove(LinesModel model, int fromRow, int fromCol, int toRow, int toCol) {
    if (!model.isValidPosition(fromRow, fromCol) ||
        !model.isValidPosition(toRow, toCol)) {
      return false;
    }

    if (!model.isCellEmpty(toRow, toCol)) {
      return false;
    }

    _initPathfinding();
    return _findPath(model, fromRow, fromCol, toRow, toCol);
  }

  bool _findPath(LinesModel model, int startRow, int startCol, int endRow, int endCol) {
    List<List<int>> queue = [[startRow, startCol]];
    _pathfindingGrid[startRow][startCol] = 0;

    final directions = [
      [-1, 0], // up
      [1, 0],  // down
      [0, -1], // left
      [0, 1],  // right
    ];

    while (queue.isNotEmpty) {
      var current = queue.removeAt(0);
      int row = current[0];
      int col = current[1];

      if (row == endRow && col == endCol) {
        return true;
      }

      for (var dir in directions) {
        int newRow = row + dir[0];
        int newCol = col + dir[1];

        if (model.isValidPosition(newRow, newCol) &&
            _pathfindingGrid[newRow][newCol] == -1 &&
            (model.isCellEmpty(newRow, newCol) ||
                (newRow == endRow && newCol == endCol))) {
          queue.add([newRow, newCol]);
          _pathfindingGrid[newRow][newCol] = _pathfindingGrid[row][col] + 1;
        }
      }
    }

    return false;
  }

  ({bool hasLines, int removedCount}) checkLines(LinesModel model) {
    bool hasLines = false;
    List<List<bool>> toRemove = List.generate(
      LinesModel.gridWidth,
      (i) => List.generate(LinesModel.gridHeight, (j) => false),
    );

    // Check horizontal lines
    for (int row = 0; row < LinesModel.gridWidth; row++) {
      for (int col = 0; col <= LinesModel.gridHeight - LinesModel.minLineLength; col++) {
        if (model.grid[row][col].isEmpty) continue;
        
        int length = 1;
        BallColor color = model.grid[row][col].color;
        
        for (int k = 1; k < LinesModel.gridHeight - col; k++) {
          if (model.grid[row][col + k].color == color) {
            length++;
          } else {
            break;
          }
        }
        
        if (length >= LinesModel.minLineLength) {
          hasLines = true;
          for (int k = 0; k < length; k++) {
            toRemove[row][col + k] = true;
          }
        }
      }
    }

    // Check vertical lines
    for (int col = 0; col < LinesModel.gridHeight; col++) {
      for (int row = 0; row <= LinesModel.gridWidth - LinesModel.minLineLength; row++) {
        if (model.grid[row][col].isEmpty) continue;
        
        int length = 1;
        BallColor color = model.grid[row][col].color;
        
        for (int k = 1; k < LinesModel.gridWidth - row; k++) {
          if (model.grid[row + k][col].color == color) {
            length++;
          } else {
            break;
          }
        }
        
        if (length >= LinesModel.minLineLength) {
          hasLines = true;
          for (int k = 0; k < length; k++) {
            toRemove[row + k][col] = true;
          }
        }
      }
    }

    // Check diagonal lines (top-left to bottom-right)
    for (int row = 0; row <= LinesModel.gridWidth - LinesModel.minLineLength; row++) {
      for (int col = 0; col <= LinesModel.gridHeight - LinesModel.minLineLength; col++) {
        if (model.grid[row][col].isEmpty) continue;
        
        int length = 1;
        BallColor color = model.grid[row][col].color;
        
        for (int k = 1; k < math.min(LinesModel.gridWidth - row, LinesModel.gridHeight - col); k++) {
          if (model.grid[row + k][col + k].color == color) {
            length++;
          } else {
            break;
          }
        }
        
        if (length >= LinesModel.minLineLength) {
          hasLines = true;
          for (int k = 0; k < length; k++) {
            toRemove[row + k][col + k] = true;
          }
        }
      }
    }

    // Check diagonal lines (top-right to bottom-left)
    for (int row = 0; row <= LinesModel.gridWidth - LinesModel.minLineLength; row++) {
      for (int col = LinesModel.minLineLength - 1; col < LinesModel.gridHeight; col++) {
        if (model.grid[row][col].isEmpty) continue;
        
        int length = 1;
        BallColor color = model.grid[row][col].color;
        
        for (int k = 1; k < math.min(LinesModel.gridWidth - row, col + 1); k++) {
          if (model.grid[row + k][col - k].color == color) {
            length++;
          } else {
            break;
          }
        }
        
        if (length >= LinesModel.minLineLength) {
          hasLines = true;
          for (int k = 0; k < length; k++) {
            toRemove[row + k][col - k] = true;
          }
        }
      }
    }

    // Remove matched balls and update score
    int removedCount = 0;
    if (hasLines) {
      
      for (int i = 0; i < LinesModel.gridWidth; i++) {
        for (int j = 0; j < LinesModel.gridHeight; j++) {
          if (toRemove[i][j]) {
            model.grid[i][j] = Ball();
            removedCount++;
          }
        }
      }
      int scoreIncrement = calculateScoreIncrement(removedCount);
      
      model.score += removedCount * scoreIncrement;
    }
    print("Final removedCount: $removedCount");

    return  ( hasLines:hasLines,  removedCount:removedCount);
  }

  bool isGameOver(LinesModel model) {
    int emptyCount = 0;
    for (int i = 0; i < LinesModel.gridWidth; i++) {
      for (int j = 0; j < LinesModel.gridHeight; j++) {
        if (model.isCellEmpty(i, j)) {
          emptyCount++;
        }
      }
    }
    return emptyCount < 3; // Need at least 3 empty cells for next balls
  }
  
  // Method to expose the pathfinding grid
  List<List<int>> getPathfindingGrid() {
    return List.from(_pathfindingGrid);
  }
  
  int calculateScoreIncrement(int removedCount) {
    if (removedCount == 6){
      return 11;
    }
     if (removedCount == 7){
      return 12;
    }
    if (removedCount == 8){
      return 13;
    }
    if (removedCount == 9){
      return 14;
    }
    if (removedCount == 10){
      return 15;
    }
    return 10;
  }
}
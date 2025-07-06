import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_lines_game/app/data/game/lines_model.dart';
import 'package:getx_lines_game/app/data/game/lines_service.dart';
import 'package:getx_lines_game/app/data/leaderboard/leaderboard_service.dart';
import 'package:getx_lines_game/common/localdb/shared_preferences.dart';
import 'package:getx_lines_game/common/utils/nickname_generator.dart';
import 'package:getx_lines_game/common/utils/userid_generator.dart';


class GameController extends GetxController with SingleGetTickerProviderMixin {
  final LinesService _service;
  final LeaderboardService _leaderboardService;
  LinesModel _model = LinesModel();

  int bestScore = 0;
  int topScore = 0;

  Ball? selectedBall;
  int? selectedRow;
  int? selectedCol;
  
  // Animation controller for the pulsating effect
  AnimationController? _animationController;

  String? userId;
  String? nickname;
  
  bool isTest = true;

  GameController(this._service, this._leaderboardService);

  LinesModel get model => _model;
  List<List<Ball>> get grid => _model.grid;
  List<Ball> get nextBalls => _model.nextBalls;
  int get score => _model.score;

  @override
  void onInit() async {
    super.onInit();
    
    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    // Make it repeat in both directions
    _animationController!.repeat(reverse: true);
    
    await _initializeUser();
    await _loadScores();
    startNewGame();
  }

  Future<void> _initializeUser() async {
    userId = SharedPrefs.getUserId();
    nickname = SharedPrefs.getNickname();

    if (userId == null || nickname == null) {
      userId = UserIdGenerator.generateUserId();
      nickname = NicknameGenerator.generate();

      await SharedPrefs.setUserId(userId!);
      await SharedPrefs.setNickname(nickname!);
    }
  }

  void startNewGame() {
    _model.clear();
    _generateNextBalls();
    _placeBalls();
    update();
  }

  void _generateNextBalls() {
    _service.generateNextBalls(_model, 3);
  }

  bool _placeBalls() {
    bool hasLines = _service.placeBalls(_model);
    // Always generate next balls if the game is not over, regardless of whether lines were formed
    if (!_service.isGameOver(_model)) {
      _generateNextBalls();
    }
    return hasLines;
  }

  void onCellTap(int row, int col) {
    if (_model.grid[row][col].isEmpty) {
      if (selectedBall != null && selectedRow != null && selectedCol != null) {
        _tryMove(row, col);
      }
    } else {
      _selectBall(row, col);
    }
    update();
  }

  void _selectBall(int row, int col) {
    // If there's already a selected ball, deselect it
    if (selectedRow != null && selectedCol != null) {
      // If clicking the same ball, deselect it
      if (selectedRow == row && selectedCol == col) {
        selectedBall = null;
        selectedRow = null;
        selectedCol = null;
        return;
      }
    }
    
    if (!_model.grid[row][col].isEmpty) {
      selectedBall = _model.grid[row][col];
      selectedRow = row;
      selectedCol = col;
    }
  }

  // Add these properties to GameController class
  List<List<int>> movePath = [];
  Ball? movingBall;
  int currentPathIndex = 0;
  Timer? moveTimer;
  bool isAnimating = false;
  
  // Modify _tryMove method to use animation
  void _tryMove(int toRow, int toCol) {
    if (selectedRow == null || selectedCol == null) return;
  
    if (_service.canMove(_model, selectedRow!, selectedCol!, toRow, toCol)) {
      // Get the path from service
      movePath = _getPath(selectedRow!, selectedCol!, toRow, toCol);
      
      if (movePath.isNotEmpty) {
        // Start animation
        movingBall = _model.grid[selectedRow!][selectedCol!];
        _model.grid[selectedRow!][selectedCol!] = Ball(); // Clear original position
        currentPathIndex = 0;
        isAnimating = true;
  
        // Start timer to animate through path
        moveTimer?.cancel();
        moveTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
          _animateAlongPath();
        });
  
        update(); // Update UI to show initial state
        return; // Exit early, we'll complete the move after animation
      }
    }
    
    // Clear selection if no animation started
    selectedBall = null;
    selectedRow = null;
    selectedCol = null;
    update();
  }
  
  // Add this method to animate along the path
  void _animateAlongPath() {
    if (currentPathIndex >= movePath.length) {
      // Animation complete
      moveTimer?.cancel();
      moveTimer = null;
  
      // Place ball at final position
      final destination = movePath.last;
      _model.grid[destination[0]][destination[1]] = movingBall!;
  
      // Check for lines and place new balls if needed
      bool hasLines = _service.checkLines(_model);
      if (!hasLines) {
        hasLines = _placeBalls();
      }
  
      // Check game over
      if (_service.isGameOver(_model)) {
        if (_model.score > bestScore) {
          bestScore = _model.score;
          _updateLeaderboard();
        }
        
        // If in test mode, remove user data from SharedPrefs
        if (isTest) {
          _removeUserData();
        }
        
        Get.snackbar(
          'Game Over',
          'Your score: ${_model.score}\nBest score: $bestScore',
          duration: const Duration(seconds: 3),
        );
      }
      
      // Clear animation state
      movePath = [];
      movingBall = null;
      isAnimating = false;
  
      // Clear selection
      selectedBall = null;
      selectedRow = null;
      selectedCol = null;
  
      update();
      return;
    }
    
    // Move to next position in path
    currentPathIndex++;
    update();
  }
  
  // Add this method to extract path from pathfinding grid
  List<List<int>> _getPath(int startRow, int startCol, int endRow, int endCol) {
    // First make sure we can find a path
    if (!_service.canMove(_model, startRow, startCol, endRow, endCol)) {
      return [];
    }
    
    // Get the pathfinding grid from service
    // Note: You'll need to modify LinesService to expose the pathfinding grid
    List<List<int>> grid = _service.getPathfindingGrid();
    
    // Reconstruct the path from end to start
    List<List<int>> path = [];
    int currentRow = endRow;
    int currentCol = endCol;
    path.add([currentRow, currentCol]);
    
    final directions = [
      [-1, 0], // up
      [1, 0],  // down
      [0, -1], // left
      [0, 1],  // right
    ];
    
    while (!(currentRow == startRow && currentCol == startCol)) {
      int currentValue = grid[currentRow][currentCol];
      bool found = false;
      
      for (var dir in directions) {
        int newRow = currentRow + dir[0];
        int newCol = currentCol + dir[1];
        
        if (_model.isValidPosition(newRow, newCol) && 
            grid[newRow][newCol] == currentValue - 1) {
          currentRow = newRow;
          currentCol = newCol;
          path.add([currentRow, currentCol]);
          found = true;
          break;
        }
      }
      
      if (!found) break; // No valid path found
    }
    
    // Reverse the path to go from start to end
    return path.reversed.toList();
  }

  @override
  void onClose() {
    moveTimer?.cancel();
    _animationController?.dispose();
    super.onClose();
  }


  Future<void> _loadScores() async {
    try {
      final scores = await _leaderboardService.loadItems();
      if (scores != null) {
        for (var doc in scores.documents) {
          if (doc.data['user_id'] == userId) {
            bestScore = doc.data['scores'] ?? 0;
          }
          if ((doc.data['scores'] ?? 0) > topScore) {
            topScore = doc.data['scores'];
          }
        }
      }
      update();
    } catch (e) {
      print('Error loading scores: $e');
    }
  }

  Future<void> _updateLeaderboard() async {
    try {
      // Use the new method to update user score only if it's higher than previous best
      await _leaderboardService.updateUserScore(
        userId!,
        nickname!,
        bestScore,
      );
      await _loadScores();
    } catch (e) {
      print('Error updating leaderboard: $e');
    }
  }
  
  Future<void> _removeUserData() async {
    try {
      await SharedPrefs.removeUserData();
      print('User data removed for test mode');
    } catch (e) {
      print('Error removing user data: $e');
    }
  }
  
  // Get the current animation value for scaling
  double get animationValue {
    if (_animationController == null) return 1.0;
    return 0.8 + (_animationController!.value * 0.4); // Scale between 0.8 and 1.2
  }
  
  // Expose the animation controller for the view
  AnimationController? get animationController => _animationController;
  
}

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

  void _tryMove(int toRow, int toCol) {
    if (selectedRow == null || selectedCol == null) return;

    if (_service.canMove(_model, selectedRow!, selectedCol!, toRow, toCol)) {
      // Move ball
      _model.grid[toRow][toCol] = _model.grid[selectedRow!][selectedCol!];
      _model.grid[selectedRow!][selectedCol!] = Ball();

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
    }

    // Clear selection
    selectedBall = null;
    selectedRow = null;
    selectedCol = null;
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
  
  @override
  void onClose() {
    _animationController?.dispose();
    super.onClose();
  }
}

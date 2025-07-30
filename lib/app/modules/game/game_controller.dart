import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:get/get.dart';
import 'package:getx_lines_game/app/data/appwrite_constants.dart';
import 'package:getx_lines_game/app/data/game/lines_model.dart';
import 'package:getx_lines_game/app/data/game/lines_service.dart';
import 'package:getx_lines_game/app/data/leaderboard/leaderboard_service.dart';
import 'package:getx_lines_game/app/data/stats/stats_service.dart';
import 'package:getx_lines_game/app/data/value_locator.dart';
import 'package:getx_lines_game/app/modules/game/widgets/tutorial_dialog.dart';
import 'package:getx_lines_game/common/audio/audio_assets.dart';
import 'package:getx_lines_game/common/audio/audio_player.dart';
import 'package:getx_lines_game/common/ez/ez_text.dart';
import 'package:getx_lines_game/common/localdb/shared_preferences.dart';
import 'package:getx_lines_game/common/utils/nickname_generator.dart';
import 'package:getx_lines_game/common/utils/userid_generator.dart';

class GameController extends GetxController with SingleGetTickerProviderMixin {
  final LinesService _service;
  final LeaderboardService _leaderboardService;
  final StatsService _statsService;
  final IAudioPlayer _audioPlayer;
  LinesModel _state = LinesModel();

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

  GameController(
      this._service, this._leaderboardService, this._statsService, this._audioPlayer);

  LinesModel get model => _state;
  List<List<Ball>> get grid => _state.grid;
  List<Ball> get nextBalls => _state.nextBalls;
  int get score => _state.score;

  bool isGameOver = false;

  SoundHandle? loopHandle;

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

    // If in test mode, remove user data from SharedPrefs
    if (isTest) {
      await _removeUserData();
    }

    await _initializeUser();
    await _loadScores();
    startNewGame();
  }

  Future<void> _initializeUser() async {
    userId = SharedPrefs.getUserId();
    nickname = SharedPrefs.getNickname();

    if (userId == null || nickname == null) {
      Get.dialog(const TutorialDialog());
      userId = UserIdGenerator.generateUserId();
      print('userId: ' + userId!);
      nickname = NicknameGenerator.generate();

      await SharedPrefs.setUserId(userId!);
      await SharedPrefs.setNickname(nickname!);
      await _leaderboardService.addPlayer(VL.find(VL.COLLECTION_ID), userId!, nickname!, 0);
    }
  }

  void startNewGame() {
    _state.clear();
    _generateNextBalls();
    _placeBalls();
    isGameOver = false;
    update();
  }

  void _generateNextBalls() {
    _service.generateNextBalls(_state, 3);
  }

  bool _placeBalls() {
    bool hasLines = _service.placeBalls(_state).hasLines;
    // Always generate next balls if the game is not over, regardless of whether lines were formed
    if (!_service.isGameOver(_state)) {
      _generateNextBalls();
    }
    return hasLines;
  }

  void onCellTap(int row, int col) {
    if (_state.grid[row][col].isEmpty) {
      if (selectedBall != null && selectedRow != null && selectedCol != null) {
        _tryMove(row, col);
      }
    } else {
      _selectBall(row, col);
    }
    update();
  }

  void _selectBall(int row, int col) async {
    // If there's already a selected ball, deselect it
    if (selectedRow != null && selectedCol != null) {
      // If clicking the same ball, deselect it
      if (selectedRow == row && selectedCol == col) {
        selectedBall = null;
        selectedRow = null;
        selectedCol = null;
        _audioPlayer.stop(loopHandle!);
        return;
      }
    }

    if (!_state.grid[row][col].isEmpty) {
      selectedBall = _state.grid[row][col];
      selectedRow = row;
      selectedCol = col;
      if (loopHandle != null) {
        _audioPlayer.stop(loopHandle!);
      }
      loopHandle = await _audioPlayer.loop(
        AudioAssets.ball_tap,
      );
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

    if (_service.canMove(_state, selectedRow!, selectedCol!, toRow, toCol)) {
      _audioPlayer.stop(loopHandle!);
      _audioPlayer.play(AudioAssets.ball_run);
      // Get the path from service
      movePath = _getPath(selectedRow!, selectedCol!, toRow, toCol);

      if (movePath.isNotEmpty) {
        // Start animation
        movingBall = _state.grid[selectedRow!][selectedCol!];
        _state.grid[selectedRow!][selectedCol!] = Ball(); // Clear original position
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
    } else {
     // _audioPlayer.stop(loopHandle!);
      _audioPlayer.play(AudioAssets.cannotmove);
    }

    // Clear selection if no animation started
   // selectedBall = null;
   // selectedRow = null;
   // selectedCol = null;
    update();
  }

  // Add this method to animate along the path
  void _animateAlongPath() async {
    if (currentPathIndex >= movePath.length) {
      // Animation complete
      moveTimer?.cancel();
      moveTimer = null;

      // Place ball at final position
      final destination = movePath.last;
      _state.grid[destination[0]][destination[1]] = movingBall!;

      // Check for lines and place new balls if needed
      var result = _service.checkLines(_state);
      bool hasLines = result.hasLines;
      int removedCount = result.removedCount;
      if (removedCount > 0){
        _audioPlayer.play(AudioAssets.complete);
        if (removedCount == 6){
          _audioPlayer.play(AudioAssets.getRandomGood());
        }
        if (removedCount == 7){
          _audioPlayer.play(AudioAssets.getRandomNice());
        }
        if (removedCount == 8){
          _audioPlayer.play(AudioAssets.getRandomGreat());
        }
        if (removedCount == 9){
          _audioPlayer.play(AudioAssets.awesome);
        }
        if (removedCount == 10){
          _audioPlayer.play(AudioAssets.getRandomUnbelievable());
        }
      }
      if (!hasLines) {
        hasLines = _placeBalls();
      }

      // Check game over
      if (_service.isGameOver(_state)) {
        if (_state.score > bestScore) {
          bestScore = _state.score;
          _updateLeaderboard();
        }

        Get.dialog(
          AlertDialog(
              content: EzText(
            'GAME OVER'.tr,
            color: Colors.white,
            fontSize: 40,
          )),
        );
        isGameOver = true;
        await Future.delayed(Duration(seconds: 2));
        Get.back();
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
    if (!_service.canMove(_state, startRow, startCol, endRow, endCol)) {
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
      [1, 0], // down
      [0, -1], // left
      [0, 1], // right
    ];

    while (!(currentRow == startRow && currentCol == startCol)) {
      int currentValue = grid[currentRow][currentCol];
      bool found = false;

      for (var dir in directions) {
        int newRow = currentRow + dir[0];
        int newCol = currentCol + dir[1];

        if (_state.isValidPosition(newRow, newCol) &&
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
      bestScore =
          await _leaderboardService.getUserScore(AppwriteConstants.COLLECTION_ID_7X7, userId!);
      update();
      topScore = await _leaderboardService.getTopScore(AppwriteConstants.COLLECTION_ID_7X7);
      update();
    } catch (e) {
      print('Error loading score: $e');
    }
  }

  Future<void> _updateLeaderboard() async {
    try {
      // Use the new method to update user score only if it's higher than previous best
      await _leaderboardService.updateUserScore(
        AppwriteConstants.COLLECTION_ID_7X7,
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

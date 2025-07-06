import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_lines_game/common/ez/ez_glass_gradient_button.dart';
import 'package:getx_lines_game/common/ez/ez_text.dart';
import '../../data/game/lines_model.dart';
import 'game_controller.dart';

class GameView extends GetView<GameController> {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Lines'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 40,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 20,
              children: [
                GetBuilder<GameController>(
                  builder: (controller) => Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          EzText(
                            'Player: ',
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                          EzText(
                            controller.nickname!,
                            fontSize: 20,
                          ),
                          SizedBox(
                            width: 40,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          EzText(
                            'Score: ',
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                          EzText(
                            controller.score.toString(),
                            fontSize: 20,
                          ),
                          SizedBox(width: 20),
                          EzText(
                            'Your best score: ',
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                          EzText(
                            controller.bestScore.toString(),
                            fontSize: 20,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          EzText(
                            'Top game score: ',
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                          EzText(
                            controller.topScore.toString(),
                            fontSize: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GetBuilder<GameController>(
                  builder: (controller) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children:
                        controller.nextBalls.map((ball) => _buildBall(ball, 24)).toList(),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: GetBuilder<GameController>(
                  builder: (controller) => GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: LinesModel.gridSize,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    itemCount: LinesModel.gridSize * LinesModel.gridSize,
                    // In the GridView.builder itemBuilder, modify to show the moving ball
                    itemBuilder: (context, index) {
                      final row = index ~/ LinesModel.gridSize;
                      final col = index % LinesModel.gridSize;
                      final ball = controller.grid[row][col];
                      final isSelected =
                          row == controller.selectedRow && col == controller.selectedCol;
                          
                      // Check if this cell is in the current animation path
                      final isInPath = controller.isAnimating && 
                          controller.currentPathIndex < controller.movePath.length &&
                          controller.movePath[controller.currentPathIndex][0] == row &&
                          controller.movePath[controller.currentPathIndex][1] == col;
                          
                      // If this cell is the current animation position, show the moving ball
                      if (isInPath) {
                        return _buildCell(controller.movingBall!, row, col, false);
                      }
                      
                      return _buildCell(ball, row, col, isSelected);
                    },
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: EzGlassGradientButton(
              onTap: controller.startNewGame,
              child: const Text('New Game', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCell(Ball ball, int row, int col, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.onCellTap(row, col),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          border: Border.all(
            color: isSelected ? Colors.yellow : Colors.grey[400]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: _buildBall(ball, null, isSelected),
      ),
    );
  }

  Widget _buildBall(Ball ball, double? size, [bool isSelected = false]) {
    if (ball.isEmpty) return const SizedBox.shrink();

    final baseSize = size ?? 32.0;
    
    if (!isSelected) {
      // Non-selected balls use a static container
      return Center(
        child: Container(
          width: baseSize,
          height: baseSize,
          decoration: BoxDecoration(
            color: ball.displayColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 2,
                offset: const Offset(1, 1),
              ),
            ],
          ),
        ),
      );
    }
    
    // Selected balls use AnimatedBuilder for continuous pulsating effect
    return Center(
      child: GetBuilder<GameController>(
        builder: (controller) => AnimatedBuilder(
          animation: controller.animationController!,
          builder: (context, child) {
            final scaleFactor = controller.animationValue;
            
            return Container(
              width: baseSize * scaleFactor,
              height: baseSize * scaleFactor,
              decoration: BoxDecoration(
                color: ball.displayColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

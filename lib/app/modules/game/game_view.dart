import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_lines_game/app/routes/app_pages.dart';
import 'package:getx_lines_game/common/ez/ez_glass_button.dart';
import 'package:getx_lines_game/common/ez/ez_glass_gradient_button.dart';
import 'package:getx_lines_game/common/ez/ez_text.dart';
import '../../data/game/lines_model.dart';
import 'game_controller.dart';
import 'widgets/ball_widget.dart';
import 'widgets/cell_widget.dart';

class GameView extends GetView<GameController> {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(26),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 20,
            children: [
              Column(
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
                      children: controller.nextBalls
                          .map((ball) => BallWidget(
                                ball: ball,
                                size: 24,
                                isSelected: false,
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
              Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    //  padding: const EdgeInsets.all(16.0),
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
                            return CellWidget(
                              ball: controller.movingBall!,
                              row: row,
                              col: col,
                              isSelected: false,
                            );
                          }

                          return CellWidget(
                            ball: ball,
                            row: row,
                            col: col,
                            isSelected: isSelected,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              EzGlassButton(
                height: 40,
                onTap: controller.startNewGame,
                child: const Text('New Game', style: TextStyle(fontSize: 18)),
              ),
              // SizedBox(
              //   height: 30,
              // ),
              EzGlassButton(
                height: 40,
                onTap: () {
                  Get.toNamed(Routes.LEADERBOARD);
                },
                child: const Text('Leaderboard', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

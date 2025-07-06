import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_lines_game/app/data/game/lines_model.dart';
import 'package:getx_lines_game/app/modules/game/game_controller.dart';
import 'ball_widget.dart';

final class CellWidget extends GetView<GameController> {
  final Ball ball;
  final int row;
  final int col;
  final bool isSelected;

  const CellWidget({
    super.key,
    required this.ball,
    required this.row,
    required this.col,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
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
        child: BallWidget(ball: ball, isSelected: isSelected),
      ),
    );
  }
}
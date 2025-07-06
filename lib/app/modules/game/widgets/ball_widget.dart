
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_lines_game/app/data/game/lines_model.dart';
import 'package:getx_lines_game/app/modules/game/game_controller.dart';

final class BallWidget extends StatelessWidget {

  final Ball ball;
  final double? size;
  final bool isSelected;

  const BallWidget({super.key, required this.ball, this.size = 32, required this.isSelected});

  @override
  Widget build(BuildContext context) {
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
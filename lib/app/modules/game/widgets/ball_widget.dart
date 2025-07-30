
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
      // Non-selected balls use a static container with 3D effect
      return Center(
        child: Container(
          width: baseSize,
          height: baseSize,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(-0.3, -0.3),
              radius: 0.7,
              colors: [
                Colors.white.withValues(alpha: 0.6),
                ball.displayColor,
                ball.displayColor.withValues(alpha: 0.6),
              ],
              stops: const [0.0, 0.4, 1.0],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              // Outer shadow for depth
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 6,
                offset: const Offset(2, 3),
              ),
              // Inner glow effect
              BoxShadow(
                color: ball.displayColor.withValues(alpha: 0.4),
                blurRadius: 2,
                offset: const Offset(-1, -1),
                spreadRadius: -1,
              ),
            ],
          ),
        ),
      );
    }
    
    // Selected balls use AnimatedBuilder for continuous pulsating effect with 3D styling
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
                gradient: RadialGradient(
                  center: const Alignment(-0.3, -0.3),
                  radius: 0.7,
                  colors: [
                    Colors.white.withValues(alpha: 0.6),
                    ball.displayColor,
                    ball.displayColor.withValues(alpha: 0.6),
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  // Outer shadow that scales with animation
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 6 * scaleFactor,
                    offset: Offset(2 * scaleFactor, 3 * scaleFactor),
                  ),
                  // Inner glow effect
                  BoxShadow(
                    color: ball.displayColor.withValues(alpha: 0.4),
                    blurRadius: 2,
                    offset: const Offset(-1, -1),
                    spreadRadius: -1,
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
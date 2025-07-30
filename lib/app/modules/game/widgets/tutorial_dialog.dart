import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_lines_game/common/audio/audio_assets.dart';
import 'package:getx_lines_game/common/audio/audio_player.dart';
import 'package:getx_lines_game/common/ez/ez_glass_button.dart';
import 'package:getx_lines_game/common/ez/ez_text.dart';

class TutorialBall {
  final Color color;
  final bool isEmpty;

  const TutorialBall({required this.color, this.isEmpty = false});

  static const TutorialBall empty = TutorialBall(color: Colors.transparent, isEmpty: true);
  
  Color get displayColor => color;
}

class TutorialBallWidget extends StatelessWidget {
  final TutorialBall ball;
  final double size;

  const TutorialBallWidget({
    super.key, 
    required this.ball, 
    this.size = 30,
  });

  @override
  Widget build(BuildContext context) {
    if (ball.isEmpty) return const SizedBox.shrink();

    final baseSize = size ;
    
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
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 6,
              offset: const Offset(2, 3),
            ),
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
}

class TutorialDialog extends StatelessWidget {
  const TutorialDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Put 5 or more balls of the same color in the row, column or diagonal',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildGrid(),
            const SizedBox(height: 20),
            EzGlassButton(
              width: 100,
              height: 40,
              onTap: (){ 
                Get.back();
                 Get.find<IAudioPlayer>().play(AudioAssets.button_tap);
                },
             
              child: const EzText('Got it', fontSize: 18,),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid() {
    // Create 7x7 grid
    final grid = _createGrid();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: List.generate(7, (row) => 
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(7, (col) => 
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                 // border: Border.all(color: Colors.black87)
                ),
                width: 28,
                height: 28,
                margin: const EdgeInsets.all(1),
                child: TutorialBallWidget(
                  ball: grid[row][col],
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<List<TutorialBall>> _createGrid() {
    // Create 7x7 grid filled with empty balls
    final grid = List.generate(7, (row) => 
      List.generate(7, (col) => TutorialBall.empty)
    );

    // Add horizontal line (row 2, green balls)
    for (int col = 1; col <= 5; col++) {
      grid[2][col] = const TutorialBall(color: Colors.green);
    }

    // Add vertical line (column 3, red balls)
    for (int row = 1; row <= 5; row++) {
      grid[row][3] = const TutorialBall(color: Colors.red);
    }

    // Add diagonal line (yellow balls) - from top-left to bottom-right
    for (int i = 1; i <= 5; i++) {
      grid[i][i] =  TutorialBall(color: Colors.yellow.shade900);
    }

    return grid;
  }
}

// Usage:
// Get.dialog(const TutorialDialog());
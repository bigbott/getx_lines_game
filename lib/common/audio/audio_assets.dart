import 'dart:math';

final class AudioAssets {
  AudioAssets._();

  static const SHUFFLE1 = "shuffle1";
  static const SHUFFLE2 = "shuffle2";
  static const FLIP1 = "flip1";
  static const FLIP2 = "flip2";
  static const FLIP3 = "flip3";
  static const FLIP4 = "flip4";
  static const FLIP5 = "flip5";
  static const FLIP6 = "flip6";
  static const FLIP7 = "flip7";
  static const FLIP8 = "flip8";
  static const CANNOT_MOVE = "cannotmove";
  static const COMPLETE = "complete";
  static const VICTORY = "victory";
  static const FIREWORKS = "fireworks";

  static const assetMap = {
    SHUFFLE1: 'assets/sounds/cards/shuffle/1.mp3',
    SHUFFLE2: 'assets/sounds/cards/shuffle/2.mp3',
    FLIP1: 'assets/sounds/cards/flip/1.mp3',
    FLIP2: 'assets/sounds/cards/flip/2.mp3',
    FLIP3: 'assets/sounds/cards/flip/3.mp3',
    FLIP4: 'assets/sounds/cards/flip/4.mp3',
    FLIP5: 'assets/sounds/cards/flip/5.mp3',
    FLIP6: 'assets/sounds/cards/flip/6.mp3',
    FLIP7: 'assets/sounds/cards/flip/7.mp3',
    //  FLIP8: 'assets/sounds/cards/flip/8.mp3',
    CANNOT_MOVE: 'assets/sounds/cards/put/1.mp3',
    COMPLETE: 'assets/sounds/cards/complete.mp3',
    VICTORY: 'assets/sounds/victory.mp3',
    FIREWORKS: 'assets/sounds/fireworks.mp3',
  };

  static final random = Random();
  static String getRandomFlipKey() {
    return 'flip${random.nextInt(7) + 1}';
  }
}

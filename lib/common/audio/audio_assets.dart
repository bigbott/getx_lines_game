import 'dart:math';

final class AudioAssets {
  AudioAssets._();

  static const ball_run = "ball_run";
  static const ball_run2 = "ball_run2";
  static const ball_tap = "ball_tap";
  static const button_tap = "button_tap";
  static const button_tap2 = "button_tap2";
  static const cannotmove = "cannotmove";
  static const complete = "complete";
  static const tribal_drum = "tribal_drum";
  static const awesome = "awesome";
  static const good = "good";
  static const good2 = "good2";
  static const good3 = "good3";
  static const great = "great";
  static const great2 = "great2";
   static const nice = "nice";
  static const nice2 = "nice2";
  static const unbelievable = "unbelievable";
  static const unbelievable2 = "unbelievable2";

  static const assetMap = {
    ball_run: 'assets/sounds/effects/ball_run.mp3',
    ball_run2: 'assets/sounds/effects/ball_run2.mp3',
    ball_tap: 'assets/sounds/effects/ball_tap.mp3',
    button_tap: 'assets/sounds/effects/button_tap.mp3',
    button_tap2: 'assets/sounds/effects/button_tap2.mp3',
    cannotmove: 'assets/sounds/effects/cannotmove.mp3',
    complete: 'assets/sounds/effects/complete.mp3',
    tribal_drum: 'assets/sounds/effects/tribal_drum.mp3',
    awesome: 'assets/sounds/voices/awesome.mp3',
      good: 'assets/sounds/voices/good.mp3',
    good2: 'assets/sounds/voices/good2.mp3',
    good3: 'assets/sounds/voices/good3.mp3',
    great: 'assets/sounds/voices/great.mp3',
    great2: 'assets/sounds/voices/great2.mp3',
     nice: 'assets/sounds/voices/nice.mp3',
    nice2: 'assets/sounds/voices/nice2.mp3',
    unbelievable: 'assets/sounds/voices/unbelievable.mp3',
    unbelievable2: 'assets/sounds/voices/unbelievable2.mp3',
  };

  static final random = Random();
  static String getRandomBallRun() {
    if (random.nextInt(10) >= 5){
      return ball_run;
    }
    return ball_run2;
  }
  static String getRandomButtonTap() {
    if (random.nextInt(10) >= 5){
      return button_tap;
    }
    return button_tap2;
  }
  static String getRandomGood() {
    if (random.nextInt(10) >= 3){
      return good;
    }
    if (random.nextInt(10) >= 6){
      return good2;
    }
    return good3;
  }
   static String getRandomGreat() {
    if (random.nextInt(10) >= 5){
      return great;
    }
    return great2;
  }
  static String getRandomNice() {
    if (random.nextInt(10) >= 5){
      return nice;
    }
    return nice2;
  }
   static String getRandomUnbelievable() {
    if (random.nextInt(10) >= 5){
      return unbelievable;
    }
    return unbelievable2;
  }
}

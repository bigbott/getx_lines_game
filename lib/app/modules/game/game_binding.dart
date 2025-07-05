import 'package:get/get.dart';
import '../../data/game/lines_service.dart';
import '../../data/leaderboard/leaderboard_service.dart';
import 'game_controller.dart';

class GameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LinesService());
    Get.lazyPut(() => LeaderboardService());
    Get.lazyPut<GameController>(
      () => GameController(
        Get.find<LinesService>(),
        Get.find<LeaderboardService>(),
      ),
    );
  }
}

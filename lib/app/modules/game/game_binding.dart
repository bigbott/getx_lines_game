import 'package:get/get.dart';
import 'package:getx_lines_game/app/data/stats/stats_service.dart';
import 'package:getx_lines_game/common/audio/audio_player.dart';
import '../../data/game/lines_service.dart';
import '../../data/leaderboard/leaderboard_service.dart';
import 'game_controller.dart';

class GameBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LinesService>(LinesService());
    Get.put<LeaderboardService>(LeaderboardService());
    Get.put<StatsService>(StatsService());
    Get.put<GameController>(
     GameController(
        Get.find<LinesService>(),
        Get.find<LeaderboardService>(),
         Get.find<StatsService>(),
         Get.find<IAudioPlayer>(),
      ),
    );
  }
}

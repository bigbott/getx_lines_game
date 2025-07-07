import 'package:get/get.dart';
import 'package:getx_lines_game/app/data/leaderboard/leaderboard_service.dart';

import 'leaderboard_controller.dart';

class LeaderboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LeaderboardController>(
      LeaderboardController(
        leaderboardService: Get.find<LeaderboardService>(),
      ),
    );
  }
}

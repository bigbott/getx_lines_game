import 'package:get/get.dart';
import 'package:appwrite/models.dart';
import 'package:getx_lines_game/app/data/leaderboard/leaderboard_service.dart';
import 'package:getx_lines_game/app/data/value_locator.dart';
import 'package:getx_lines_game/app/routes/app_pages.dart';
import 'package:getx_lines_game/common/localdb/shared_preferences.dart';

class LeaderboardController extends GetxController {
  final LeaderboardService leaderboardService;
  DocumentList? players;
  late String userId;

  LeaderboardController({required this.leaderboardService});

  @override
  void onInit() {
    super.onInit();
    userId = SharedPrefs.getUserId()!;
    loadAroundUser();
  }

  Future<void> loadAroundUser() async {
    players = null;
    update();
    final aroundUserPlayers = 
    await leaderboardService.loadPlayersAround(VL.find(VL.COLLECTION_ID), userId);
    if (aroundUserPlayers != null) {
      players = aroundUserPlayers;
      update();
    }
  }

  Future<void> loadTopPlayers() async {
    players = null;
    update();
    players = await leaderboardService.loadTopPlayers(VL.find(VL.COLLECTION_ID));
    update();
  }

  bool isCurrentUser(Document player) {
    return player.data['user_id'] == userId;
  }

  void showStats(Document player) {
    VL.put(VL.STATS_USER_ID, player.data['user_id']);
    Get.toNamed(Routes.STATS);
  }
}

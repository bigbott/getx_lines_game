import 'package:get/get.dart';
import 'package:appwrite/models.dart';
import 'package:getx_lines_game/app/data/leaderboard/leaderboard_service.dart';
import 'package:getx_lines_game/common/localdb/shared_preferences.dart';

class LeaderboardController extends GetxController {
  final LeaderboardService leaderboardService;
  DocumentList? players;
  String? userId;

  LeaderboardController({required this.leaderboardService});

  @override
  void onInit() {
    super.onInit();
    userId = SharedPrefs.getUserId();
    loadAroundUser();
  }

  Future<void> loadAroundUser() async {
    players = null;
    update();
    if (userId == null) {
      players = await leaderboardService.loadItems();
      update();
      return;
    }
    final aroundUserPlayers = await leaderboardService.loadItemsAroundUser(userId!);
    if (aroundUserPlayers != null) {
      players = aroundUserPlayers;
      update();
    }
  }

  Future<void> loadTopPlayers() async {
    players = null;
    update();
    players = await leaderboardService.loadItems();
    update();
  }

  bool isCurrentUser(Document player) {
    return player.data['user_id'] == userId;
  }
}

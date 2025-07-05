import 'package:get/get.dart';

import '../modules/game/game_binding.dart';
import '../modules/game/game_view.dart';
import '../modules/leaderboard/leaderboard_binding.dart';
import '../modules/leaderboard/leaderboard_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.GAME;

  static final routes = [

    GetPage(
      name: _Paths.GAME,
      page: () => const GameView(),
      binding: GameBinding(),
    ),
    GetPage(
      name: _Paths.LEADERBOARD,
      page: () => const LeaderboardView(),
      binding: LeaderboardBinding(),
    ),
  ];
}

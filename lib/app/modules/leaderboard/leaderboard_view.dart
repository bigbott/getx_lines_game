import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_lines_game/common/ez/ez_glass_button.dart';
import 'package:getx_lines_game/common/ez/ez_spacing.dart';
import 'package:getx_lines_game/common/ez/ez_text.dart';

import 'leaderboard_controller.dart';

class LeaderboardView extends GetView<LeaderboardController> {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          h12,
          Container(
            color: Colors.black12,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      child: EzText(
                    'Nickname'.tr,
                    color: Colors.white70,
                    fontSize: 18,
                  )),
                  SizedBox(width: 65, child: EzText(
                    'Rank'.tr,
                    color: Colors.white70,
                    fontSize: 18,
                  ) ,),
                  SizedBox(width: 65, child: EzText(
                    'Score'.tr,
                    color: Colors.white70,
                    fontSize: 18,
                  ) ,)
                ],
              ),
            ),
          ),
          Expanded(
            child: GetBuilder<LeaderboardController>(
              builder: (controller) {
                if (controller.players == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.players!.documents.isEmpty) {
                  return const Center(child: Text('No players found'));
                }
                return ListView.builder(
                  itemCount: controller.players!.documents.length,
                  itemBuilder: (context, index) {
                    final player = controller.players!.documents[index];
                    final isCurrentUser = controller.isCurrentUser(player);
                    return ListTile(
                      tileColor: isCurrentUser ? Colors.white12 : null,
                      onTap: () {
                        controller.showStats(player);
                      },
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 10,
                        children: [
                          Expanded(
                              child: _buildTitle('${player.data['nickname']}', isCurrentUser)),
                          SizedBox(
                              width: 60,
                              child: EzText(player.data['rank'].toString(), fontSize: 20)),
                          SizedBox(
                              width: 60,
                              child: EzText(player.data['score'].toString(), fontSize: 20)),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: [
                EzGlassButton(
                  height: 40,
                  onTap: controller.loadTopPlayers,
                  child: const EzText('Top Players', fontSize: 18),
                ),
                EzGlassButton(
                  height: 40,
                  onTap: controller.loadAroundUser,
                  child: const EzText('Your Position', fontSize: 18),
                ),
              ],
            ),
          ),
          h50,
        ],
      ),
    );
  }

  Widget _buildTitle(String? nickname, bool isCurrentUser) {
    if (isCurrentUser) {
      return Badge(
        label: EzText(
          'You'.tr,
          fontSize: 16,
        ),
        backgroundColor: Colors.blueAccent.shade700,
        alignment: Alignment.topCenter,
        child: EzText(
          nickname ?? 'Unknown',
          fontSize: 18,
        ),
      );
    }

    return EzText(
      nickname ?? 'Unknown',
      fontSize: 18,
    );
  }
}

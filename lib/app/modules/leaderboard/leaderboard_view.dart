import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_lines_game/common/ez/ez_glass_button.dart';
import 'package:getx_lines_game/common/ez/ez_glass_gradient_button.dart';
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
                      leading: EzText(
                        '${player.data['rank']}',
                        fontSize: 18,
                      ),
                      title: _buildTitle('${player.data['nickname']}', isCurrentUser),
                      trailing: EzText(player.data['scores'].toString(), fontSize: 20),
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

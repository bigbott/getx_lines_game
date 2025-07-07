import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                      leading: EzText('${index + 1}', fontSize: 18,),
                      title: EzText(player.data['nickname'] ?? 'Unknown', fontSize: 18,),
                      trailing: EzText(player.data['scores'].toString(), fontSize: 20),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: controller.loadTopPlayers,
                    child: const Text('Top Players'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: controller.loadAroundUser,
                    child: const Text('Your Position'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
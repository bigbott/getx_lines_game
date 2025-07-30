import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getx_lines_game/app/data/game/lines_model.dart';
import 'package:getx_lines_game/app/modules/game/widgets/ball_widget.dart';
import 'package:getx_lines_game/common/ez/ez_3d_text.dart';
import 'package:getx_lines_game/common/ez/ez_glass_button.dart';
import 'package:getx_lines_game/common/liquid_progress_indicator/liquid_indicator.dart';

import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(28.0),
          child: GetBuilder<HomeController>(builder: (controller) {
            return controller.audioInitFinished
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 40,
                    children: [
                      EzGlassButton(
                        height: 90,
                        onTap: () {
                          controller.start7x7Game();
                        },
                        child: Column(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Ez3dText('7 \u00D7 7', fontSize: 28, color: Colors.red.shade300),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 10,
                              children: [
                                BallWidget(
                                    ball: Ball(color: BallColor.red),
                                    isSelected: false,
                                    size: 24),
                                BallWidget(
                                    ball: Ball(color: BallColor.blue),
                                    isSelected: false,
                                    size: 24),
                                BallWidget(
                                    ball: Ball(color: BallColor.yellow),
                                    isSelected: false,
                                    size: 24),
                                BallWidget(
                                    ball: Ball(color: BallColor.green),
                                    isSelected: false,
                                    size: 24),
                              ],
                            ),
                          ],
                        ),
                      ),
                      EzGlassButton(
                        height: 90,
                        onTap: () {
                          controller.start8x8Game();
                        },
                        child: Column(
                          spacing: 10,
                          children: [
                            Ez3dText('8 \u00D7 8', fontSize: 28, color: Colors.blue.shade300),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 10,
                              children: [
                                BallWidget(
                                    ball: Ball(color: BallColor.red),
                                    isSelected: false,
                                    size: 24),
                                BallWidget(
                                    ball: Ball(color: BallColor.blue),
                                    isSelected: false,
                                    size: 24),
                                BallWidget(
                                    ball: Ball(color: BallColor.yellow),
                                    isSelected: false,
                                    size: 24),
                                BallWidget(
                                    ball: Ball(color: BallColor.green),
                                    isSelected: false,
                                    size: 24),
                                BallWidget(
                                    ball: Ball(color: BallColor.pink),
                                    isSelected: false,
                                    size: 24),
                              ],
                            ),
                          ],
                        ),
                      ),
                      EzGlassButton(
                        height: 90,
                        onTap: () {
                          controller.start8x10Game();
                        },
                        child: Column(
                          spacing: 10,
                          children: [
                            Ez3dText('8 \u00D7 10',
                                fontSize: 28, color: Colors.yellow.shade600),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 10,
                              children: [
                                BallWidget(
                                    ball: Ball(color: BallColor.red),
                                    isSelected: false,
                                    size: 24),
                                BallWidget(
                                    ball: Ball(color: BallColor.blue),
                                    isSelected: false,
                                    size: 24),
                                BallWidget(
                                    ball: Ball(color: BallColor.yellow),
                                    isSelected: false,
                                    size: 24),
                                BallWidget(
                                    ball: Ball(color: BallColor.green),
                                    isSelected: false,
                                    size: 24),
                                BallWidget(
                                    ball: Ball(color: BallColor.pink),
                                    isSelected: false,
                                    size: 24),
                                BallWidget(
                                    ball: Ball(color: BallColor.black),
                                    isSelected: false,
                                    size: 24),
                              ],
                            ),
                            //  h12,
                          ],
                        ),
                      ),
                    ],
                  )
                : LiquidProgressIndicator(
                    width: 140,
                    height: 400,
                    isHorizontal: false,
                    bgColor: Colors.green.shade100,
                    liquidColor: Colors.green.shade800,
                  );
          }),
        ),
      ),
    );
  }
}

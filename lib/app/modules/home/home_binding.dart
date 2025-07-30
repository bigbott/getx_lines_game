import 'package:get/get.dart';
import 'package:getx_lines_game/common/audio/audio_player.dart';

import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<IAudioPlayer>(
      AudioPlayer(),
    );
    Get.put<HomeController>(
      HomeController(audioPlayer: Get.find<IAudioPlayer>()),
    );
  }
}

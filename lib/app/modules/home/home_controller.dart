import 'package:get/get.dart';
import 'package:getx_lines_game/app/data/appwrite_constants.dart';
import 'package:getx_lines_game/app/data/value_locator.dart';
import 'package:getx_lines_game/app/routes/app_pages.dart';
import 'package:getx_lines_game/common/audio/audio_assets.dart';
import 'package:getx_lines_game/common/audio/audio_player.dart';

class HomeController extends GetxController {
  final IAudioPlayer _audioPlayer;

  HomeController({required audioPlayer}) : _audioPlayer = audioPlayer;

  bool audioInitFinished = false;
  
  @override
  void onInit() {
    super.onInit();
    _audioPlayer.init();
    if (_audioPlayer.initFinished.value) {
       _audioPlayer.initFinished.close();
       audioInitFinished = true;
       update();
    } else {
      subscribeToAudioReady();
    }
  }

  void subscribeToAudioReady() {
    _audioPlayer.initFinished.listen((value) {
      _audioPlayer.initFinished.close();
     audioInitFinished = true;
     update();
    });
  }

  void start7x7Game() {
     _audioPlayer.play(AudioAssets.button_tap);
    VL.put(VL.COLLECTION_ID, AppwriteConstants.COLLECTION_ID_7X7);
    VL.put(VL.GRID_WIDTH, 7);
    VL.put(VL.GRID_HEIGHT, 7);
    Get.toNamed(Routes.GAME);
  }

  void start8x8Game() {
     _audioPlayer.play(AudioAssets.button_tap);
    VL.put(VL.COLLECTION_ID, AppwriteConstants.COLLECTION_ID_8X8);
    VL.put(VL.GRID_WIDTH, 8);
    VL.put(VL.GRID_HEIGHT, 8);
    Get.toNamed(Routes.GAME);
  }

  void start8x10Game() {
     _audioPlayer.play(AudioAssets.button_tap);
    VL.put(VL.COLLECTION_ID, AppwriteConstants.COLLECTION_ID_8X10);
    VL.put(VL.GRID_WIDTH, 8);
    VL.put(VL.GRID_HEIGHT, 10);
    Get.toNamed(Routes.GAME);
  }
}

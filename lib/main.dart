import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getx_lines_game/app/data/leaderboard/leaderboard_service.dart';
import 'package:getx_lines_game/common/audio/audio_player.dart';
import 'package:getx_lines_game/common/extensions/color_scheme.dart';
import 'package:getx_lines_game/common/extensions/device_previewing.dart';
import 'package:getx_lines_game/common/localdb/shared_preferences.dart';

import 'app/routes/app_pages.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init();
  runApp(
    GetMaterialApp(
        title: "Application",
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        debugShowCheckedModeBanner: false,
      //  debugShowMaterialGrid: true,
      checkerboardOffscreenLayers: true,
      
        theme: ThemeData(
          colorScheme: ColorScheme.dark().fromSurface(
          //  Color.lerp(Colors.green.shade900, Colors.black, 0.5)!,
           Colors.green.shade900
          ),
        ),
        
        ).withDevicePreview(true),


  );
}

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.putAsync<IAudioPlayer>(() => AudioPlayer().init());
    Get.put(LeaderboardService());
  }
}

import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:get/get.dart';

import 'audio_assets.dart';

abstract interface class IAudioPlayer {
  void play(String key);
  RxBool get initFinished;
}

final class AudioPlayer implements IAudioPlayer {
  final _soloud = SoLoud.instance;
  Map<String, AudioSource> sourceMap = {};
  late var _initFinished = false.obs;
  @override
  RxBool get initFinished => _initFinished;

  Future<IAudioPlayer> init() async {
    print('before soloud init ' + DateTime.now().millisecondsSinceEpoch.toString());
    await _soloud.init();
    print('before sounds loaded ' + DateTime.now().millisecondsSinceEpoch.toString());
    int count = 0;
    print('AudioAssets.assetMap.length ' + AudioAssets.assetMap.length.toString());
    AudioAssets.assetMap.forEach((key, asset) {
      _soloud.loadAsset(asset).then((result) {
        sourceMap[key] = result;
        count++;
        print('count ' + count.toString());
        if (AudioAssets.assetMap.length == count) {
          _initFinished.value = true;
          print('after sounds loaded ' + DateTime.now().millisecondsSinceEpoch.toString());
        }
      });
    });

    return this;
  }

  @override
  void play(String key) {
    _soloud.play(sourceMap[key]!);
  }
}

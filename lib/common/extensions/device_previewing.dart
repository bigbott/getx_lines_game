

import 'package:device_preview/device_preview.dart';
import 'package:get/get.dart';

extension A on GetMaterialApp {
  DevicePreview withDevicePreview(bool enabled) {
     return DevicePreview(
      enabled: enabled,
      builder: (context) => this, 
    );
   }
}

extension B on GetCupertinoApp {
  DevicePreview withDevicePreview(bool enabled) {
     return DevicePreview(
      enabled: enabled,
      builder: (context) => this, 
    );
   }
}


import 'package:device_preview/device_preview.dart';
import 'package:get/get.dart';

extension DevicePreviewing on GetMaterialApp {
  DevicePreview withDevicePreview(bool enabled) {
     return DevicePreview(
      enabled: enabled,
      builder: (context) => this, 
    );
   }
}
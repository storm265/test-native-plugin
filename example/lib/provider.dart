import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> prepareService() async {
  await PermissionsProvider.requestAudioPermissions();
  await PermissionsProvider.requestVideoPermissions();
  await PermissionsProvider.requestMicroPermissions();
  await PermissionsProvider.requestStoragePermissions();

  return true;
}

class PermissionsProvider {


  static Future<void> requestAudioPermissions() async {
    await Permission.audio.isDenied.then((bool isGranted) async {
      debugPrint('==DEBUG==: Requesting permission audio..');
      final PermissionStatus status = await Permission.audio.request();
      debugPrint('==DEBUG==: New status audio.: $status');
    });
  }

  static Future<void> requestMicroPermissions() async {
    await Permission.microphone.isDenied.then((bool isGranted) async {
      debugPrint('==DEBUG==: Requesting permission microphone.');
      final PermissionStatus status = await Permission.microphone.request();
      debugPrint('==DEBUG==: New status microphone: $status');
    });
  }

  static Future<void> requestStoragePermissions() async {
    await Permission.storage.isDenied.then((bool isGranted) async {
      debugPrint('==DEBUG==: Requesting permission storage.');
      final PermissionStatus status = await Permission.storage.request();
      debugPrint('==DEBUG==: New status storage: $status');
    });
  }

  static Future<void> requestVideoPermissions() async {
    await Permission.camera.isDenied.then((bool isGranted) async {
      debugPrint('==DEBUG==: Requesting permission storage.');
      final PermissionStatus status = await Permission.camera.request();
      debugPrint('==DEBUG==: New status storage: $status');
    });
  }

  static Future<void> requestAlarmPermissions() async {
    await Permission.scheduleExactAlarm.isDenied.then((bool isGranted) async {
      debugPrint('==DEBUG==: Requesting permission storage.');
      final PermissionStatus status =
          await Permission.scheduleExactAlarm.request();
      debugPrint('==DEBUG==: New status storage: $status');
    });
  }
}

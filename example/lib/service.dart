import 'dart:async';
import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:hello/hello.dart';
import 'package:hello_example/camera_controller.dart';

@pragma('vm:entry-point')
class BackgroundService {
  static final BackgroundService _instance = BackgroundService._internal();

  factory BackgroundService() {
    return _instance;
  }

  BackgroundService._internal() {
    initializeService();
  }

 static final camera =CameraRecorderService();

  Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: false,
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: onStart,
        onBackground: null,
      ),
    );
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    // DartPluginRegistrant.ensureInitialized();
    final hello = Hello();

    if (service is AndroidServiceInstance) {
      service.setAsForegroundService();
    }
    debugPrint('foreground service started');

    // CameraRecorderService cameraRecorder = CameraRecorderService();
    // cameraRecorder.startVideoRecord();

    service.on('init').listen((event) async {
      final result = await hello.getPlatformVersion();
     
    });

    service.on('startVideoRecording').listen((event) async {
      await camera.startVideoRecording();
    });

    service.on('stopVideoRecording').listen((event) async {
      await camera.stopVideoRecording();
    });

    service.on('startRecording').listen((event) async {
      final result = await hello.startRecording();
    });

    service.on('stopRecording').listen((event) async {
      final result = await hello.stopRecording();
    });

    service.on('stopService').listen((event) async {
      try {} catch (e) {
        debugPrint('cant processAudio');
      }

      service.stopSelf();
    });
  }

  Future<bool> startService() async {
    final service = FlutterBackgroundService();
    bool isRunning = await service.startService();
    if (isRunning) {
      runningService = true;
      isFirstTime = false;
    }
    return isRunning;
  }

  void stopService() {
    final service = FlutterBackgroundService();
    service.invoke("stopService");

    runningService = false;
    isFirstTime = false;
  }

  bool isFirstTime = true;
  Future<bool> isRunningServiceAsync() async {
    final service = FlutterBackgroundService();
    var state = await service.isRunning();
    if (!isFirstTime) {
      state = false;
    }
    return state;
  }

  bool runningService = false;

  bool isRunningService() {
    return runningService;
  }
}

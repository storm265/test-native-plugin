import 'dart:io';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:developer';

class CameraRecorderService {
  CameraController? controller;

  int videoIteration = 0;

  CameraRecorderService() {
    initCamera();
  }

  Future<void> initCamera() async {
    List<CameraDescription> cameras = await availableCameras();
    log('cameras ${cameras}');
    controller = CameraController(
      cameras[0],
      ResolutionPreset.low,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    if (controller != null) {
      controller!.initialize().then((_) {
        log('camera is ready $cameras');
        // if (!mounted) {
        //   return;
        // }
        // setState(() {});
      }).catchError((Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              // Handle access errors here.
              break;
            default:
              // Handle other errors here.
              break;
          }
        }
      });
    }
  }

  Future<void> startVideoRecording() async {
    if (controller != null) {
      await controller!.startVideoRecording();
    }
  }

  Future<void> stopVideoRecording() async {
    if (controller != null) {
      await controller!.stopVideoRecording();
    }
  }
}

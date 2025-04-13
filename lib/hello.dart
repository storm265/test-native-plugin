import 'hello_platform_interface.dart';

class Hello {
  Future<String?> getPlatformVersion() {
    return HelloPlatform.instance.getPlatformVersion();
  }

  Future<void> startRecording() {
    return HelloPlatform.instance.startRecording();
  }

  Future<void> stopRecording() {
    return HelloPlatform.instance.stopRecording();
  }
}

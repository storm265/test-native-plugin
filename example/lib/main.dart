import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:hello/hello.dart';
import 'package:hello_example/provider.dart';
import 'package:hello_example/service.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final service = BackgroundService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text('get permissions'),
                onPressed: () async {
                  await Permission.microphone.request();
                  await Permission.camera.request();
                  await Permission.storage.request();
                },
              ),
              ElevatedButton(
                child: Text('Start Service'),
                onPressed: () async {
                  await service.startService();
                },
              ),
              ElevatedButton(
                child: Text('stop Service'),
                onPressed: () async {
                  service.stopService();
                },
              ),
              ElevatedButton(
                child: Text('get platform version'),
                onPressed: () async {
                  final service = FlutterBackgroundService();
                  service.invoke('init');
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                child: Text('start video from hello'),
                onPressed: () async {
                  final service = FlutterBackgroundService();
                  service.invoke('startRecording');
                },
              ),
              ElevatedButton(
                child: Text('stop video from hello'),
                onPressed: () async {
                  final service = FlutterBackgroundService();
                  service.invoke('stopRecording');
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                child: Text('start video from camea plugin'),
                onPressed: () async {
                  final service = FlutterBackgroundService();
                  service.invoke('startVideoRecording');
                },
              ),
              ElevatedButton(
                child: Text('stop video from camea plugin'),
                onPressed: () async {
                  final service = FlutterBackgroundService();
                  service.invoke('stopVideoRecording');
                },
              ),
              ElevatedButton(
                child: Text('stop video from camea plugin'),
                onPressed: () async {
                  final service = FlutterBackgroundService();
                  service.invoke('stopVideoRecording');
                },
              ),
              ElevatedButton(
                child: Text('main isolate run video'),
                onPressed: () async {
                  final PermissionStatus status =
                      await Permission.camera.request();

                  log('status ${status}');

                  // PermissionsProvider.requestVideoPermissions();
                  final methodChannel = const MethodChannel('hello');
                  final version =
                      await methodChannel.invokeMethod<bool>('startRecording');
                },
              ),
              ElevatedButton(
                child: Text('main isolate stop video'),
                onPressed: () async {
                  final PermissionStatus status =
                      await Permission.camera.request();

                  log('status ${status}');

                  // PermissionsProvider.requestVideoPermissions();
                  final methodChannel = const MethodChannel('hello');
                  final version =
                      await methodChannel.invokeMethod('stopRecording');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_background_video_recorder/flutter_bvr.dart';
import 'package:flutter_background_video_recorder/flutter_bvr_platform_interface.dart';
import 'package:flutter_background_video_recorder_example/video_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _flutterBackgroundVideoRecorderPlugin = CameraRecorderService();

  @override
  void initState() {
    super.initState();

    _flutterBackgroundVideoRecorderPlugin.listenState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  await _flutterBackgroundVideoRecorderPlugin
                      .startVideoRecord();
                },
                child: const Text(
                  "Start Recording",
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  String filePath = await _flutterBackgroundVideoRecorderPlugin
                          .stopVideoRecording() ??
                      "None";

                  log('path $filePath');
                },
                child: const Text(
                  "Stop Recording",
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _flutterBackgroundVideoRecorderPlugin
                      .startVideoRecord();

                  Timer.periodic(
                    const Duration(seconds: 10),
                    (timer) async {
                      String filePath =
                          await _flutterBackgroundVideoRecorderPlugin
                                  .stopVideoRecording() ??
                              "None";

                      log('path $filePath');
                      await _flutterBackgroundVideoRecorderPlugin
                          .startVideoRecord();
                    },
                  );
                },
                child: const Text(
                  "Start Periodic",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

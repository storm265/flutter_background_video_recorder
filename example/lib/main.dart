import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_background_video_recorder/flutter_bvr.dart';
import 'package:flutter_background_video_recorder/flutter_bvr_platform_interface.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // StreamSubscription to get realtime recorder events from native platform
  //  - 1: Recording in progress
  //  - 2: Recording has been stopped
  //  - 3: Recorder is being initialized and about to start recording
  //  - -1: Recorder encountered an error
  StreamSubscription<int?>? _streamSubscription;
  final _flutterBackgroundVideoRecorderPlugin =
      FlutterBackgroundVideoRecorder();

  // Indicates which camera to use for recording
  // Can take values:
  //  - Rear camera
  //  - Front camera
  String cameraFacing = "Rear camera";

  @override
  void initState() {
    super.initState();
    getInitialRecordingStatus();
    listenRecordingState();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  // Check if the recorder is already recording when returning to the app after it was closed.
  Future<void> getInitialRecordingStatus() async {
    log('is already working? : ${await _flutterBackgroundVideoRecorderPlugin.getVideoRecordingStatus() == 1}');
  }

  // Listen to recorder events to update UI accordingly
  // Switch values are according to the StreamSubscription documentation above
  void listenRecordingState() {
    _streamSubscription =
        _flutterBackgroundVideoRecorderPlugin.recorderState.listen((event) {
      switch (event) {
        case 1:
          log('Recording has started');
          break;
        case 2:
          log('Recording has stopped');
          break;
        case 3:
          log('Recorder is being initialized and about to start recording');
          break;
        case 4:
          log('An exception has occurred in the recording service');
          break;
        default:
          log('wtf $event');
      }

      // switch (event) {
      //   case 1:
      //     _isRecording = true;
      //     _recorderBusy = true;
      //     setState(() {});
      //     break;
      //   case 2:
      //     _isRecording = false;
      //     _recorderBusy = false;
      //     setState(() {});
      //     break;
      //   case 3:
      //     _recorderBusy = true;
      //     setState(() {});
      //     break;
      //   case -1:
      //     _isRecording = false;
      //     setState(() {});
      //     break;
      //   default:
      //     return;
      // }
    });
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
                      .startVideoRecording(
                    folderName: "Example Recorder",
                    cameraFacing: CameraFacing.rearCamera,
                    notificationTitle: "Example Notification Title",
                    notificationText: "Example Notification Text",
                    showToast: false,
                  );
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
                      .startVideoRecording(
                    folderName: "Example Recorder",
                    cameraFacing: CameraFacing.rearCamera,
                    notificationTitle: "Example Notification Title",
                    notificationText: "Example Notification Text",
                    showToast: false,
                  );

                  Timer.periodic(
                    const Duration(seconds: 10),
                    (timer) async {
                      String filePath =
                          await _flutterBackgroundVideoRecorderPlugin
                                  .stopVideoRecording() ??
                              "None";

                      log('path $filePath');
                      await _flutterBackgroundVideoRecorderPlugin
                          .startVideoRecording(
                        folderName: "Example Recorder",
                        cameraFacing: CameraFacing.rearCamera,
                        notificationTitle: "Example Notification Title",
                        notificationText: "Example Notification Text",
                        showToast: false,
                      );
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

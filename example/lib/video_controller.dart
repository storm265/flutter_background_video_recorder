import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_video_recorder/flutter_bvr.dart';
import 'package:flutter_background_video_recorder/flutter_bvr_platform_interface.dart';

import 'dart:developer';

class CameraRecorderService {
  final _flutterBackgroundVideoRecorderPlugin =
      FlutterBackgroundVideoRecorder();

  void listenState() {
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
    });
  }

  Future<void> startVideoService() async {
    if (Platform.isAndroid) {
      await startVideoRecord();

      // _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      //   try {
      //     await processVideo(shouldEnableRecording: true);
      //   } catch (e) {
      //     debugPrint('Timer error: $e');
      //   }
      // });
    }
  }

  Future<void> stopService() async {
    // _timer.cancel();
    // await processVideo();

    final result =
        await _flutterBackgroundVideoRecorderPlugin.stopVideoRecording();
    log('result ${result}');
  }

  Future<bool?> startVideoRecord() async {
    return await _flutterBackgroundVideoRecorderPlugin.startVideoRecording(
      folderName: "Records",
      cameraFacing: CameraFacing.rearCamera,
      notificationTitle: "Example Notification Title",
      notificationText: "Example Notification Text",
      showToast: false,
    );
  }

  Future<String?> stopVideoRecording() async {
    return await _flutterBackgroundVideoRecorderPlugin.stopVideoRecording();
  }
}

import 'dart:io';

import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';

class RecorderService {
  FlutterSoundRecorder recorder = FlutterSoundRecorder();

  RecorderService();
  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Permission not granted';
    }
    await recorder.openAudioSession();
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future startRecord() async {
    await recorder.startRecorder(
      toFile: 'audio',
      sampleRate: 16000,
      numChannels: 1,
      bitRate: 256,
    );
  }

  Future<File> stopRecorder() async {
    final filePath = await recorder.stopRecorder();
    final file = File(filePath!);
    return file;
  }

  void dispose() {
    recorder.closeAudioSession();
  }
}

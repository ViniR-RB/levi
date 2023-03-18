import 'package:captura/core/service/directory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class RecorderService {
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  String? _path;
  ValueNotifier<bool> isRecorderInitialized = ValueNotifier<bool>(false);
  ValueNotifier<bool> isRecording = ValueNotifier<bool>(false);
  ValueNotifier<bool> isPlaying = ValueNotifier<bool>(false);
  ValueNotifier<bool> isPlayed = ValueNotifier<bool>(false);

  final int _sampleRate = 16000;
  final int _numChannels = 1;
  final Codec _codec = Codec.pcm16WAV;
  final int _bitRate = 5333;

  RecorderService() {
    _initialize();
  }

  String? get path => _path;

  _initialize() async {
    _recorder = FlutterSoundRecorder();
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Permissão do microfone não aceita');
    }

    DirectoryPath directory = DirectoryPath('/AppLevi ');
    _path = '${await directory.getFileName('audio')}.wav';
    await _recorder!.openAudioSession();
    isRecorderInitialized.value = true;
  }

  dispose() async {
    await _recorder!.closeAudioSession();
    isRecorderInitialized.value = false;
  }

  Future<void> startRecorder() async {
    await _recorder!.startRecorder(
      toFile: _path,
      sampleRate: _sampleRate,
      numChannels: _numChannels,
      codec: _codec,
      bitRate: _bitRate,
    );
    isRecording.value = true;
  }

  Future<void> stopRecorder() async {
    await _recorder!.stopRecorder();
    _player = FlutterSoundPlayer();
    await _player!.openAudioSession();
    isRecording.value = false;
  }

  Future<void> play() async {
    isPlaying.value = true;
    isPlayed.value = false;
    await _player!.startPlayer(
      fromURI: _path,
      sampleRate: _sampleRate,
      numChannels: _numChannels,
      codec: _codec,
      whenFinished: () => {isPlaying.value = false, isPlayed.value = true},
    );
  }

  Future<void> stopPlayer() async {
    await _player!.stopPlayer();
    isPlaying.value = false;
  }
}

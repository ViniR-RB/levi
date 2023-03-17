import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';

class PlayerSerivce {
  FlutterSoundPlayer player = FlutterSoundPlayer();
  final File audio;
  PlayerSerivce({required this.audio});
  Future<void> init() async {
    await player.openAudioSession();
    player.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future<void> play() async {
    await player.openAudioSession();

    await player.startPlayer(
      fromURI: audio.path,
      sampleRate: 16000,
      numChannels: 1,
    );
  }

  Future stop() async {
    await player.stopPlayer();
  }

  Future tooglePlaying() async {
    if (player.isStopped) {
      await play();
    } else {
      await stop();
    }
  }
}

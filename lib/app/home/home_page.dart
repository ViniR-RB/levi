import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/service/http_service.dart';
import '../../core/service/player.dart';
import '../../core/service/recorder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late RecorderService recorder;
  HttpSerivce http = HttpSerivce();
  late bool rec;
  String test = "";

  late File audioFile;
  @override
  void initState() {
    rec = false;
    recorder = RecorderService();
    recorder.initRecorder();
    super.initState();
    audioFile = File('');
  }

  @override
  void dispose() {
    recorder.dispose();

    super.dispose();
  }

  Future<void> _dialog(BuildContext context) {
    return showDialog<void>(
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Player do Audio'),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    PlayerSerivce player = PlayerSerivce(audio: audioFile);

                    player.play();
                  },
                  child: const Text('Escutar')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    try {
                      http.uploadAudio(audioFile);
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: const Text('Enviar para o Back'))
            ],
          );
        },
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
              onPressed: () {
                print('Presionado');
                rec == false
                    ? {recorder.startRecord()}
                    : {
                        recorder.stopRecorder().then((value) {
                          audioFile = value;
                        }),
                        _dialog(context)
                      };

                setState(() {
                  rec = !rec;
                });
              },
              child:
                  Icon(rec == false ? Icons.record_voice_over : Icons.stop))),
    );
  }
}

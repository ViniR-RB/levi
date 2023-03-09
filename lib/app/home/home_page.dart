import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../core/service/player.dart';
import '../../core/service/recorder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late RecorderService recorder;

  bool rec = false;
  Dio dio = Dio();
  late File audioFile;
  @override
  void initState() {
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
                    dio
                        .post(
                            'https://apraxia-api-vosk-xig6ce3oqa-uc.a.run.app/process_v1/lesson_p_3',
                            options: Options(contentType: 'application/json'),
                            data: {audioFile})
                        .then((value) => print(value))
                        .onError((error, stackTrace) => print(stackTrace));
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
                rec
                    ? recorder.startRecord()
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
              child: Icon(rec ? Icons.record_voice_over : Icons.stop))),
    );
  }
}

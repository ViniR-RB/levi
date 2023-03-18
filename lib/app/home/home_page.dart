import 'dart:io';

import 'package:captura/core/alerts/alert_dialog.dart';
import 'package:flutter/material.dart';

import '../../core/service/http_service.dart';
import '../../core/service/recorder_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late RecorderService recorder;
  HttpService http = HttpService();
  late bool rec;

  late File audioFile;
  @override
  void initState() {
    rec = false;
    recorder = RecorderService();
    super.initState();
  }

  @override
  void dispose() {
    recorder.dispose();

    super.dispose();
  }

  Future<void> _dialog(BuildContext context) => showDialog<String>(
        builder: (BuildContext context) {
          return MyAlertDialog(http: http, recorder: recorder);
        },
        context: context,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: rec ? Colors.redAccent : Colors.blue,
                  fixedSize: const Size(60, 60)),
              onPressed: () {
                print('Presionado');
                rec == false
                    ? {recorder.startRecorder()}
                    : {
                        // wordNameController.clear(),
                        recorder
                            .stopRecorder()
                            .then((value) => _dialog(context))
                      };

                setState(() {
                  rec = !rec;
                });
              },
              child: Icon(rec == false ? Icons.record_voice_over : Icons.stop)),
          Padding(
            padding: const EdgeInsets.all(8.0),
          )
        ],
      )),
    );
  }
}

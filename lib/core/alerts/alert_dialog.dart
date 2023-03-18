import 'dart:io';

import 'package:captura/core/service/http_service.dart';
import 'package:captura/core/service/recorder_service.dart';
import 'package:flutter/material.dart';

class MyAlertDialog extends StatelessWidget {
  final RecorderService recorder;
  final formKey = GlobalKey<FormState>();
  final wordTemplateController = TextEditingController();
  ValueNotifier<bool> isSending = ValueNotifier<bool>(false);
  final HttpService http;

  MyAlertDialog({super.key, required this.recorder, required this.http});

  @override
  Widget build(BuildContext context) {
    wordTemplateController.clear();
    return ValueListenableBuilder(
        valueListenable: isSending,
        builder: (context, sending, _) => AlertDialog(
              actionsAlignment: MainAxisAlignment.center,
              title: const Center(child: Text('Player do Audio')),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Digite no campo abaixo a palavra que você pronunciou \n (ou deveria ter pronunciado)',
                      textAlign: TextAlign.center,
                    ),
                    TextFormField(
                        controller: wordTemplateController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          label: Text('Gabarito'),
                          icon: Icon(Icons.text_fields),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo não pode ser vazio';
                          }
                          if (value.contains(' ')) {
                            return 'Campos não pode conter espaços';
                          }
                          return null;
                        })
                  ],
                ),
              ),
              actions: sending
                  ? <Widget>[
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                    ]
                  : <Widget>[
                      ElevatedButton(
                          onPressed: () {
                            recorder.play();
                          },
                          child: const Text('Escutar')),
                      ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              try {
                                File audioFile = File(recorder.path!);
                                isSending.value = true;
                                await http
                                    .uploadAudio(
                                      audioFile,
                                      wordTemplateController.text,
                                    )
                                    .then((value) => print(value));
                              } catch (e) {
                                print(e);
                              } finally {
                                isSending.value = false;
                                Navigator.of(context).pop();
                              }
                            }
                          },
                          child: const Text('Enviar para o Back'))
                    ],
            ));
  }
}

import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../constants.dart';

class HttpSerivce {
  Future<void> uploadAudio(File audioFile) async {
    Uint8List audioConverted = await audioFile.readAsBytes();
    print(audioConverted);
    http.MultipartRequest request = http.MultipartRequest(
      'POST',
      Uri.parse(url.toString()),
    );
    var audio = http.MultipartFile.fromBytes(
      "audio",
      audioConverted,
      filename: 'audio',
    );
    print(request.toString());
    request.files.add(audio);
    print(audio);
    print(request.files.length);
    var response = await request.send().timeout(const Duration(seconds: 15));
    print("Response: ${response.statusCode}");
    Uint8List responseData = await response.stream.toBytes();
    String result = String.fromCharCodes(responseData);
    print("Result: $result");
  }

  HttpSerivce();
}

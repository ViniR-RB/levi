import 'dart:io';
import 'dart:typed_data';

import 'package:captura/core/constants.dart';
import 'package:http/http.dart' as http;

class HttpService {
  HttpService();

  Future<String> uploadAudio(File audioFile, String template) async {
    Uri url = Uri.parse('$baseUrl?gabarito=$template');
    Uint8List audioConverted = await audioFile.readAsBytes();

    http.MultipartRequest request = http.MultipartRequest(
      'POST',
      url,
    );
    var audio = http.MultipartFile.fromBytes(
      "audio",
      audioConverted,
      filename: 'audio',
    );
    print(request.toString());
    request.files.add(audio);
    // print(audio);
    // print(request.files.length);
    var response = await request.send().timeout(const Duration(seconds: 15));
    print("Response: ${response.statusCode}");
    Uint8List responseData = await response.stream.toBytes();
    String result = String.fromCharCodes(responseData);
    return result;
  }
}

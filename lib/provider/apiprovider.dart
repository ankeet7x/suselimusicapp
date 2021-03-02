import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiHelper extends ChangeNotifier {
  String url = 'http://api.suseli.org/predict';
  String genre;
  String success;

  postSong(String songPath) async {
    var postUri = Uri.parse(url);
    print("Uploading");
    var request = http.MultipartRequest('POST', postUri);
    request.files.add(await http.MultipartFile.fromPath('data', songPath));
    // http.StreamedResponse response = await request.send();
    final response = await request.send();
    if (response.statusCode == 200) {
      // print("Lo");
      response.stream.transform(utf8.decoder).listen((event) {
        var data = jsonDecode(event);
        print(data['genre']);
      });
      // print(response.stream)

    }
  }
}

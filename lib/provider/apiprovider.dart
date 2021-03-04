import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum FetchFromApi { Idle, Fetching, Fetched}

class ApiHelper extends ChangeNotifier {
  String url = 'http://api.suseli.org/predict';
  String genre;
  String success;
  FetchFromApi fetchFromApi = FetchFromApi.Idle;


  postSong(String songPath) async {
    fetchFromApi = FetchFromApi.Fetching;
    notifyListeners();
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
        genre = data['genre'];
        
        notifyListeners();
      });
      // print(response.stream)
      fetchFromApi = FetchFromApi.Fetched;
      notifyListeners();
      setToIdle();
      notifyListeners();

    }
  }

  
  
  setToIdle(){
    Future.delayed(Duration(seconds: 8), (){
      fetchFromApi = FetchFromApi.Idle;
      notifyListeners();
    });
  }

}

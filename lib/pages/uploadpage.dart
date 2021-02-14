import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suseli/materials/suseliprovider.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Page"),
      ),
      body: Column(
        children: [
          Consumer<MusicProvider>(builder: (context, pro, child) {
            return RaisedButton(
              child: Text("Select your song"),
              onPressed: () {
                // pro.selectSong();
              },
            );
          }),
          IconButton(
            icon: Icon(Icons.upload_file),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}

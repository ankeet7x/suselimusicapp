import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suseli/materials/dbprovider.dart';
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
          Consumer<DbProvider>(builder: (context, db, child) {
            return RaisedButton(
              child: Text("Select your song"),
              onPressed: () {
                db.selectSong();
                // pro.selectSong();
              },
            );
          }),
          Consumer<DbProvider>(
            builder: (context, db, child) => IconButton(
              icon: Icon(Icons.upload_file),
              onPressed: () async {
                try {
                  await db.uploadSong(db.mp3);
                  Navigator.pop(context);
                  // Scaffold.of(context)
                  //     .showSnackBar(SnackBar(content: Text("Uploaded")));
                } catch (e) {
                  print(e.toString());
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

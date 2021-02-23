import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suseli/provider/dbprovider.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _artistController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _artistController.dispose();
    super.dispose();
  }

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
            builder: (context, db, child) {
              if (db.mp3 != null) {
                return Text(db.mp3.uri.toString());
              } else {
                return Container();
              }
            },
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  validator: (val) =>
                      val.length < 3 ? "Please enter a valid title" : null,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.title), hintText: "Title"),
                ),
                TextFormField(
                  controller: _artistController,
                  validator: (val) =>
                      val.length < 5 ? "Please enter artist's name" : null,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person), hintText: "Artist"),
                ),
              ],
            ),
          ),
          Consumer<DbProvider>(
            builder: (context, db, child) => InkWell(
              splashColor: Colors.cyan,
              onTap: () async {
                try {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    print("Uploading");
                    await db.uploadSong(
                        db.mp3, _titleController.text, _artistController.text);
                    // Navigator.pop(context);
                  }
                } catch (e) {
                  print(e.toString());
                }
              },
              child: Row(
                children: [Icon(Icons.upload_file), Text("Upload")],
              ),
            ),
          ),
          Consumer<DbProvider>(
            builder: (context, db, child) {
              switch (db.uploadingStatus) {
                case UploadingStatus.Uploading:
                  return CircularProgressIndicator(
                    backgroundColor: Colors.purple,
                  );
                  break;
                case UploadingStatus.Uploaded:
                  return Text("Your song has been uploaded");
                  break;
                case UploadingStatus.Idle:
                  return Container();
              }
            },
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:suseli/provider/dbprovider.dart';
import 'package:suseli/provider/netsongprovider.dart';
import 'package:suseli/widgets/styledtf.dart';

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
    final db = Provider.of<DbProvider>(context);
    final netP = Provider.of<NetSongProvider>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Upload Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  StyledTf(
                    providedHeight: size.height * 0.06,
                    hintText: "Title",
                    maxLines: 1,
                    getController: _titleController,
                    artistN: "Title",
                    labelText: "Title",
                  ),
                  StyledTf(
                    providedHeight: size.height * 0.06,
                    hintText: "Artist",
                    maxLines: 1,
                    getController: _artistController,
                    artistN: "Artist",
                    labelText: "Artist",
                  ),
                ],
              ),
            ),
            Consumer<DbProvider>(
              builder: (context, db, child) => Container(
                child: db.mp3 == null
                    ? RaisedButton(
                        child: Text("Select your song"),
                        onPressed: () {
                          db.selectSong();
                          // pro.selectSong();
                        },
                      )
                    : Text(db.mp3.uri.toString()),
              ),
            ),
            // Consumer<DbProvider>(
            //   builder: (context, db, child) {
            //     if (db.mp3 == null) {
            //       return Container();
            //     } else {
            //       return Text(db.mp3.toString());
            //     }
            //   },
            // ),

            Consumer<DbProvider>(
              builder: (context, db, child) => Padding(
                padding: const EdgeInsets.fromLTRB(5, 10, 0, 10),
                child: Container(
                  // color: Colors.grey,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  height: size.height * 0.3,
                  width: size.width * 0.8,
                  child: GestureDetector(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: db.albumArt == null
                          ? Center(
                              child: IconButton(
                              icon: Icon(Icons.add_a_photo),
                              onPressed: () {
                                db.getAlbumArt();
                              },
                            ))
                          : Image.file(
                              db.albumArt,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
              ),
            ),

            Consumer<DbProvider>(
              builder: (context, db, child) {
                switch (db.upStatus) {
                  case UploadingStatus.Uploading:
                    return Container(
                      height: size.height * 0.05,
                      width: size.width * 0.35,
                      color: Color(0xFF03C6C7),
                      child: Center(
                          child: SpinKitThreeBounce(
                        color: Colors.white,
                        size: 20,
                      )),
                    );
                    break;
                  case UploadingStatus.Uploaded:
                    return Container(
                      height: size.height * 0.05,
                      width: size.width * 0.35,
                      color: Color(0xFF03C6C7),
                      child: Row(
                        children: [Icon(Icons.check), Text("Uploaded")],
                      ),
                    );
                    break;
                  case UploadingStatus.Pop:
                    Navigator.pop(context);
                    break;
                  case UploadingStatus.Free:
                    return Container(
                      height: size.height * 0.05,
                      width: size.width * 0.35,
                      child: RaisedButton(
                          color: Color(0xFF03C6C7),
                          onPressed: () async {
                            try {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                print("Uploading");
                                await db.uploadSong(
                                    db.mp3,
                                    _titleController.text,
                                    _artistController.text,
                                    db.albumArt);
                                // Navigator.pop(context);

                                Future.delayed(Duration(seconds: 5), () {
                                  netP.fetchSongsFromInternet();
                                });
                              }
                            } catch (e) {
                              print(e.toString());
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.upload_file,
                                color: Colors.white,
                              ),
                              Text(
                                "Upload",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          )),
                    );
                }
              },
            ),
            // Consumer<DbProvider>(builder: (context, db, child){
            //   switch(db.upStatus){

            //     case UploadingStatus.Uploading:
            //       return Row(children: [
            //         Text("Uploading to db"),
            //         CircularProgressIndicator()
            //       ],);
            //       break;
            //     case UploadingStatus.Uploaded:
            //       return Text("Uploaded");
            //       break;
            //     case UploadingStatus.Pop:
            //       Navigator.pop(context);
            //       break;
            //     case UploadingStatus.Free:
            //       // Navigator.pop(context);
            //       return Container();
            //       break;
            //     // default:
            //     //   return Container();
            //     //   break;
            //   }
            // },)
          ],
        ),
      ),
      // Consumer<DbProvider>(builder: (context, db, child) {
      //   switch (db.upStatus) {
      //     case UploadingStatus.Uploading:
      //       return SpinKitPouringHourglass(color: Color(0xFF03C6C7));
      //       break;
      //     case UploadingStatus.Uploaded:
      //       return Text("Your song has been uploaded");
      //       break;
      //     case UploadingStatus.Pop:
      //       return Container();
      //       break;
      //     case UploadingStatus.Free:
      //       return Container();
      //       break;
      //   }
      // })
    );
  }
}

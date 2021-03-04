import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
                builder: (context, db, child) => Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        onTap: () {
                          db.selectSong();
                        },
                        child: Container(
                          height: size.height * 0.05,
                          width: size.width * 0.35,
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF480CA8), ),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white),
                          child: Center(
                            child: db.mp3 == null
                                ? Text(
                                    "Select your song",
                                    style: TextStyle(color: Color(0xFF480CA8)),
                                  )
                                : Text("Selected", style: TextStyle(
                                  color: Color(0xFF480CA8)
                                )),
                          ),
                        ),
                      ),
                    )),
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
                    color: Colors.white,
                    border: Border.all(
                      color: Color(0xFF480CA8),
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  height: size.height * 0.3,
                  width: size.width * 0.8,
                  child: GestureDetector(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: db.albumArt == null
                          ? Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: size.height * 0.1,
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.add_a_photo,
                                    size: 28,
                                    color: Color(0xFF480CA8),
                                  ),
                                  onPressed: () {
                                    db.getAlbumArt();
                                  },
                                ),
                                Text(
                                  "Add a photo",
                                  style: TextStyle(
                                      color: Color(0xFF480CA8),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )
                              ],
                            )
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
                      decoration: BoxDecoration(
                          color: Color(0xFF480CA8),
                          borderRadius: BorderRadius.circular(7)),
                      child: Center(
                          child: SpinKitThreeBounce(
                            color: Colors.white,
                            size: 12,
                          ),
                    ));
                    break;
                  case UploadingStatus.Uploaded:
                    return Container(
                      height: size.height * 0.05,
                      width: size.width * 0.35,
                      decoration: BoxDecoration(
                          color: Color(0xFF480CA8),
                          borderRadius: BorderRadius.circular(7)),
                      child: Center(
                          child: Text("Uploaded", style: TextStyle(
                            color: Colors.white
                          ),),
                    ));
                    break;
                  case UploadingStatus.Pop:
                    Navigator.pop(context);
                    break;
                  case UploadingStatus.Free:
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () async {
                          try {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              print("Uploading");
                              if (db.mp3 == null) {
                                return Fluttertoast.showToast(
                                    msg: "Insert a song or image");
                              } else {
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
                            }
                          } catch (e) {
                            print(e.toString());
                          }
                        },
                        child: Container(
                          height: size.height * 0.05,
                          width: size.width * 0.35,
                          decoration: BoxDecoration(
                              color: Color(0xFF480CA8),
                              borderRadius: BorderRadius.circular(7)),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.upload_file,
                                color: Colors.white,
                              ),
                              Text(
                                "Submit",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          )),
                        ),
                      ),
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

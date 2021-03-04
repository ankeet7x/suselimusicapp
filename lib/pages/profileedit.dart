import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:suseli/provider/artistprovider.dart';
import 'package:suseli/provider/dbprovider.dart';
import 'package:suseli/widgets/styledtf.dart';

class ProfileEdit extends StatefulWidget {
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<DbProvider>(context);
    final artistPro = Provider.of<GetArtists>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Update Your Profile",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.01,
            ),
            Consumer<DbProvider>(
              builder: (context, db, child) => Padding(
                padding: const EdgeInsets.fromLTRB(5, 10, 0, 10),
                child: Container(
                  // color: Colors.grey,

                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF480CA8), width: 1),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  height: size.height * 0.25,
                  width: size.width * 0.88,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: db.coverImgFile == null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: size.height * 0.08,
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.add_a_photo,
                                  size: 42,
                                ),
                                color: Color(0xFF480CA8),
                                onPressed: () async {
                                  await db.coverImgPicker();
                                },
                              ),
                              Text(
                                "Choose cover Photo",
                                style: TextStyle(color: Color(0xFF480CA8)),
                              )
                            ],
                          )
                        : Image.file(
                            db.coverImgFile,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Consumer<DbProvider>(
                builder: (context, db, child) => Container(
                      height: 150,
                      width: 150,
                      // color: Colors.grey,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF480CA8), width: 1),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      // height: size.height * 0.25,
                      // width: size.width * 0.7,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: db.profileImgFile == null
                            ? IconButton(
                                icon: Icon(
                                  Icons.add_a_photo,
                                  color: Color(0xFF480CA8),
                                  size: 30,
                                ),
                                onPressed: () async {
                                  await db.profileImgPicker();
                                },
                              )
                            : Image.file(
                                db.profileImgFile,
                                fit: BoxFit.cover,
                              ),
                      ),
                    )),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  StyledTf(
                    providedHeight: size.height * 0.06,
                    artistN: "Username",
                    hintText: "Username",
                    labelText: "Username",
                    getController: _usernameController,
                    maxLines: 1,
                  ),
                  StyledTf(
                    artistN: "bio",
                    hintText: "Bio",
                    providedHeight: size.height * 0.12,
                    labelText: "Bio",
                    maxLines: 4,
                    getController: _bioController,
                  ),
                ],
              ),
            ),
            Consumer<DbProvider>(builder: (context, db, child) {
              switch (db.profileUpdateStatus) {
                case ProfileUpdateStatus.Updating:
                  return Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Container(
                      height: size.height * 0.05,
                      width: size.width * 0.35,
                      color: Color(0xFF480CA8),
                      child: Center(
                          child: SpinKitThreeBounce(
                        color: Colors.white,
                        size: 20,
                      )),
                    ),
                  );
                  break;
                case ProfileUpdateStatus.Updated:
                  return Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Container(
                      height: size.height * 0.05,
                      width: size.width * 0.35,
                      color: Color(0xFF480CA8),
                      child: Center(
                          child: Text(
                        "Uploaded",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                  );
                  break;
                case ProfileUpdateStatus.Pop:
                  Navigator.pop(context);
                  break;
                case ProfileUpdateStatus.Free:
                  return Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Container(
                      height: size.height * 0.05,
                      width: size.width * 0.35,
                      child: RaisedButton(
                        color: Color(0xFF480CA8),
                        child: Text(
                          "Update",
                          style: TextStyle(color: Colors.white),
                        ),
                        // enableFeedback: true,
                        splashColor: Colors.blue,
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            if (db.profileImgFile == null ||
                                db.coverImgFile == null) {
                              return Fluttertoast.showToast(
                                  msg: "Check if the images are uploaded");
                            } else {
                              print("running");
                              try {
                                await db.updateArtistProfile(
                                    db.profileImgFile,
                                    db.coverImgFile,
                                    _bioController.text,
                                    _usernameController.text,
                                    db.user.displayName);
                                db.user.email == null
                                    ? await artistPro
                                        .getCertainArtist(db.user.email)
                                    : artistPro.getCertainArtist(db.user.email);
                              } catch (e) {
                                print(e);
                              }
                            }
                          }
                        },
                      ),
                    ),
                  );
                  break;
              }
            })
          ],
        ),
      ),
    );
  }
}

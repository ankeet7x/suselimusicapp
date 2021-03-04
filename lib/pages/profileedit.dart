import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
    // final db = Provider.of<DbProvider>(context);
    final artistPro = Provider.of<GetArtists>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Update Your Profile", style: TextStyle(
          color: Colors.white,
        ),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.01,
            ),
            Text("Choose a cover Photo"),
            Consumer<DbProvider>(
              builder: (context, db, child) => Padding(
                padding: const EdgeInsets.fromLTRB(5, 10, 0, 10),
                child: Container(
                  // color: Colors.grey,
                  
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.cyan, width: 1),
                    color: Color(0xFF03C6C7),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  height: size.height * 0.25,
                  width: size.width * 0.88,
                  child: GestureDetector(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: db.coverImgFile == null
                          ? Center(
                              child: IconButton(
                              icon: Icon(Icons.add_a_photo, color: Colors.white, size: 30,),
                              onPressed: () async {
                                await db.coverImgPicker();
                              },
                            ))
                          : Image.file(
                              db.coverImgFile,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Text("Chose a profile picture"),
            SizedBox(
              height: size.height * 0.01,
            ),
            Consumer<DbProvider>(
              builder: (context, db, child) => Container(
                height: 150,
                width: 150,
                // color: Colors.grey,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.cyan, width: 1),
                  color: Color(0xFF03C6C7),
                  borderRadius: BorderRadius.circular(95),
                ),
                // height: size.height * 0.25,
                // width: size.width * 0.7,
                child: GestureDetector(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(95),
                    child: db.profileImgFile == null
                        ? Center(
                            child: IconButton(
                            icon: Icon(Icons.add_a_photo, color: Colors.white, size: 30,),
                            onPressed: () async {
                              await db.profileImgPicker();
                            },
                          ))
                        : Image.file(
                            db.profileImgFile,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
            ),
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
                  return Container(
                    height: size.height * 0.05,
                    width: size.width * 0.35,
                    color: Color(0xFF03C6C7),
                    child: Center(
                        child: SpinKitThreeBounce(
                      color: Colors.white,
                      size: 25,
                    )),
                  );
                  break;
                case ProfileUpdateStatus.Updated:
                  return Container(
                    height: size.height * 0.05,
                    width: size.width * 0.35,
                    color: Color(0xFF03C6C7),
                    child: Center(child: Text("Uploaded", style: TextStyle(
                      color: Colors.white
                    ),)),
                  );
                  break;
                case ProfileUpdateStatus.Pop:
                  Navigator.pop(context);
                  break;
                case ProfileUpdateStatus.Free:
                  return Container(
                    height: size.height * 0.05,
                    width: size.width * 0.35,
                    child: RaisedButton(
                      color: Color(0xFF03C6C7),
                      child: Text("Update", style: TextStyle(
                        color: Colors.white
                      ),),
                      // enableFeedback: true,
                      splashColor: Colors.blue,
                      onPressed: () async {
                        await db.updateArtistProfile(
                            db.profileImgFile,
                            db.coverImgFile,
                            _bioController.text,
                            _usernameController.text,
                            db.user.displayName);
                        db.user.email == null
                            ? await artistPro.getCertainArtist(db.user.email)
                            : artistPro.getCertainArtist(db.user.email);
                      },
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

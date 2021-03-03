import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suseli/provider/dbprovider.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Your Profile"),
      ),
      body: ListView(
        children: [
          RaisedButton(
            child: Icon(Icons.add_a_photo),
            onPressed: () async {
              await db.profileImgPicker();
            },
          ),
          RaisedButton(
            child: Icon(Icons.add_a_photo),
            onPressed: () async {
              await db.coverImgPicker();
            },
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _usernameController,
                    validator: (val) =>
                        val.length < 3 ? "Please enter a valid username" : null,
                    decoration: InputDecoration(
                        disabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        border: InputBorder.none,
                        // prefixIcon: Icon(Icons.title),
                        hintText: "username"),
                  ),
                ),
                TextFormField(
                  controller: _bioController,
                  validator: (val) =>
                      val.length < 5 ? "Please enter your bio" : null,
                  decoration: InputDecoration(
                      disabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none,
                      // prefixIcon: Icon(Icons.person),
                      hintText: "Bio"),
                ),
              ],
            ),
          ),
          RaisedButton(
            child: Text("sup"),
            // enableFeedback: true,
            splashColor: Colors.blue,
            onPressed: () {
              db.updateArtistProfile(db.profileImgFile, db.coverImgFile, _bioController.text, _usernameController.text, db.user.displayName);
            },
          )
        ],
      ),
    );
  }
}

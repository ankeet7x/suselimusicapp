import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:random_string/random_string.dart';
import 'package:suseli/models/songs.dart';

enum Status { Unauthenticaed, Authenticating, Authenticated }
enum UploadingStatus { Uploading, Uploaded, Idle }

class DbProvider extends ChangeNotifier {
  UploadingStatus uploadingStatus = UploadingStatus.Idle;
  Status status = Status.Unauthenticaed;
  User user;
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _signIn = GoogleSignIn();

  signInWithGoogle() async {
    try {
      status = Status.Authenticating;
      notifyListeners();
      final GoogleSignInAccount googleSignInAccount = await _signIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      final authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      user = authResult.user;
      print(user.displayName);
      // createUserInDb(user.uid, user.email);
      notifyListeners();
      status = Status.Authenticated;
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  // createUserInDb(id, email) async {
  //   Map<String, dynamic> userData = {'uid': id, 'email': email};
  //   await FirebaseFirestore.instance
  //       .collection('Users')
  //       .doc(email)
  //       .set(userData);
  // }

  Future<void> signOutWithGoogle() async {
    await _signIn.signOut();
    status = Status.Unauthenticaed;
    notifyListeners();
    print("signed out");
  }

  File mp3;
  selectSong() async {
    try {
      FilePickerResult result =
          await FilePicker.platform.pickFiles(type: FileType.audio);
      if (result != null) {
        File file = File(result.files.first.path);
        mp3 = file;
        notifyListeners();
      } else {}
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  String url;

  uploadSong(song, title, artist) async {
    uploadingStatus = UploadingStatus.Uploading;
    notifyListeners();
    if (song != null) {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("Song")
          .child('${randomAlphaNumeric(9)}.mp3');
      UploadTask task = ref.putFile(song);
      task.then((res) {
        res.ref.getDownloadURL().then((String result) {
          url = result;
          notifyListeners();
          Map<String, dynamic> songData = {
            'songUrl': url,
            'uploadedBy': user.email,
            'title': title,
            'artist': artist
          };
          FirebaseFirestore.instance
              .collection("Songs")
              .add(songData)
              .then((value) => print("Uploaded"));
          uploadingStatus = UploadingStatus.Uploaded;
          notifyListeners();
        });
      });
    }
    uploadingStatus = UploadingStatus.Idle;
    notifyListeners();
  }
}

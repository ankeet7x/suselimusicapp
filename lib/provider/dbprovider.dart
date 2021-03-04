import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

enum Status { Unauthenticaed, Authenticating, Authenticated }
// enum UploadingStat {Free, Uploading, Uploaded}

enum UploadingStatus { Uploading, Uploaded, Pop, Free }
enum ProfileUpdateStatus{Updating, Updated, Pop, Free}

class DbProvider extends ChangeNotifier {
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

  Future<void> signOutWithGoogle() async {
    try {
      await _signIn.signOut();
      status = Status.Unauthenticaed;
      notifyListeners();
      print("signed out");
    } catch (e) {
      print(e);
    }
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

  File albumArt;
  final picker = ImagePicker();
  getAlbumArt() async {
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      albumArt = File(pickedImage.path);
      notifyListeners();
    }
  }

  String url;
  String imgUrl;
  Timer timer;
  String title;
  String artist;
  String currentUser;
  UploadingStatus upStatus = UploadingStatus.Free;

  uploadSong(song, title, artist, coverImage) async {
    notifyListeners();
    if (song != null && coverImage != null) {
      upStatus = UploadingStatus.Uploading;
      notifyListeners();
      Reference songRef = FirebaseStorage.instance
          .ref()
          .child("Song")
          .child('${randomAlphaNumeric(9)}.mp3');
      Reference coverImageRef = FirebaseStorage.instance
          .ref()
          .child("Cover")
          .child('${randomAlphaNumeric(9)}.mp3');
      UploadTask task = songRef.putFile(song);
      UploadTask imgUpload = coverImageRef.putFile(coverImage);

      imgUpload.then((res) => res.ref.getDownloadURL().then((String result) {
            imgUrl = result;
            notifyListeners();
            Future.delayed(const Duration(seconds: 2), () {
              task.then((res) {
                res.ref.getDownloadURL().then((String dataUrl) {
                  url = dataUrl;
                  Map<String, dynamic> songData = {
                    'title': title,
                    'artist': artist,
                    'uploadedBy': user.email,
                    'imageUrl': imgUrl,
                    'songUrl': dataUrl
                  };
                  print('Adding data for fs');
                  FirebaseFirestore.instance
                      .collection("Songs")
                      .add(songData)
                      .then((value) => print("Uploaded to db"));
                  upStatus = UploadingStatus.Uploaded;
                  notifyListeners();
                  Future.delayed(Duration(seconds: 1), () {
                    upStatus = UploadingStatus.Pop;
                    notifyListeners();
                  });
                  Future.delayed(Duration(seconds: 3), () {
                    upStatus = UploadingStatus.Free;
                    
                    // Navigator.pop();
                    notifyListeners();
                  });
                });
              });
            });
          }));
    }
    notifyListeners();
  }

  ProfileUpdateStatus profileUpdateStatus = ProfileUpdateStatus.Free;
  
  File profileImgFile;
  File coverImgFile;

  profileImgPicker() async{
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      profileImgFile = File(pickedImage.path);
      notifyListeners();
    }
  }
  coverImgPicker() async{
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      coverImgFile = File(pickedImage.path);
      notifyListeners();
    }
  }


  String profileImgUrl;
  String coverImgUrl;
  updateArtistProfile(profileImg, coverImg, bio, username, name){
    if (profileImg != null && coverImg!= null && username!=null && bio != null){
      profileUpdateStatus = ProfileUpdateStatus.Updating;
      notifyListeners();
      Reference profileImgRef = FirebaseStorage.instance.ref().child("profile-pic")
          .child('${randomAlphaNumeric(9)}.jpg');
      Reference coverImgRef = FirebaseStorage.instance.ref().child("cover-img").child('${randomAlpha(9)}.jpg');
      UploadTask task = profileImgRef.putFile(profileImg);
      UploadTask imgUpload = coverImgRef.putFile(coverImg);
      task.then((res) => res.ref.getDownloadURL().then((String url){
        profileImgUrl = url;
        notifyListeners();
        imgUpload.then((res) => res.ref.getDownloadURL().then((String downUrl) {
          coverImgUrl = downUrl;
          notifyListeners();
          Map<String, dynamic> artistData = {
            'profileImg': profileImgUrl,
            'coverImg': coverImgUrl,
            'name': name,
            'bio': bio,
            'username': username,
            'email': user.email,
          };
          FirebaseFirestore.instance.collection("Artists").doc(user.email).set(artistData).then((value) => print("Uploaded to db"));
          profileUpdateStatus = ProfileUpdateStatus.Updated;
          notifyListeners();
          Future.delayed(Duration(seconds: 2), (){
            profileUpdateStatus = ProfileUpdateStatus.Pop;
            notifyListeners();

          });
          profileUpdateStatus = ProfileUpdateStatus.Free;
          notifyListeners();
        }));
      }));
    }
      
    }
  


}

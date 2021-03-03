import 'package:cloud_firestore/cloud_firestore.dart';


class ArtistModel{
  static const PROFILEIMG = 'profileImg';
  static const COVERIMG = 'coverImg';
  static const NAME = 'name';
  static const BIO = 'bio';
  static const EMAIL = 'email';
  static const USERNAME = 'username';

  String _profileImg;
  String _coverImg;
  String _email;
  String _name;
  String _bio;
  String _username;

  String get profileImg => _profileImg;
  String get email => _email;
  String get coverImg => _coverImg;
  String get name => _name;
  String get bio => _bio;
  String get username => _username;


  ArtistModel.fromSnapshot(DocumentSnapshot snapshot){
    _profileImg = snapshot.data()[PROFILEIMG];
    _email = snapshot.data()[EMAIL];
    _coverImg = snapshot.data()[COVERIMG];
    _name = snapshot.data()[NAME];
    _bio = snapshot.data()[BIO];
    _username = snapshot.data()[USERNAME];
  }

}
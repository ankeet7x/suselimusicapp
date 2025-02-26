import 'package:cloud_firestore/cloud_firestore.dart';

class SongModel {
  static const TITLE = 'title';
  static const SONGURL = 'songUrl';
  static const ARTIST = 'artist';
  static const UPLOADER = 'uploadedBy';
  static const COVERIMAGE = 'imageUrl';

  String _title;
  String _songUrl;
  String _imageUrl;
  String _artist;
  String _uploadedBy;

  String get imageUrl => _imageUrl;
  String get title => _title;
  String get songUrl => _songUrl;
  String get artist => _artist;
  String get uploadedBy => _uploadedBy;

  SongModel.fromSnapshot(DocumentSnapshot snapshot) {
    _title = snapshot.data()[TITLE];
    _songUrl = snapshot.data()[SONGURL];
    _artist = snapshot.data()[ARTIST];
    _uploadedBy = snapshot.data()[UPLOADER];
    _imageUrl = snapshot.data()[COVERIMAGE];
  }
}

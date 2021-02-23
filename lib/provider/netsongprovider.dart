import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:suseli/models/songs.dart';

class NetSongProvider extends ChangeNotifier {
  List<SongModel> netSongs = [];

  NetSongProvider.initialize() {
    fetchSongsFromInternet();
  }

  SongModel _songModel;
  SongModel get songModel => _songModel;

  fetchSongsFromInternet() async {
    _songModel = await getSong();
    notifyListeners();
  }

  getSong() async =>
      await FirebaseFirestore.instance.collection('Songs').get().then((doc) {
        for (DocumentSnapshot geet in doc.docs) {
          netSongs.add(SongModel.fromSnapshot(geet));
          notifyListeners();
        }
        notifyListeners();
      });
}

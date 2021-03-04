import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:suseli/models/songs.dart';

enum NetPlayerState { Playing, Paused, Idle }

class NetSongProvider extends ChangeNotifier {
  List<SongModel> netSongs = [];
  AudioPlayer audioPlayer = AudioPlayer();

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

  NetPlayerState netPlayerState = NetPlayerState.Idle;

  // For playing songs from url
  playFromUrl(link) async {
    // String url = 'http://suseli.org/api/songs/2/stream';
    // String url = "https://codingwithjoe.com/wp-content/uploads/2018/03/applause.mp3";
    // String url = 'http://suseli.org/api/songs/download';
    await audioPlayer.stop();
    int result = await audioPlayer.play(link);
    if (result == 1) {
      // print("Played from Url");
      netPlayerState = NetPlayerState.Playing;
      notifyListeners();
    }
    getDuration();
    getPosition();
  }

  pause() async {
    int result = await audioPlayer.pause();
    if (result == 1) {
      // print("Paused");
      netPlayerState = NetPlayerState.Paused;
      notifyListeners();
    }
    notifyListeners();
  }

  // For resuming
  resume() async {
    int result = await audioPlayer.resume();
    if (result == 1) {
      // print("Resumed");
      netPlayerState = NetPlayerState.Playing;
      notifyListeners();
      // play = true;
    }
  }

  // For stopping
  stop() async {
    int result = await audioPlayer.stop();
    if (result == 1) {
      // print("Stopped");
      netPlayerState = NetPlayerState.Idle;
    }
    notifyListeners();
  }

  int currentIndex;

  // Setting current index
  setcurrentIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  // Setting current index for skipping songs
  increasecurrentIndex() {
    currentIndex++;
    if (currentIndex > netSongs.length - 1) {
      currentIndex = 0;
    }
    notifyListeners();
  }

  decreasecurrentIndex() {
    currentIndex--;
    if (currentIndex < 0) {
      currentIndex = netSongs.length - 1;
    }
    notifyListeners();
  }

  //Skipping songs
  playNext() async {
    stop();
    increasecurrentIndex();
    setcurrentIndex(currentIndex);
    playFromUrl(netSongs[currentIndex].songUrl);
    // playFromUrl(currentIndex);
    // print(currentIndex);
  }

  playPrevious() async {
    stop();
    decreasecurrentIndex();
    setcurrentIndex(currentIndex);
    playFromUrl(netSongs[currentIndex].songUrl);
    // print(currentIndex);
  }

  var playerState;
  getPlayerState() {
    audioPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
      // print("current player state $s");
      playerState = s;
      notifyListeners();
    });
  }

  double minimumValue = 0.0, maximumValue = 0.0;
  var duration;
  var durationinS;
  double positioninS;
  var position;
  getDuration() {
    audioPlayer.onDurationChanged.listen((Duration d) {
      // print('Max duration: $d');
      duration = [d.inMinutes, d.inSeconds]
          .map((e) => e.remainder(60).toString().padLeft(2, '0'))
          .join(':');
      maximumValue = d.inMilliseconds.toDouble();
      notifyListeners();
      // print(duration);
    });
  }

  getPosition() {
    audioPlayer.onAudioPositionChanged.listen((Duration p) {
      print("$p");
      position = [p.inMinutes, p.inSeconds]
          .map((e) => e.remainder(60).toString().padLeft(2, '0'))
          .join(':');
      positioninS = p.inMilliseconds.toDouble();
      notifyListeners();
    });
  }
}

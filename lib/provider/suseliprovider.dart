import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

enum MusicState {Playing, Paused, Idle}

class MusicProvider extends ChangeNotifier {
  // MusicProvider() {
  //   this.getSong();
  //   // this.getAlbumInfo();
  //   this.getArtistInfo();
  //   this.getGenreInfo();
  //   // this.getDuration();
  // }

  MusicProvider.initialize() {
    this.getSong();
    this.getArtistInfo();
    this.getAlbumInfo();
    this.getGenreInfo();
    // this.enumPlayerState();
  }

  MusicState musicState = MusicState.Idle;

  
  List<SongInfo> matchedSongs = [];
  searchMusic(val) {
    matchedSongs.clear();
    for(SongInfo song in songs){
      // print(song.title.compareTo(val).toStringAsPrecision(val).toString());
      if (val == song.title.toLowerCase()){
        print(val);
        matchedSongs.add(val);
        print(matchedSongs.length);
      }
    }
    // print(songs.where((element) => element=val).toString());
  }

  //Colors
  Color bgColor = const Color(0xFF2a27d0);
  Color white = Colors.white;
  Color purple = const Color(0xFF5654B4);

  // For fetching songs
  AudioPlayer audioPlayer = AudioPlayer();
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  List<SongInfo> songs;
  List<ArtistInfo> artists;
  List<GenreInfo> genres;
  List<AlbumInfo> albums;

  Future<List<SongInfo>> getSong() async {
    List<SongInfo> songList = await audioQuery.getSongs();
    // print(songList.length);
    songs = songList;
    notifyListeners();
    return songs;
  }

  void getArtistInfo() async {
    List<ArtistInfo> artistList = await audioQuery.getArtists();
    artists = artistList;
    notifyListeners();
  }

  void getGenreInfo() async {
    List<GenreInfo> genreList = await audioQuery.getGenres();
    genres = genreList;
    notifyListeners();
  }

  void getAlbumInfo() async {
    List<AlbumInfo> albumList = await audioQuery.getAlbums();
    albums = albumList;
    notifyListeners();
  }

  playLocal(index) async {
    int result = await audioPlayer.play(songs[index].filePath);
    if (result == 1) {
      // print("Played");
      musicState = MusicState.Playing;
      notifyListeners();
      // play = true;
    }
    notifyListeners();
  }

  // For pausing

  pause() async {
    int result = await audioPlayer.pause();
    if (result == 1) {
      // print("Paused");
      musicState = MusicState.Paused;
      notifyListeners();
      // play = false;
    }
    notifyListeners();
  }

  // For resuming
  resume() async {
    int result = await audioPlayer.resume();
    if (result == 1) {
      // print("Resumed");
      musicState = MusicState.Playing;
      // play = true;
    }
  }

  // For stopping
  stop() async {
    int result = await audioPlayer.stop();
    if (result == 1) {
      // print("Stopped");
      musicState = MusicState.Idle;
      // play = false;
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
    notifyListeners();
  }

  decreasecurrentIndex() {
    currentIndex--;
    notifyListeners();
  }

  //Skipping songs
  playNext() async {
    stop();
    increasecurrentIndex();
    setcurrentIndex(currentIndex);
    playLocal(currentIndex);
    // print(currentIndex);
  }

  playPrevious() async {
    stop();
    decreasecurrentIndex();
    setcurrentIndex(currentIndex);
    playLocal(currentIndex);
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
      // if (positioninS == maximumValue){
      //   increasecurrentIndex();
      // }
    });
  }

  // AudioPicker audioPicker = AudioPicker();
  var path;
  // selectSong() async {
  //   path = await AudioPicker.pickAudio();
  // }
}

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'suseliprovider.dart';
import 'package:provider/provider.dart';

class MusicPage extends StatefulWidget {
  @override
  _MusicPageState createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  String currentValue;
  @override
  Widget build(BuildContext context) {
    // print("Started from scratch");
    final songQ = Provider.of<MusicProvider>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back,
              color: Color(0xFF5654B4),
              size: 24,
            )),
        title: Consumer<MusicProvider>(
          builder: (context, data, child) => Text(
            "Now Playing",
            style: TextStyle(color: data.purple, fontSize: 24),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.1,
              ),
              CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage(
                  "assets/download.jpeg",
                ),
                radius: 120,
              ),
              SizedBox(
                height: size.height * 0.1,
              ),
              Center(
                child: Text(
                  songQ.songs[songQ.currentIndex].title,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                child: Center(
                  child: Text(
                    songQ.songs[songQ.currentIndex].artist,
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                ),
                // height: size.height * 0.2,
              ),
              SizedBox(height: size.height * 0.1),
              Slider(
                value: songQ.positioninS,
                activeColor: songQ.purple,
                inactiveColor: Colors.grey,
                onChanged: (value) {
                  songQ.positioninS = value;
                  songQ.audioPlayer
                      .seek(Duration(milliseconds: songQ.positioninS.round()));
                },
                max: songQ.maximumValue,
                min: songQ.minimumValue,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 22),
                      child: Text(
                        songQ.position,
                        style: TextStyle(fontSize: 15),
                      )),
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                      margin: EdgeInsets.only(right: 22),
                      child: Text(
                        songQ.duration,
                        style: TextStyle(fontSize: 15),
                      )),
                ],
              ),
              SizedBox(height: size.height * 0.1),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.skip_previous,
                          color: Color(0xFF516599),
                          size: 42,
                        ),
                        onPressed: () {
                          songQ.playPrevious();
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      child: IconButton(
                        icon: songQ.playerState == AudioPlayerState.PLAYING
                            ? Icon(
                                Icons.pause,
                                size: 60,
                              )
                            : Icon(Icons.play_arrow, size: 60),
                        onPressed: () {
                          songQ.getPlayerState();
                          if (songQ.playerState == AudioPlayerState.PLAYING) {
                            songQ.pause();
                          } else if (songQ.playerState ==
                              AudioPlayerState.PAUSED) {
                            songQ.resume();
                          }
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(0.0),
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.skip_next,
                            color: Color(0xFF516599),
                            size: 42,
                          ),
                          onPressed: () {
                            songQ.playNext();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

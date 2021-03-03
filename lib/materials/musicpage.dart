import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:suseli/provider/netsongprovider.dart';
import '../provider/suseliprovider.dart';
import 'package:provider/provider.dart';

class MusicPage extends StatefulWidget {
  final String source;
  MusicPage({this.source});
  @override
  _MusicPageState createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  String currentValue;
  @override
  Widget build(BuildContext context) {
    // print("Started from scratch");
    final songQ = Provider.of<MusicProvider>(context);
    final netPro = Provider.of<NetSongProvider>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [],
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back,
              color: Color(0xFF5654B4),
              size: 24,
            )),
        title: Text(
          "Now Playing",
          style: TextStyle(color: Colors.purple, fontSize: 24),
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
              Container(
                height: 200,
                width: 200,
                child: widget.source == 'local'
                    ? CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage(
                          "assets/download.jpeg",
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(150),
                        child: CachedNetworkImage(
                          imageUrl:
                              netPro.netSongs[netPro.currentIndex].imageUrl,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        )),
              ),
              SizedBox(
                height: size.height * 0.1,
              ),
              Center(
                child: widget.source == 'local'
                    ? Text(
                        songQ.songs[songQ.currentIndex].title,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      )
                    : Text(
                        netPro.netSongs[netPro.currentIndex].title,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
              ),
              SizedBox(
                child: Center(
                  child: widget.source == 'local'
                      ? Text(
                          songQ.songs[songQ.currentIndex].artist,
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold),
                        )
                      : Text(
                          netPro.netSongs[netPro.currentIndex].artist,
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold),
                        ),
                ),
                // height: size.height * 0.2,
              ),
              SizedBox(height: size.height * 0.1),
              Container(
                child: widget.source == 'local'
                    ? Slider(
                        value: songQ.positioninS,
                        activeColor: songQ.purple,
                        inactiveColor: Colors.grey,
                        onChanged: (value) {
                          songQ.positioninS = value;
                          songQ.audioPlayer.seek(Duration(
                              milliseconds: songQ.positioninS.round()));
                        },
                        max: songQ.maximumValue,
                        min: songQ.minimumValue,
                      )
                    : Slider(
                        value: netPro.positioninS,
                        activeColor: Colors.purple,
                        inactiveColor: Colors.grey,
                        onChanged: (value) {
                          netPro.positioninS = value;
                          netPro.audioPlayer.seek(Duration(
                              milliseconds: netPro.positioninS.round()));
                        },
                        max: netPro.maximumValue,
                        min: netPro.minimumValue,
                      ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 22),
                      child: widget.source == 'local'
                          ? Text(
                              songQ.position,
                              style: TextStyle(fontSize: 15),
                            )
                          : Text(
                              netPro.position,
                              style: TextStyle(fontSize: 15),
                            )),
                  // Expanded(
                  //   child: Container(),
                  // ),
                  Container(
                      margin: EdgeInsets.only(right: 22),
                      child: widget.source == 'local'
                          ? Text(
                              songQ.duration,
                              style: TextStyle(fontSize: 15),
                            )
                          : Text(
                              netPro.duration,
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
                          if (widget.source == "local") {
                            songQ.playPrevious();
                          } else {
                            netPro.playPrevious();
                          }
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      child: widget.source == 'local'
                          ? IconButton(
                              icon:
                                  songQ.playerState == AudioPlayerState.PLAYING
                                      ? Icon(
                                          Icons.pause,
                                          size: 60,
                                        )
                                      : Icon(Icons.play_arrow, size: 60),
                              onPressed: () {
                                songQ.getPlayerState();
                                if (songQ.playerState ==
                                    AudioPlayerState.PLAYING) {
                                  songQ.pause();
                                } else if (songQ.playerState ==
                                    AudioPlayerState.PAUSED) {
                                  songQ.resume();
                                }
                              },
                            )
                          : IconButton(
                              icon:
                                  netPro.playerState == AudioPlayerState.PLAYING
                                      ? Icon(
                                          Icons.pause,
                                          size: 60,
                                        )
                                      : Icon(Icons.play_arrow, size: 60),
                              onPressed: () {
                                netPro.getPlayerState();
                                if (netPro.playerState ==
                                    AudioPlayerState.PLAYING) {
                                  netPro.pause();
                                } else if (netPro.playerState ==
                                    AudioPlayerState.PAUSED) {
                                  netPro.resume();
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
                            if (widget.source == "local") {
                              songQ.playNext();
                            } else {
                              netPro.playNext();
                            }
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

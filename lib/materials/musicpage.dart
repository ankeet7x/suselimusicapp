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
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back,
              color: Color(0xFF03C6C7),
              size: 24,
            )),
        title: Text(
          "Now Playing",
          style: TextStyle(color: Color(0xFF03C6C7), fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: size.height,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.08,
            ),
            Container(
              height: size.height * 0.25,
              width: size.height * 0.25,
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
                        imageUrl: netPro.netSongs[netPro.currentIndex].imageUrl,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      )),
            ),
            SizedBox(
              height: size.height * 0.12,
            ),
            //Song title
            Center(
              child: widget.source == 'local'
                  ? Container(
                      child: Text(
                        songQ.songs[songQ.currentIndex].title.trim(),
                        style: TextStyle(
                            color: Color(0xFF03C6C7),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : Text(
                      netPro.netSongs[netPro.currentIndex].title,
                      style: TextStyle(
                          color: Color(0xFF03C6C7),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
            ),
            SizedBox(
              child: Center(
                child: widget.source == 'local'
                    ? Text(
                        songQ.songs[songQ.currentIndex].artist,
                        style: TextStyle(
                            fontSize: 19,
                            color: Color(0xFF03C6C7),
                            fontWeight: FontWeight.bold),
                      )
                    : Text(
                        netPro.netSongs[netPro.currentIndex].artist,
                        style: TextStyle(
                            fontSize: 19,
                            color: Color(0xFF03C6C7),
                            fontWeight: FontWeight.bold),
                      ),
              ),
              // height: size.height * 0.2,
            ),
            SizedBox(height: size.height * 0.12),
            //Slider
            Container(
              child: widget.source == 'local'
                  ? Slider(
                      value: songQ.positioninS,
                      activeColor: Color(0xFF03C6C7),
                      inactiveColor: Colors.grey,
                      onChanged: (value) {
                        songQ.positioninS = value;
                        songQ.audioPlayer.seek(
                            Duration(milliseconds: songQ.positioninS.round()));
                      },
                      max: songQ.maximumValue,
                      min: songQ.minimumValue,
                    )
                  : Slider(
                      value: netPro.positioninS,
                      activeColor: Color(0xFF03C6C7),
                      inactiveColor: Colors.grey,
                      onChanged: (value) {
                        netPro.positioninS = value;
                        netPro.audioPlayer.seek(
                            Duration(milliseconds: netPro.positioninS.round()));
                      },
                      max: netPro.maximumValue,
                      min: netPro.minimumValue,
                    ),
            ),

            //Duration and Position

            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    width: size.width * 0.79,
                    margin: EdgeInsets.only(left: 22),
                    child: widget.source == 'local'
                        ? Text(
                            songQ.position,
                            style: TextStyle(
                                fontSize: 15, color: Color(0xFF03C6C7)),
                          )
                        : Text(
                            netPro.position,
                            style: TextStyle(
                                fontSize: 15, color: Color(0xFF03C6C7)),
                          )),
                // Expanded(
                //   child: Container(),
                // ),
                Container(
                    margin: EdgeInsets.only(right: 22),
                    child: widget.source == 'local'
                        ? Text(
                            songQ.duration,
                            style: TextStyle(fontSize: 15, color: Color(0xFF03C6C7)),
                          )
                        : Text(
                            netPro.duration,
                            style: TextStyle(fontSize: 15, color: Color(0xFF03C6C7)),
                          )),
              ],
            ),
            SizedBox(height: size.height * 0.04),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.skip_previous,
                      color: Color(0xFF03C6C7),
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
                  height: size.height * 0.08,
                  width: size.width * 0.18,
                  // margin: const EdgeInsets.all(10.0),
                  child: widget.source == 'local'
                      ? Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: IconButton(
                            icon: songQ.playerState == AudioPlayerState.PLAYING
                                ? Icon(
                                    Icons.pause,
                                    size: 70,
                                    color: Color(0xFF03C6C7),
                                  )
                                : Icon(
                                    Icons.play_arrow,
                                    size: 70,
                                    color: Color(0xFF03C6C7),
                                  ),
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
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: IconButton(
                            icon: netPro.playerState == AudioPlayerState.PLAYING
                                ? Icon(
                                    Icons.pause,
                                    size: 70,
                                    color: Colors.purple,
                                  )
                                : Icon(Icons.play_arrow,
                                    color: Colors.purple, size: 70),
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
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.skip_next,
                      color: Color(0xFF03C6C7),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}

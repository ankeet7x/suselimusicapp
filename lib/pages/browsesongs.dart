import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suseli/materials/musicpage.dart';
import 'package:suseli/provider/netsongprovider.dart';
import 'package:suseli/provider/suseliprovider.dart';

class BrowseSongs extends StatefulWidget {
  @override
  _BrowseSongsState createState() => _BrowseSongsState();
}

class _BrowseSongsState extends State<BrowseSongs> {
  @override
  Widget build(BuildContext context) {
    final songProvider = Provider.of<NetSongProvider>(context);
    final localProvider = Provider.of<MusicProvider>(context);
    final size = MediaQuery.of(context).size;
    // final playerProvider = Provider.of<MusicProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Songs"),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                songProvider.netSongs.clear();
                songProvider.fetchSongsFromInternet();
              },
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                child: ListView.builder(
                  itemCount: songProvider.netSongs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Container(
                        width: 55,
                        height: 55,
                        child: songProvider.netSongs[index].imageUrl == null
                            ? Icon(Icons.music_note)
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      songProvider.netSongs[index].imageUrl,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                      ),
                      subtitle: Text(songProvider.netSongs[index].artist),
                      title: Text(songProvider.netSongs[index].title == null
                          ? "Null title"
                          : songProvider.netSongs[index].title),
                      onTap: () {
                        localProvider.stop();
                        // print(index);
                        songProvider.stop();
                        songProvider.getPlayerState();
                        songProvider.setcurrentIndex(index);
                        songProvider.playFromUrl(songProvider
                            .netSongs[songProvider.currentIndex].songUrl);

                        Future.delayed(Duration(seconds: 2), () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MusicPage(source: "internet")));
                        });
                      },
                    );
                  },
                ),
              ),
            ),
            Consumer<NetSongProvider>(
              builder: (context, netPro, child) {
                switch (netPro.netPlayerState) {
                  case NetPlayerState.Playing:
                    return GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MusicPage(source: 'internet'))),
                      child: Container(
                        height: size.height * 0.07,
                        color: Colors.blue,
                        child: Row(
                          children: [
                            Text(netPro.netSongs[netPro.currentIndex].title),
                            IconButton(
                              icon: Icon(Icons.skip_previous),
                              onPressed: () {
                                songProvider.stop();
                                netPro.playPrevious();
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.pause),
                              onPressed: () {
                                songProvider.stop();
                                netPro.pause();
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.skip_next),
                              onPressed: () {
                                songProvider.stop();
                                netPro.playPrevious();
                              },
                            )
                          ],
                        ),
                      ),
                    );
                    break;
                  case NetPlayerState.Paused:
                    return GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MusicPage(source: 'internet'))),
                      child: Container(
                        height: size.height * 0.07,
                        color: Colors.blue,
                        child: Row(
                          children: [
                            Text(netPro.netSongs[netPro.currentIndex].title),
                            IconButton(
                              icon: Icon(Icons.skip_previous),
                              onPressed: () {
                                songProvider.stop();
                                netPro.playPrevious();
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.play_arrow),
                              onPressed: () {
                                songProvider.stop();
                                netPro.resume();
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.skip_next),
                              onPressed: () {
                                songProvider.stop();
                                netPro.playPrevious();
                              },
                            )
                          ],
                        ),
                      ),
                    );
                    break;
                  case NetPlayerState.Idle:
                    return Container();
                    break;
                }
              },
            )
          ],
        ));
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      child: Container(
                        child: ListTile(
                          leading: Container(
                            width: 55,
                            height: 55,
                            child: songProvider.netSongs[index].imageUrl == null
                                ? Icon(Icons.music_note)
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl:
                                          songProvider.netSongs[index].imageUrl,
                                      placeholder: (context, url) =>
                                          Container(),
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
                        ),
                      ),
                      secondaryActions: [
                        IconSlideAction(
                          caption: 'Delete',
                          color: Colors.white,
                          icon: Icons.delete,
                          onTap: () {
                            print('delete clicked');
                          },
                        ),
                        IconSlideAction(
                            caption: "Report",
                            color: Colors.white,
                            icon: Icons.report,
                            onTap: () {
                              songProvider.addSongsForReview(songProvider.netSongs[index].title);
                              print('The song is sent to the admin for a review');
                              return Fluttertoast.showToast(msg: "The song will be reviewed by admins");
                            })
                      ],
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
                            height: size.height * 0.08,
                            color: Color(0xFF5654B4),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top:5.0),
                                  child: Text(songProvider.netSongs[songProvider.currentIndex].title, style: TextStyle(
                                    color: Colors.white
                                  ),),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.3,
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.skip_previous, color: Colors.white,),
                                      onPressed: () {
                                        localProvider.stop();
                                        songProvider.playPrevious();
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.pause, color: Colors.white,),
                                      onPressed: () {
                                        localProvider.stop();
                                        songProvider.pause();
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.skip_next, color: Colors.white),
                                      onPressed: () {
                                        localProvider.stop();
                                        songProvider.playNext();
                                      },
                                    )
                                  ],
                                ),
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

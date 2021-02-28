import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suseli/materials/musicpage.dart';
import 'package:suseli/provider/netsongprovider.dart';

class BrowseSongs extends StatefulWidget {
  @override
  _BrowseSongsState createState() => _BrowseSongsState();
}

class _BrowseSongsState extends State<BrowseSongs> {
  @override
  Widget build(BuildContext context) {
    final songProvider = Provider.of<NetSongProvider>(context);
    // final playerProvider = Provider.of<MusicProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Songs"),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: (){
                songProvider.netSongs.clear();
                songProvider.fetchSongsFromInternet();
              },
            )
          ],
        ),
        body: Container(
          child: ListView.builder(
            itemCount: songProvider.netSongs.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Container(
                  width: 55,
                  height: 55,
                  child: songProvider.netSongs[index].imageUrl == null ? Icon(Icons.music_note): ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CachedNetworkImage(
                      imageUrl: songProvider.netSongs[index].imageUrl,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
                subtitle: Text(songProvider.netSongs[index].artist),
                title: Text(songProvider.netSongs[index].title == null
                    ? "Null title"
                    : songProvider.netSongs[index].title),
                onTap: () {
                  // print(index);
                  songProvider.setcurrentIndex(index);
                  songProvider
                      .playFromUrl(songProvider.netSongs[songProvider.currentIndex].songUrl);

                 Future.delayed(Duration(seconds: 3), (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MusicPage(source: "internet")));
                 });
                },
              );
            },
          ),
        ));
  }
}

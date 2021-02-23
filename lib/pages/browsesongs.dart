import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suseli/materials/dbprovider.dart';
import 'package:suseli/materials/musicpage.dart';
import 'package:suseli/materials/suseliprovider.dart';
import 'package:suseli/provider/netsongprovider.dart';

class BrowseSongs extends StatefulWidget {
  @override
  _BrowseSongsState createState() => _BrowseSongsState();
}

class _BrowseSongsState extends State<BrowseSongs> {
  @override
  Widget build(BuildContext context) {
    final songProvider = Provider.of<NetSongProvider>(context);
    final playerProvider = Provider.of<MusicProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Songs"),
          actions: [
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                print(songProvider.netSongs.length);
              },
            )
          ],
        ),
        body: Container(
          child: ListView.builder(
            itemCount: songProvider.netSongs.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(songProvider.netSongs[index].title == null
                    ? "Null title"
                    : songProvider.netSongs[index].title),
                onTap: () {
                  // print(index);
                  playerProvider
                      .playFromUrl(songProvider.netSongs[index].songUrl);

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MusicPage()));
                },
              );
            },
          ),
        ));
  }
}

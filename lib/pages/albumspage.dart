import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suseli/materials/suseliprovider.dart';

class AlbumPage extends StatefulWidget {
  @override
  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MusicProvider>(
      builder: (context, songP, child) => ListView.builder(
        itemCount: songP.albums.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(songP.songs[index].album),
          onTap: () {
            // print(songP.albums.length);
            songP.albums.forEach((album) { 
              print(album.title + album.numberOfSongs);
            });
          },
        ),
      ),
    );
  }
}

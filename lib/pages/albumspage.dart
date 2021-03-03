import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suseli/provider/suseliprovider.dart';

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
          title: Text(songP.albums[index].title),
          onTap: () {
            // print(songP.albums.length);
            print(songP.albums[index].numberOfSongs);
            // Navigator.push(context, MaterialPageRoute(builder: (context) => ))
            // songP.albums.forEach((album) {
            //   print("The songs are:" +album.title + album.numberOfSongs + album.numberOfSongs);
            // });
          },
        ),
      ),
    );
  }
}

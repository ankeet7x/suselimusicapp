import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suseli/provider/suseliprovider.dart';

class GenrePage extends StatefulWidget {
  @override
  _GenrePageState createState() => _GenrePageState();
}

class _GenrePageState extends State<GenrePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MusicProvider>(
      builder: (context, songP, child) => ListView.builder(
        itemCount: songP.artists.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(songP.songs[index].artist),
          onTap: () => print(songP.genres.length),
        ),
      ),
    );
  }
}

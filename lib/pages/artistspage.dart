import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suseli/provider/suseliprovider.dart';

class ArtistPage extends StatefulWidget {
  @override
  _ArtistPageState createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MusicProvider>(
      builder: (context, songP, child) => ListView.builder(
        itemCount: songP.artists.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(songP.songs[index].artist),
          onTap: () {},
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suseli/materials/musicpage.dart';
import 'package:suseli/materials/suseliprovider.dart';

class SongPage extends StatefulWidget {
  @override
  _SongPageState createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MusicProvider>(
      builder: (context, songP, child) => ListView.builder(
        itemCount: songP.songs.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(songP.songs[index].title),
            leading: Icon(Icons.music_note),
            subtitle: Text(songP.songs[index].artist),
            trailing: Icon(Icons.more_vert),
            onLongPress: () {},
            onTap: () {
              songP.playLocal(index);
              songP.setcurrentIndex(index);
              print(songP.songs[index].artistId);
              songP.getDuration();
              songP.getPlayerState();
              print('Artist is : ${songP.songs[index].artistId}');
              songP.getPosition();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MusicPage()));
            },
          );
        },
      ),
    );
  }
}

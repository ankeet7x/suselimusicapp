import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suseli/materials/musicpage.dart';
import 'package:suseli/provider/netsongprovider.dart';
import 'package:suseli/provider/suseliprovider.dart';

class SongPage extends StatefulWidget {
  @override
  _SongPageState createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  @override
  Widget build(BuildContext context) {
    final songP = Provider.of<MusicProvider>(context);
    final netProvider = Provider.of<NetSongProvider>(context);
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height,
      child: songP.songs.length == null
          ? CircularProgressIndicator()
          : ListView.builder(
              itemCount: songP.songs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(songP.songs[index].title),
                  leading: Icon(Icons.music_note),
                  subtitle: Text(songP.songs[index].artist),
                  trailing: IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () {
                      print("More vert");
                    },
                  ),
                  onLongPress: () {},
                  onTap: () {
                    netProvider.stop();
                    songP.stop();
                    songP.playLocal(index);
                    songP.setcurrentIndex(index);
                    print(songP.songs[index].artistId);
                    print("album: " + songP.songs[index].albumArtwork);
                    songP.getDuration();
                    songP.getPlayerState();
                    print('Artist is : ${songP.songs[index].artistId}');
                    songP.getPosition();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MusicPage(
                                  source: "local",
                                )));
                  },
                );
              },
            ),
    );
  }
}

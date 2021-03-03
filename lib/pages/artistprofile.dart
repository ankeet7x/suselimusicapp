import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suseli/provider/artistprovider.dart';
import 'package:suseli/provider/netsongprovider.dart';
import 'package:suseli/widgets/covernpro.dart';

class ArtistProfile extends StatefulWidget {
  // final String email;
  // ArtistProfile({this.email});

  @override
  _ArtistProfileState createState() => _ArtistProfileState();
}

class _ArtistProfileState extends State<ArtistProfile> {
  @override
  Widget build(BuildContext context) {
    final netSongPro = Provider.of<NetSongProvider>(context);
    final artistPro = Provider.of<GetArtists>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Artist"),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            ImageStack(
              profileImg: artistPro.currentArtistProfile,
              coverImg: artistPro.currentArtistCover,
            ),
            Text(artistPro.currentArtistName),
            Text(artistPro.currentArtistuserName),
            Text(artistPro.currentArtistbio),
            SizedBox(height:size.height*0.01),
            Text("Songs by ${artistPro.currentArtistuserName} :"),
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount: netSongPro.netSongs.length,
                itemBuilder: (BuildContext context, int index){
                  if (artistPro.currentArtistEm == netSongPro.netSongs[index].uploadedBy){
                    return ListTile(
                      title: Text(netSongPro.netSongs[index].title),
                      subtitle: Text(netSongPro.netSongs[index].artist),
                    );
                  }else{
                    return Container();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

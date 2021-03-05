import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suseli/materials/musicpage.dart';
import 'package:suseli/provider/artistprovider.dart';
import 'package:suseli/provider/netsongprovider.dart';
import 'package:suseli/provider/suseliprovider.dart';
import 'package:suseli/widgets/covernpro.dart';
import 'package:suseli/widgets/textwidget.dart';

class ArtistProfile extends StatefulWidget {
  @override
  _ArtistProfileState createState() => _ArtistProfileState();
}

class _ArtistProfileState extends State<ArtistProfile> {
  @override
  Widget build(BuildContext context) {
    final netSongPro = Provider.of<NetSongProvider>(context);
    final localProvider = Provider.of<MusicProvider>(context);
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
            TextWid(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              value: artistPro.currentArtistName,
            ),
            TextWid(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              value: '@' + artistPro.currentArtistuserName,
            ),
            TextWid(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              value: artistPro.currentArtistbio,
            ),
            Divider(),
            SizedBox(height: size.height * 0.01),
            TextWid(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              value: "Songs by ${artistPro.currentArtistuserName} :",
            ),
            SizedBox(height: size.height * 0.01),
            Positioned(
              // right: (size.width + 20) / 2,
              child: Expanded(
                flex: 2,
                child: ListView.builder(
                  itemCount: netSongPro.netSongs.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (artistPro.currentArtistEm ==
                        netSongPro.netSongs[index].uploadedBy) {
                      return ListTile(
                        // leading: Text((index+1).toString()),
                        // trailing: IconButton(icon: Icon(Icons.delete), onPressed: (){},),
                        title: Text(netSongPro.netSongs[index].title),
                        subtitle: Text(netSongPro.netSongs[index].artist),
                        onTap: (){
                          localProvider.stop();
                            // print(index);
                            netSongPro.stop();
                            netSongPro.getPlayerState();
                            netSongPro.setcurrentIndex(index);
                            netSongPro.playFromUrl(netSongPro
                                .netSongs[netSongPro.currentIndex].songUrl);

                            Future.delayed(Duration(seconds: 2), () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MusicPage(source: "internet")));
                            });
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

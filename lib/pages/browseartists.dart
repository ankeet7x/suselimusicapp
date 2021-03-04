import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suseli/provider/artistprovider.dart';
import 'package:suseli/provider/dbprovider.dart';
import 'package:suseli/widgets/artistcard.dart';

import 'artistprofile.dart';

class BrowseArtist extends StatefulWidget {
  @override
  _BrowseArtistState createState() => _BrowseArtistState();
}

class _BrowseArtistState extends State<BrowseArtist> {
  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    // final db = Provider.of<DbProvider>(context);
    final artistPro = Provider.of<GetArtists>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Browse Artists"),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                print(artistPro.artists.length);
              })
        ],
      ),
      body: GridView.builder(
          itemCount: artistPro.artists.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              // childAspectRatio: size.width/0.4*size.height,
              crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
                onTap: () async {
                  await artistPro
                      .getCertainArtist(artistPro.artists[index].email);
                  // print(artistPro.artists[index].email);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ArtistProfile()));
                },
                child: ArtistCard(
                  name: artistPro.artists[index].name,
                  profileImg: artistPro.artists[index].profileImg,
                ));
          }),
    );
  }
}

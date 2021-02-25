import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:suseli/pages/albumspage.dart';
import 'package:suseli/pages/artistspage.dart';
import 'package:suseli/pages/browsesongs.dart';
import 'package:suseli/pages/genrespage.dart';
import 'package:suseli/pages/songspage.dart';
import 'package:suseli/pages/uploadpage.dart';
import 'package:suseli/provider/dbprovider.dart';
import 'package:suseli/provider/netsongprovider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  List<Widget> pages = [SongPage(), ArtistPage(), AlbumPage(), GenrePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(children: [
          DrawerHeader(
              // ignore: missing_return
              child: Consumer<DbProvider>(builder: (context, db, child) {
            switch (db.status) {
              case Status.Unauthenticaed:
                return Icon(Icons.person);
                break;
              case Status.Authenticating:
                return CircularProgressIndicator();
                break;
              case Status.Authenticated:
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(db.user.photoURL)),
                    ),
                    Text(db.user.displayName),
                  ],
                );
                break;
            }
          })),
          Consumer<NetSongProvider>(
            builder: (context, netSong, child) => MaterialButton(
              child: Text("Browse Songs"),
              onPressed: () async {
                // await db.();
                netSong.netSongs.clear();
                await netSong.fetchSongsFromInternet();

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BrowseSongs()));
              },
            ),
          ),
          Consumer<DbProvider>(
            builder: (context, db, child) {
              switch (db.status) {
                case Status.Unauthenticaed:
                  return Container();
                  break;
                case Status.Authenticating:
                  return Container();
                  break;
                case Status.Authenticated:
                  return MaterialButton(
                    color: Colors.cyan,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UploadPage()));
                    },
                    child: Text("Upload Page"),
                  );
                  break;
              }
            },
          ),
          Consumer<DbProvider>(builder: (context, db, child) {
            switch (db.status) {
              case Status.Unauthenticaed:
                return IconButton(
                    icon: Icon(
                      Icons.login,
                    ),
                    onPressed: () {
                      print("pressed");
                      db.signInWithGoogle();
                    });
                break;
              case Status.Authenticating:
                return CircularProgressIndicator();
                break;
              case Status.Authenticated:
                return Text("You're logged in");
                break;
            }
          }),
          Consumer<DbProvider>(
            // ignore: missing_return
            builder: (context, db, child) {
              switch (db.status) {
                case Status.Unauthenticaed:
                  return Container();
                  break;
                case Status.Authenticating:
                  return CircularProgressIndicator();
                  break;
                case Status.Authenticated:
                  return IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () {
                      db.signOutWithGoogle();
                    },
                  );
                  break;
              }
            },
          )
        ]),
      ),
      body: DefaultTabController(
        length: 4,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                bottom: TabBar(
                  isScrollable: false,
                  // labelColor: Color(0xFF5454f4),
                  // unselectedLabelColor: Colors.white,
                  unselectedLabelColor: Colors.yellow,
                  labelColor: Colors.white,

                  indicatorColor: Colors.black,
                  tabs: [
                    Tab(
                      child: Text("Songs"),
                    ),
                    Tab(
                      child: Text("Artists"),
                    ),
                    Tab(
                      child: Text("Albums"),
                    ),
                    Tab(
                      child: Text("Genres"),
                    ),
                  ],
                ),
                expandedHeight: 180.0,
                floating: false,
                title: Text("Suseli"),
                // backgroundColor: Color(0xFF5454f4),
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 28.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // crossAxisAlignment: CrossAxisAlignment/s,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 0),
                          height: 20,
                          width: 20,
                          child: GestureDetector(
                            child: SvgPicture.asset(
                              'assets/menu.svg',
                              color: Colors.white,
                            ),
                            onTap: () {
                              print('tapped');
                            },
                          ),
                        ),
                        Expanded(
                          child: TextField(),
                        ),
                        IconButton(
                          icon: Icon(Icons.info),
                          onPressed: () {},
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: pages,
          ),
        ),
      ),
    );
  }
}

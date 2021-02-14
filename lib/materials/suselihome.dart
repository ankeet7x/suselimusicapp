import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:suseli/materials/musicpage.dart';
import 'package:suseli/materials/suseliprovider.dart';
import 'package:suseli/pages/albumspage.dart';
import 'package:suseli/pages/artistspage.dart';
import 'package:suseli/pages/genrespage.dart';
import 'package:suseli/pages/songspage.dart';
import 'package:suseli/pages/uploadpage.dart';

import 'dbprovider.dart';

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
                  indicatorColor: Colors.transparent,
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

    //   return DefaultTabController(
    //       length: 4,
    //       child: Scaffold(
    //         appBar: AppBar(
    //           title: Text("Suseli"),
    //           bottom: TabBar(
    //             indicatorColor: Colors.yellow,
    //             labelColor: Colors.pink,
    //             unselectedLabelColor: Colors.yellow,
    //             // isScrollable: true,
    //             // isScrollable: true,
    //             // controller: _tabController,
    //             tabs: [
    //               Tab(
    //                 child: Text("Songs"),
    //               ),
    //               Tab(
    //                 child: Text("Artists"),
    //               ),
    //               Tab(
    //                 child: Text("Albums"),
    //               ),
    //               Tab(
    //                 child: Text("Genres"),
    //               ),
    //             ],
    //           ),
    //         ),
    //         body: CustomScrollView(
    //           slivers: [
    //             SliverAppBar(
    //               expandedHeight: 200,
    //               floating: true,
    //             ),
    //             SliverFillRemaining(
    //               child: TabBarView(
    //                 children: pages,
    //               ),
    //             )
    //           ],
    //         ),
    //         extendBody: true,
    //         bottomSheet: GestureDetector(
    //           onTap: () => Navigator.push(
    //               context, MaterialPageRoute(builder: (context) => MusicPage())),
    //           child: songP.changedState
    //               ? Container(
    //                   height: size.height * 0.075,
    //                   color: Colors.blue,
    //                   child: Padding(
    //                     padding: const EdgeInsets.fromLTRB(18.0, 0, 0, 0),
    //                     child: Row(
    //                       children: [
    //                         Icon(Icons.music_note),
    //                         Column(
    //                           children: [
    //                             // Text("yo")
    //                             Text(songP.songs[songP.currentIndex].title),
    //                             Text(songP.songs[songP.currentIndex].artist)
    //                           ],
    //                         )
    //                       ],
    //                     ),
    //                   ),
    //                 )
    //               : Text(""),
    //         ),
    //       ));
  }
}

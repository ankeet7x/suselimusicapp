import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suseli/materials/musicpage.dart';
import 'package:suseli/pages/albumspage.dart';
import 'package:suseli/pages/artistprofile.dart';
import 'package:suseli/pages/artistspage.dart';
import 'package:suseli/pages/browseartists.dart';
import 'package:suseli/pages/browsesongs.dart';
import 'package:suseli/pages/classifypage.dart';
import 'package:suseli/pages/genrespage.dart';
import 'package:suseli/pages/profile.dart';
import 'package:suseli/pages/profileedit.dart';
import 'package:suseli/pages/songspage.dart';
import 'package:suseli/pages/uploadpage.dart';
import 'package:suseli/provider/artistprovider.dart';
import 'package:suseli/provider/dbprovider.dart';
import 'package:suseli/provider/netsongprovider.dart';
import 'package:suseli/provider/suseliprovider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TextEditingController _searchController = TextEditingController();
  List<Widget> pages = [SongPage(), ArtistPage(), AlbumPage(), GenrePage()];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final netProvider = Provider.of<NetSongProvider>(context);
    final db = Provider.of<DbProvider>(context);
    final artistProvider = Provider.of<GetArtists>(context);
    final musicProvider = Provider.of<MusicProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: Drawer(
        elevation: 10,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DrawerHeader(
                  // ignore: missing_return
                  child: Consumer<DbProvider>(builder: (context, db, child) {
                switch (db.status) {
                  case Status.Unauthenticaed:
                    return CircleAvatar(
                        radius: 45,
                        backgroundColor: Color(0xFF5654B4),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 58,
                        ));
                    break;
                  case Status.Authenticating:
                    return Container();
                    break;
                  case Status.Authenticated:
                    return Column(
                      children: [
                        CircleAvatar(
                            radius: 45,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: CachedNetworkImage(
                                imageUrl: db.user.photoURL,
                                placeholder: (context, url) => Container(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            )),
                        SizedBox(height: 5),
                        // Text(
                        //   db.user.displayName,
                        //   style: TextStyle(color: Color(0xFF5654B4), fontSize: 18),
                        // ),
                      ],
                    );
                    break;
                }
              })),
              // Consumer<DbProvider>(
              //   builder: (context, db, child) {
              //     switch (db.status) {
              //       case Status.Unauthenticaed:
              //         return Container();
              //         break;
              //       case Status.Authenticating:
              //         return Container();
              //         break;
              //       case Status.Authenticated:
              //         return MaterialButton(
              //               child: Text(
              //                 "View Your Artist Profile",
              //                 style: TextStyle(
              //                   fontSize: 16,
              //                   color: Colors.white,
              //                 ),
              //               ),
              //               onPressed: () async {
              //                 await artistProvider
              //                     .getCertainArtist(db.user.email);
              //                 // netSong.netSongs.clear();
              //                 // await netSong.fetchSongsFromInternet();
              //                 Navigator.push(
              //                     context,
              //                     MaterialPageRoute(
              //                         builder: (context) => ArtistProfile()));
              //               },
              //             );
              //         break;
              //     }
              //   },
              // ),

              Consumer<DbProvider>(builder: (context, dbPro, child) {
                switch (dbPro.status) {
                  case Status.Unauthenticaed:
                    return Container();
                    break;
                  case Status.Authenticating:
                    return Container();
                    break;
                  case Status.Authenticated:
                    return MaterialButton(
                        child: Text(
                          "Profile",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF5654B4),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                        });
                    break;
                }
              }),

              Consumer<DbProvider>(builder: (context, db, child) {
                switch (db.status) {
                  case Status.Unauthenticaed:
                    return Container();
                    break;
                  case Status.Authenticating:
                    return Container();
                    break;
                  case Status.Authenticated:
                    return MaterialButton(
                      child: Text(
                        "Update Your Profile",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF5654B4),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileEdit()));
                      },
                    );
                    break;
                }
              }),
              Consumer<NetSongProvider>(builder: (context, netSong, child) {
                switch (db.status) {
                  case Status.Unauthenticaed:
                    return Container();
                    break;
                  case Status.Authenticating:
                    return Container();
                    break;
                  case Status.Authenticated:
                    return MaterialButton(
                      child: Text(
                        "Browse Songs",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF5654B4),
                        ),
                      ),
                      onPressed: () async {
                        // await db.();
                        netSong.netSongs.clear();
                        await netSong.fetchSongsFromInternet();
                        await netSong.getPlayerState();
                        Future.delayed(Duration(milliseconds: 100), () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BrowseSongs()));
                        });
                      },
                    );
                    break;
                }
              }),
              Divider(),
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
                        // color: Colors.cyan,
                        onPressed: () async {
                          await artistProvider.syncArtistWithModel();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BrowseArtist()));
                        },
                        child: Text("Browse Artists",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF5654B4),
                            )),
                      );
                      break;
                  }
                },
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
                        // color: Colors.cyan,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UploadPage()));
                        },
                        child: Text("Upload Page",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF5654B4),
                            )),
                      );
                      break;
                  }
                },
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
                        // color: Colors.cyan,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Classifier()));
                        },
                        child: Text("Genre Page",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF5654B4),
                            )),
                      );
                      break;
                  }
                },
              ),
              // Divider(
              // ),
              Consumer<DbProvider>(builder: (context, db, child) {
                switch (db.status) {
                  case Status.Unauthenticaed:
                    return Expanded(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: GestureDetector(
                          onTap: () {
                            db.signInWithGoogle();
                            Future.delayed(Duration(seconds: 3), () {
                              artistProvider.getCertainArtist(db.user.email);
                            });
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Log In",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF5654B4),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.login,
                                    color: Color(0xFF5654B4),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    );
                    break;
                  case Status.Authenticating:
                    return Container();
                    break;
                  case Status.Authenticated:
                    return Container();
                    break;
                }
              }),
              Divider(),
              Consumer<DbProvider>(
                // ignore: missing_return
                builder: (context, db, child) {
                  switch (db.status) {
                    case Status.Unauthenticaed:
                      return Container();
                      break;
                    case Status.Authenticating:
                      return Container();
                      break;
                    case Status.Authenticated:
                      return Expanded(
                        child: Align(
                          alignment: FractionalOffset.bottomLeft,
                          child: GestureDetector(
                            onTap: () {
                              db.signOutWithGoogle();
                              artistProvider.removeArtist();
                            },
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Log Out",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF5654B4),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.logout,
                                      color: Color(0xFF5654B4),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      );
                      break;
                  }
                },
              ),
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
                  unselectedLabelColor: Colors.white,
                  labelColor: Colors.yellowAccent,

                  indicatorColor: Colors.yellowAccent,
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
                title: Container(
                  width: 280,
                  height: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white.withOpacity(0.9)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(1.0, 8, 8, 8),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        musicProvider.searchMusic(val);
                      },
                      decoration: InputDecoration(
                        focusedBorder: InputBorder.none,
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Color(0xFF5654B4),
                        ),
                        // fillColor: Color(0xFF5654B4),
                        contentPadding: EdgeInsets.only(bottom: 12),
                        hintText: "Search",
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0xFF5654B4),
                        ),
                        disabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                // backgroundColor: Color(0xFF5454f4),
                pinned: true,
                // flexibleSpace: FlexibleSpaceBar(
                //   collapseMode: CollapseMode.none,
                //   title: Padding(
                //     padding: const EdgeInsets.only(bottom: 28.0),
                //     // child: Text("Suseli"),
                //   ),
                //   // title: Padding(
                //   //   padding: const EdgeInsets.only(bottom: 28.0),
                //   //   child: Row(
                //   //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   //     // crossAxisAlignment: CrossAxisAlignment/s,
                //   //     children: [
                //   //       Container(
                //   //         margin: const EdgeInsets.only(left: 0),
                //   //         height: 20,
                //   //         width: 20,
                //   //         child: GestureDetector(
                //   //           child: SvgPicture.asset(
                //   //             'assets/menu.svg',
                //   //             color: Colors.white,
                //   //           ),
                //   //           onTap: () {
                //   //             print('tapped');
                //   //           },
                //   //         ),
                //   //       ),
                //   //       Expanded(
                //   //         child: TextField(),
                //   //       ),
                //   //       IconButton(
                //   //         icon: Icon(Icons.info),
                //   //         onPressed: () {},
                //   //       )
                //   //     ],
                //   //   ),
                //   // ),
                // ),
              ),
            ];
          },
          body: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: pages,
                ),
              ),
              Consumer<MusicProvider>(
                builder: (context, songPro, child) {
                  switch (songPro.musicState) {
                    case MusicState.Playing:
                      return GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MusicPage(source: 'local'))),
                        child: Container(
                          height: size.height * 0.089,
                          color: Color(0xFF5654B4),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  songPro.songs[songPro.currentIndex].title,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: size.width * 0.3,
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.skip_previous,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      netProvider.stop();
                                      songPro.playPrevious();
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.pause,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      netProvider.stop();
                                      songPro.pause();
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.skip_next,
                                        color: Colors.white),
                                    onPressed: () {
                                      netProvider.stop();
                                      songPro.playNext();
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                      break;
                    case MusicState.Paused:
                      return GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MusicPage(source: 'local'))),
                        child: Container(
                          height: size.height * 0.089,
                          color: Color(0xFF5654B4),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  songPro.songs[songPro.currentIndex].title,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: size.width * 0.3,
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.skip_previous,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      netProvider.stop();
                                      songPro.playPrevious();
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      netProvider.stop();
                                      songPro.resume();
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.skip_next,
                                        color: Colors.white),
                                    onPressed: () {
                                      netProvider.stop();
                                      songPro.playNext();
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                      break;
                    case MusicState.Idle:
                      return Container();
                      break;
                  }
                },
              )
            ],
          ),
        ),
      ),
      // extendBody: true,
      // bottomSheet: Icon(Icons.linked_camera),
    );
  }
}

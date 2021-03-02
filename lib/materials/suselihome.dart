import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suseli/pages/albumspage.dart';
import 'package:suseli/pages/artistspage.dart';
import 'package:suseli/pages/browsesongs.dart';
import 'package:suseli/pages/classifypage.dart';
import 'package:suseli/pages/genrespage.dart';
import 'package:suseli/pages/profile.dart';
import 'package:suseli/pages/songspage.dart';
import 'package:suseli/pages/uploadpage.dart';
import 'package:suseli/provider/dbprovider.dart';
import 'package:suseli/provider/netsongprovider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TextEditingController _searchController = TextEditingController();
  List<Widget> pages = [SongPage(), ArtistPage(), AlbumPage(), GenrePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   iconTheme: IconThemeData(color: Colors.white),
      // ),
      
      drawer: Drawer(
        
        elevation: 10,
        child: Container(
          color: Color(0xFF03C6C7),
          child: Column(children: [
            DrawerHeader(
                // ignore: missing_return
                child: Consumer<DbProvider>(builder: (context, db, child) {
              switch (db.status) {
                case Status.Unauthenticaed:
                  return CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Color(0xFF03C6C7), size: 58,)
                    );
                  break;
                case Status.Authenticating:
                  return Text("Logging In");
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
                               errorWidget: (context, url, error) => Icon(Icons.error),
                            ),)
                      ),
                      SizedBox(height: 5),
                      Text(db.user.displayName, style: TextStyle(
                        color: Colors.white,
                        fontSize: 18
                      ),),
                      
                    ],
                  );
                  break;
              }
            })),
            Consumer<DbProvider>(builder: (context, db, child){
              switch(db.status){
                
                case Status.Unauthenticaed:
                  return Container();
                  break;
                case Status.Authenticating:
                  return Container();
                  break;
                case Status.Authenticated:
                  return Consumer<NetSongProvider>(builder: (context, netSong, child) => MaterialButton(
              child: Text("Profile",style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    
                ),
                
                ),
                onPressed: () async{
                    netSong.netSongs.clear();
                    await netSong.fetchSongsFromInternet();
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ProfilePage()
                    ));
                },
            ),
                  );
                  break;
              }
            }),
            
            Consumer<NetSongProvider>(
              builder: (context, netSong, child) => MaterialButton(
                child: Text("Browse Songs",style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  
                ),),
                onPressed: () async {
                  // await db.();
                  netSong.netSongs.clear();
                  await netSong.fetchSongsFromInternet();

                  Future.delayed(Duration(seconds: 2), (){
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BrowseSongs()));
                  });
                },
              ),
            ),
            Divider(
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
                      child: Text("Upload Page",style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  
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
                      child: Text("Genre Page",style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  
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
                  return GestureDetector(
                      onTap: (){
                        db.signInWithGoogle();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            Text("Log In",style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  
                )),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.login),
                            ),
                          ]                   
                      ),
                    );
                  break;
                case Status.Authenticating:
                  return Text("Logging in");
                  break;
                case Status.Authenticated:
                  return Container();
                  break;
              }
            }),
            Divider(
            ),
            Consumer<DbProvider>(
              // ignore: missing_return
              builder: (context, db, child) {
                switch (db.status) {
                  case Status.Unauthenticaed:
                    return Container();
                    break;
                  case Status.Authenticating:
                    return Text("Logging in");
                    break;
                  case Status.Authenticated:
                    return GestureDetector(
                      onTap: (){
                        db.signOutWithGoogle();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            Text("Log Out",style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  
                )),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.logout, color: Colors.white,),
                            ),
                          ] 
                         
                        
                      ),
                    );
                    break;
                }
              },
            ),


          ]),
        ),
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
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white.withOpacity(0.9)),
                  child: Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(1.0, 8, 8, 8),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search, color: Color(0xFF03C6C7),),
                          disabledBorder: InputBorder.none, 
                        ),
                      ),
                    )
                  ),
                ),
                
                // backgroundColor: Color(0xFF5454f4),
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.none,
                  title: Padding(
                    padding: const EdgeInsets.only(bottom:28.0),
                    // child: Text("Suseli"),
                  ),
                  // title: Padding(
                  //   padding: const EdgeInsets.only(bottom: 28.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     // crossAxisAlignment: CrossAxisAlignment/s,
                  //     children: [
                  //       Container(
                  //         margin: const EdgeInsets.only(left: 0),
                  //         height: 20,
                  //         width: 20,
                  //         child: GestureDetector(
                  //           child: SvgPicture.asset(
                  //             'assets/menu.svg',
                  //             color: Colors.white,
                  //           ),
                  //           onTap: () {
                  //             print('tapped');
                  //           },
                  //         ),
                  //       ),
                  //       Expanded(
                  //         child: TextField(),
                  //       ),
                  //       IconButton(
                  //         icon: Icon(Icons.info),
                  //         onPressed: () {},
                  //       )
                  //     ],
                  //   ),
                  // ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: pages,
          ),
        
        ),
      ),
      // extendBody: true,
      // bottomSheet: Icon(Icons.linked_camera),
    );
  }
}

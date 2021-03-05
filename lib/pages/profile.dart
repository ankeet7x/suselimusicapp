import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:suseli/pages/artistprofile.dart';
import 'package:suseli/pages/profileedit.dart';
import 'package:suseli/provider/artistprovider.dart';
import 'package:suseli/provider/dbprovider.dart';
import 'package:suseli/provider/netsongprovider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // @override
  // void initState(){
  //   super.initState();
  //   SharedPreferences prefs = await SharedPreferences
  // }

  @override
  Widget build(BuildContext context) {
    final artistPro = Provider.of<GetArtists>(context);
    final db = Provider.of<DbProvider>(context);
    final netsongPro = Provider.of<NetSongProvider>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: Text("Your Profile"),
        ),
        // extendBody: true,
        // bottomSheet: Container(color: Colors.blue,
        // height: 20,),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Consumer<DbProvider>(
                builder: (context, db, child) {
                  return Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Container(
                          height: size.height * 0.13,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(55),
                            child: CachedNetworkImage(
                              imageUrl: db.user.photoURL,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Text(
                          db.user.displayName.toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 18),
                        ),
                        SizedBox(
                          height: 0.01,
                        ),
                        GestureDetector(
                          onTap: () {
                            db.coverImgFile = null;
                            db.profileImgFile = null;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileEdit()));
                          },
                          child: Container(
                            height: size.height * 0.05,
                            width: size.width * 0.3,
                            decoration: BoxDecoration(
                                color: Color(0xFF480CA8),
                                borderRadius: BorderRadius.circular(7)),
                            child: Center(
                              child: Text(
                                "Edit Profile",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height*0.015,),
                        Consumer<DbProvider>(
                          builder: (context, dbPro, child) {
                            return Container(
                              child: (dbPro.isArtist == true)
                                  ? GestureDetector(
                                      onTap: () {
                                        artistPro
                                            .getCertainArtist(dbPro.user.email);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ArtistProfile()));
                                      },
                                      child: Container(
                                        height: size.height * 0.05,
                                        width: size.width * 0.35,
                                        decoration: BoxDecoration(
                                            color: Color(0xFF480CA8),
                                            borderRadius:
                                                BorderRadius.circular(7)),
                                        child: Center(
                                          child: Text(
                                            "Your Artist Profile",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                            );
                          },
                        ),
                        Divider(),
                        Center(child: Text("Your Songs"))
                      ],
                    ),
                  );
                },
              ),
              Container(
                height: size.height * 0.7,
                child:
                    Consumer<NetSongProvider>(builder: (context, net, child) {
                  return ListView.builder(
                    itemCount: net.netSongs.length,
                    itemBuilder: (context, index) {
                      if (net.netSongs[index].uploadedBy == db.user.email) {
                        return ListTile(
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              db.deleteASong(net.netSongs[index].songUrl);
                              // setState(() {
                              netsongPro.netSongs.clear();
                              netsongPro.getSong();
                              // });
                              return Fluttertoast.showToast(msg: "Deleting");
                            },
                          ),
                          title: Text(net.netSongs[index].title),
                          subtitle: Text(net.netSongs[index].artist),
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                }),
              ),
            ],
          ),
        ));
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
                        SizedBox(height: size.height*0.03,),
                        Container(
                          height: size.height*0.13,
                          child: ClipRRect(
                            
                            borderRadius: BorderRadius.circular(55),
                            child:
                                CachedNetworkImage(imageUrl: db.user.photoURL, fit: BoxFit.cover,),
                          ),
                        ),
                        SizedBox(height: size.height*0.03,),
                        Text(db.user.displayName.toUpperCase(), style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18
                        ),),
                        SizedBox(
                          height: 0.01,
                        ),
                        RaisedButton(
                          child: Text("Edit Your Profile"),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileEdit()));
                          },
                        ),
                        Consumer<DbProvider>(builder: (context, dbPro, child){
                          return Container(
                            child: dbPro.isArtist ? MaterialButton(child: Text("Your Artist Profile"), onPressed:(){
                              artistPro.getCertainArtist(dbPro.user.email);
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>ArtistProfile()));
                            }):Container(),
                          );
                        },),
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

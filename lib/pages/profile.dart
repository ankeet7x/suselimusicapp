import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suseli/provider/dbprovider.dart';
import 'package:suseli/provider/netsongprovider.dart';


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<DbProvider>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: new AppBar(
        title: Text("Your Profile"),

      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<DbProvider>(builder: (context, db, child){
              return Container(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(55),
                          child: CachedNetworkImage(
                          imageUrl: db.user.photoURL
                        ),
                      ),
                      
                    ),
                    Text(db.user.displayName),
                    RaisedButton(
                      child: Text("Edit Your Profile"),
                      onPressed: (){},
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
              child: Consumer<NetSongProvider>(builder: (context, net, child){
                  return ListView.builder(itemCount: net.netSongs.length, itemBuilder: (context, index){
                    if (net.netSongs[index].uploadedBy == db.user.email){
                      return ListTile(
                        title: Text(net.netSongs[index].title),
                        subtitle: Text(net.netSongs[index].artist),
                      );
                    }else{
                      return Container();
                    }
                      
                    },
                  );
                }
                ),
            ),
          ],
        ),
      )
    );
  }
}
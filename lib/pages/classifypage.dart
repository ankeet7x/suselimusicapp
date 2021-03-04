import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suseli/provider/apiprovider.dart';
import 'package:suseli/provider/dbprovider.dart';


class Classifier extends StatefulWidget {
  @override
  _ClassifierState createState() => _ClassifierState();
}

class _ClassifierState extends State<Classifier> {
  @override
  Widget build(BuildContext context) {
    final filePro = Provider.of<DbProvider>(context);
    final genrePro = Provider.of<ApiHelper>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Genre page", style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        children: [
          SizedBox(
            height: size.height*0.1,
          ),
          Center(child: Text("Check Genre")),
          RaisedButton(
            child: Text("Select a song"),
            onPressed: (){
              filePro.selectSong();
            }
          ),
          RaisedButton(
            child: Text("Upload to server"),
            onPressed: (){
              
              genrePro.postSong(filePro.mp3.path);
            }
          ),
          Consumer<ApiHelper>(builder: (context, gen, child) {
            return Container(
              child: gen.genre == null ? Text('No') : Text(gen.genre),
            );
          },)
        ],
      )
      
    );
  }
}
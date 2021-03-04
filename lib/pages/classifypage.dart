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
      body: Container(
        color: Color(0xFFFFFFFF),
        child: Column(
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
            Consumer<DbProvider>(builder: (context, gen, child) {
              return Container(
                child: gen.mp3 == null ? Text('Select a song First') : Text(gen.mp3.toString()),
              );
            },),
            Consumer<ApiHelper>(builder: (context, api, child){
              switch(api.fetchFromApi){
                
                case FetchFromApi.Idle:
                  return Container();
                  break;
                case FetchFromApi.Fetching:
                  return Column(
                    children: [
                      Image.asset('assets/chicken.gif'),
                      Text("Classifying...")
                    ],
                  );
                  break;
                case FetchFromApi.Popp:
                  Navigator.pop(context);
                  return Container();
                  break;
                case FetchFromApi.Fetched:
                  return Padding(
                    padding: const EdgeInsets.only(top:18.0),
                    child: Text("The Genre is: " + api.genre, style: TextStyle(
                      fontSize: 30
                    ),),
                  );
                  break;
              }
            })
          ],
        ),
      )
      
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:suseli/provider/dbprovider.dart';
import 'package:suseli/provider/netsongprovider.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _artistController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _artistController.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<DbProvider>(context);
    final netP = Provider.of<NetSongProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Page"),
      ),
      body: Stack(
        children: [
          Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _titleController,
                    validator: (val) =>
                        val.length < 3 ? "Please enter a valid title" : null,
                    decoration: InputDecoration(
                      disabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none,
                        prefixIcon: Icon(Icons.title), hintText: "Title"),
                  ),
                ),
                TextFormField(
                  controller: _artistController,
                  validator: (val) =>
                      val.length < 5 ? "Please enter artist's name" : null,
                  decoration: InputDecoration(
                    disabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.person), hintText: "Artist"),
                ),
              ],
            ),
          ),
          RaisedButton(
              child: Text("Select your song"),
              onPressed: () {
                db.selectSong();
                // pro.selectSong();
              },
            ),
          Consumer<DbProvider>(builder: (context, db, child){
            if(db.mp3 == null){
              return Container();
            }else{
              return Text(db.mp3.toString());
            }
          },),
           RaisedButton(
                child: Text("Pick album art"),
                onPressed: (){
                  db.getAlbumArt();
                },
              ),
              Consumer<DbProvider>(builder: (context, db, child){
            if(db.albumArt == null){
              return Container();
            }else{
              return Text(db.albumArt.toString());
            }}),
          Consumer<DbProvider>(builder: (context, db, child){
            switch(db.upStatus){
              case UploadingStatus.Uploading:
                return Text("");
                break;
              case UploadingStatus.Uploaded:
                return Text("Uploaded");
                break;
              case UploadingStatus.Pop:
                Navigator.pop(context);
                break;
              case UploadingStatus.Free:
                return InkWell(
                splashColor: Colors.cyan,
                onTap: () async {
                  try {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      print("Uploading");
                      await db.uploadSong(
                          db.mp3, _titleController.text, _artistController.text, db.albumArt);
                      // Navigator.pop(context);
                      
                      Future.delayed(Duration(seconds: 5), (){
                        netP.fetchSongsFromInternet();
                      });
                    }
                  } catch (e) {
                    print(e.toString());
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.upload_file), Text("Upload")],
              
              ));
               
            }
          },
                       
          ),
          // Consumer<DbProvider>(builder: (context, db, child){
          //   switch(db.upStatus){
              
          //     case UploadingStatus.Uploading:
          //       return Row(children: [
          //         Text("Uploading to db"),
          //         CircularProgressIndicator()
          //       ],);
          //       break;
          //     case UploadingStatus.Uploaded:
          //       return Text("Uploaded");
          //       break; 
          //     case UploadingStatus.Pop:
          //       Navigator.pop(context);
          //       break;
          //     case UploadingStatus.Free:
          //       // Navigator.pop(context);
          //       return Container();
          //       break;
          //     // default:
          //     //   return Container();
          //     //   break;
          //   }
          // },)
          
        ],
      ),
      Consumer<DbProvider>(builder: (context, db, child) {
        switch(db.upStatus){
          
          case UploadingStatus.Uploading:
            return SpinKitPouringHourglass(color: Color(0xFF03C6C7));
            break;
          case UploadingStatus.Uploaded:
            return Text("Your song has been uploaded");
            break;
          case UploadingStatus.Pop:
            return Container();
            break;
          case UploadingStatus.Free:
            return Container();
            break;
        }
      })

        ],
      )
    );
  }
}
 
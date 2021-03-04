import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:suseli/models/artist.dart';


enum GotArtistProfileStatus {Not_Yet, Got}

class GetArtists extends ChangeNotifier {
  bool isAnArtist;
  List<ArtistModel> artists = [];
  ArtistModel _artistModel;
  ArtistModel get artistModel => _artistModel;
  GotArtistProfileStatus gotArtistProfileStatus = GotArtistProfileStatus.Not_Yet;

  GetArtists(){
    this.syncArtistWithModel();
  }


  syncArtistWithModel() async {
    try{
      artists.clear();
      _artistModel = await getArtistFromDb();
    }catch(e){
      print("The error is: "+ e.toString());
    }
  }

  getArtistFromDb() async {
    await FirebaseFirestore.instance.collection("Artists").get().then((value) {
      for (DocumentSnapshot artist in value.docs) {
        artists.add(ArtistModel.fromSnapshot(artist));
        notifyListeners();
        
      }
      
    });
  }

  String currentArtistEm;
  String currentArtistbio;
  String currentArtistCover;
  String currentArtistProfile;
  String currentArtistuserName;
  String currentArtistName;

  getCertainArtist(email) async{
    print("exec");
    await FirebaseFirestore.instance.collection('Artists').get().then((value){
      for (DocumentSnapshot searchedArtist in value.docs){
        if (searchedArtist.get('email') == email){
          gotArtistProfileStatus = GotArtistProfileStatus.Got;
          notifyListeners();
          currentArtistEm = email;
          currentArtistbio = searchedArtist.get('bio');
          currentArtistCover = searchedArtist.get('coverImg');
          currentArtistProfile = searchedArtist.get('profileImg');
          currentArtistuserName = searchedArtist.get('username');
          currentArtistName = searchedArtist.get('name');
          print(currentArtistEm);
          notifyListeners();
        }
        
      }
    });
    // return true;
    
  }

  removeArtist() async{
    gotArtistProfileStatus = GotArtistProfileStatus.Not_Yet;
    // currentArtistName  
  }
  
  // getSongsByArtist()


}

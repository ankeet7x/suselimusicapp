import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suseli/materials/suseliprovider.dart';

class BrowseSongs extends StatefulWidget {
  @override
  _BrowseSongsState createState() => _BrowseSongsState();
}

class _BrowseSongsState extends State<BrowseSongs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Songs"),
      ),
      body: Consumer<MusicProvider>(
        builder: (context, mp, child) => StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Songs").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot docSnap = snapshot.data.docs[index];
                  return ListTile(
                    title: Text(docSnap['songUrl']),
                    subtitle: Text(docSnap['uploadedBy']),
                    onTap: () {
                      mp.playFromUrl(docSnap['songUrl']);
                    },
                  );
                },
              );
            } else {
              return Center(
                child: Text("Empty"),
              );
            }
          },
        ),
      ),
    );
  }
}

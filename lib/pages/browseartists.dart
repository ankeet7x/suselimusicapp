import 'package:flutter/material.dart';

class BrowseArtist extends StatefulWidget {
  @override
  _BrowseArtistState createState() => _BrowseArtistState();
}

class _BrowseArtistState extends State<BrowseArtist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Browse Artists"),
      ),
      
    );
  }
}
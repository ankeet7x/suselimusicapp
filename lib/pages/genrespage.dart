import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suseli/provider/suseliprovider.dart';

class GenrePage extends StatefulWidget {
  @override
  _GenrePageState createState() => _GenrePageState();
}

class _GenrePageState extends State<GenrePage> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicProvider>(
      builder: (context, songP, child) => Scrollbar(
        controller: scrollController,
            isAlwaysShown: true,
              child: ListView.builder(
          itemCount: songP.genres.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(songP.genres[index].name),
          
            onTap: () => print(songP.genres.length),
          ),
        ),
      ),
    );
  }
}

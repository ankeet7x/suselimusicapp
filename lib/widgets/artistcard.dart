import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ArtistCard extends StatelessWidget {
  final String name;
  final String profileImg;
  ArtistCard({this.name, this.profileImg});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // color: Colors.blue,
        decoration:
            BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15), boxShadow: [
          BoxShadow(
              color: Colors.grey,
              offset: Offset(2, 2),
              blurRadius: 3,
              spreadRadius: 5)
        ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                flex: 1,
                child: CachedNetworkImage(
                  imageUrl: profileImg,
                  fit: BoxFit.cover,
                  // placeholder: (context, url) => Shimmer.fromColors(child: Text(""), baseColor: Colors.grey, highlightColor: Colors.purple),
                ),
                // child: ClipRRect(
                //     child: Image.network(
                //   profileImg,
                //   fit: BoxFit.cover,
                // ))
                ),
            Center(child: Text(name))
          ],
        ),
      ),
    );
  }
}

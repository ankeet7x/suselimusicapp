import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ArtistCard extends StatelessWidget {
  final String name;
  final String profileImg;
  ArtistCard({this.name, this.profileImg});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Container(
        // height: size.height*0.8,
        // color: Colors.blue,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                  color: Color(0xFFF0F0F0),
                  offset: Offset(2, 2),
                  blurRadius: 5,
                  spreadRadius: 5)
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: ClipRRect(
                
                borderRadius: BorderRadius.circular(2),
                child: CachedNetworkImage(
                  imageUrl: profileImg,
                  
                  fit: BoxFit.cover,
                  // placeholder: (context, url) => Shimmer.fromColors(child: Text(""), baseColor: Colors.grey, highlightColor: Colors.purple),
                ),
              ),
              // child: ClipRRect(
              //     child: Image.network(
              //   profileImg,
              //   fit: BoxFit.cover,
              // ))
            ),
            Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '@' + name,
                style: TextStyle(color: Color(0xFF480CA8)),
              ),
            ))
          ],
        ),
      ),
    );
  }
}

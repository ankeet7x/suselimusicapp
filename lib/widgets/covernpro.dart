import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageStack extends StatelessWidget {
  final String profileImg, coverImg;
  ImageStack({this.coverImg, this.profileImg});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.29,
      // width: size.width,
      color: Colors.transparent,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white,
                  width: 2
                )
              )
            ),
            height: size.height*0.2,
            width: size.width,
            child: CachedNetworkImage(
              imageUrl: coverImg,
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
              top: size.height * 0.1,
              right: (size.width - 150)/2,
              child: Container(
                  height: 150,
                  width:150,
                  // width: size.width * 0.4,
                  decoration:
                      BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 2
                        ),
                        borderRadius: BorderRadius.circular(200)),
                  child: ClipRRect(
                      
                      borderRadius: BorderRadius.circular(200),
                      child: CachedNetworkImage(
                        imageUrl: profileImg,
                        fit: BoxFit.cover,
                      ))))
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:suseli/provider/suseliprovider.dart';

AppBar buildAppBar(MusicProvider songP) {
  return new AppBar(
    title: Text("Suseli"),
    centerTitle: true,
    backgroundColor: songP.bgColor,
    leading: Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: IconButton(
        icon: Icon(
          Icons.menu,
          color: songP.white,
        ),
        onPressed: () {},
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: IconButton(
            icon: Icon(
              Icons.person,
              color: songP.white,
            ),
            onPressed: () {}),
      )
    ],
    elevation: 0,
  );
}

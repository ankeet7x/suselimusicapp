import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'materials/suselihome.dart';
import 'materials/suseliprovider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MusicProvider(),
      child: MaterialApp(
        home: Home(),
        title: "MP",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Color(0xFF5654B4),
            accentColor: Colors.cyan),
      ),
    );
  }
}

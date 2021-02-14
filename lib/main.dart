import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suseli/materials/dbprovider.dart';
import 'materials/suselihome.dart';
import 'materials/suseliprovider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: MusicProvider.initialize()),
      ChangeNotifierProvider.value(value: DbProvider())
    ],
    child: MaterialApp(
      home: Home(),
      title: "MP",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Color(0xFF5654B4),
          accentColor: Colors.cyan),
    ),
  ));
}

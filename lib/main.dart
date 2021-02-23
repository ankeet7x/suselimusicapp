import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suseli/provider/dbprovider.dart';
import 'package:suseli/provider/netsongprovider.dart';
import 'materials/suselihome.dart';
import 'provider/suseliprovider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: MusicProvider.initialize()),
      ChangeNotifierProvider.value(value: DbProvider()),
      ChangeNotifierProvider.value(value: NetSongProvider.initialize())
    ],
    child: MaterialApp(
      home: Home(),
      title: "Suseli",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Color(0xFF5654B4),
          accentColor: Colors.cyan),
    ),
  ));
}

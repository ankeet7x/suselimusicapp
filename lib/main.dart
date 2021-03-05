import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:suseli/provider/apiprovider.dart';
import 'package:suseli/provider/artistprovider.dart';
import 'package:suseli/provider/dbprovider.dart';
import 'package:suseli/provider/netsongprovider.dart';
import 'materials/suselihome.dart';
import 'provider/suseliprovider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // var artistAccCreation = prefs.getString('artistAccCreation');
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: MusicProvider.initialize()),
      ChangeNotifierProvider.value(value: DbProvider()),
      ChangeNotifierProvider.value(value: GetArtists()),
      ChangeNotifierProvider.value(value: ApiHelper()),
      ChangeNotifierProvider.value(value: NetSongProvider.initialize())
    ],
    child: MaterialApp(
      home: SplashScreen(
        backgroundColor: Color(0xFF480CA8),
        seconds: 2,
        photoSize: 70,
        image: Image.asset('assets/logo.png'),
        navigateAfterSeconds: Home()),
      title: "Suseli",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Color(0xFF480CA8),
          accentColor: Colors.cyan),
    ),
  ));
}

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:suseli/provider/apiprovider.dart';
import 'package:suseli/provider/dbprovider.dart';

class Classifier extends StatefulWidget {
  @override
  _ClassifierState createState() => _ClassifierState();
}

class _ClassifierState extends State<Classifier> {
  @override
  Widget build(BuildContext context) {
    final filePro = Provider.of<DbProvider>(context);
    final genrePro = Provider.of<ApiHelper>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Prediction",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
          color: Color(0xFFFFFFFF),
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.06,
              ),
              // Center(
              //     child: Text(
              //   "Predict Genre",
              //   style: TextStyle(
              //       fontSize: 20,
              //       fontWeight: FontWeight.bold,
              //       color: Color(0xFF480CA8)),
              // )),
              Consumer<ApiHelper>(builder: (context, apiPro, child) {
                switch (apiPro.fetchFromApi) {
                  case FetchFromApi.Idle:
                    return Container(
                      child: genrePro.mp3 == null
                          ? Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: GestureDetector(
                                onTap: () {
                                  genrePro.selectSong();
                                },
                                child: Container(
                                  height: size.height * 0.22,
                                  width: size.width * 0.78,
                                  decoration: BoxDecoration(
                                      color: Color(0xFF480CA8),
                                      borderRadius: BorderRadius.circular(7)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.music_note,
                                          color: Colors.white, size: 40),
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      Text(
                                        "Select a song",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                height: size.height * 0.22,
                                width: size.width * 0.78,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(7),
                                    border: Border.all(
                                      color: Color(0xFF480CA8),
                                    )),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.check_circle,
                                          color: Color(0xFF480CA8), size: 40),
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      Text(
                                        "Song Selected",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF480CA8)),
                                      ),
                                    ]),
                              ),
                            ),
                    );
                    break;
                  case FetchFromApi.Fetching:
                    return Container();
                    break;
                  case FetchFromApi.Fetched:
                    return Container();
                    break;
                }
              }),
              Consumer<ApiHelper>(builder: (context, genrePro, child) {
                switch (genrePro.fetchFromApi) {
                  case FetchFromApi.Idle:
                    return Padding(
                      padding: const EdgeInsets.all(22.0),
                      child: Container(
                        child: genrePro.mp3 == null
                            ? Container(
                                height: size.height * 0.05,
                                width: size.width * 0.35,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFF480CA8)),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Center(
                                  child: Text(
                                    "Predict genre",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF480CA8)),
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  if (filePro.mp3 != null) {
                                    genrePro.postSong(genrePro.mp3.path);
                                    Future.delayed(Duration(seconds: 10), () {
                                      filePro.removeVal();
                                    });
                                  } else {
                                    return Fluttertoast.showToast(
                                        msg: "Insert an song first");
                                  }
                                },
                                child: Container(
                                  height: size.height * 0.05,
                                  width: size.width * 0.35,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF480CA8),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Predict Genre",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                )),
                      ),
                    );
                    break;
                  case FetchFromApi.Fetching:
                    return Container();
                    break;
                  case FetchFromApi.Fetched:
                    return Container();
                    break;
                }
              }),
              // Consumer<DbProvider>(
              //   builder: (context, gen, child) {
              //     return Container(
              //       child: gen.mp3 == null
              //           ? Container()
              //           : Text(gen.mp3.toString()),
              //     );
              //   },
              // ),
              Consumer<ApiHelper>(builder: (context, api, child) {
                switch (api.fetchFromApi) {
                  case FetchFromApi.Idle:
                    return Container();
                    break;
                  case FetchFromApi.Fetching:
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                          child: Image.asset('assets/chicken.gif'),
                        ),
                        SizedBox(
                          height: size.height*0.1,
                        ),
                        Text("Predicting...", style: TextStyle(
                          color: Color(0xFF480CA8),
                          fontWeight: FontWeight.bold,
                          fontSize: 22
                        ))
                      ],
                    );
                    break;
                  case FetchFromApi.Fetched:
                    return Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: Column(children: [
                        Text(
                        "The Genre is",
                        style: TextStyle(fontSize: 30),
                      ),
                      SizedBox(height: size.height*0.03),
                      Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: Image.asset('assets/arrow.gif'),
                      ),
                      SizedBox(height: size.height*0.03),
                      Text(api.genre, style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40
                      ),),
                      

                      ],)
                    );
                    break;
                }
              })
            ],
          ),
        ));
  }
}

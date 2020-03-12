import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:streaming_app/HomePage.dart';
import 'package:streaming_app/cameraView.dart';
import 'package:streaming_app/ScreenRecorder.dart';

class NewVideo extends StatefulWidget {
  String x;
  FirebaseUser user;
  NewVideo(this.x, this.user);
  @override
  _NewVideoState createState() => _NewVideoState(x, user);
}

class _NewVideoState extends State<NewVideo> {
  String fileName;
  FirebaseUser user;
  _NewVideoState(this.fileName, this.user);
  // static const platform = const MethodChannel('samples.flutter.dev/battery');
  bool pip = false;
  bool rec = false;
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(user.email),
    //     actions: <Widget>[
    //       IconButton(icon: Icon(Icons.exit_to_app), onPressed:null),
    //     ],
    //   ),
    // body:
    return Material(
      child: ListView(
        children: <Widget>[
          CameraApp(pip),
          Row(children: <Widget>[
            !rec
            ? Expanded(
              child: IconButton(
                icon: Icon(Icons.play_circle_outline),
                iconSize: 50,
                onPressed: () async {
                  Fluttertoast.showToast(msg: "Recording Started");
                  ScreenRecorder.changeFileName(fileName);
                  ScreenRecorder.startRecordScreen();
                  setState(() {
                    pip = true;
                    rec = true;
                  });
                },
                tooltip: "Start Recording",
              ),
            )
            :Container(),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.cancel),
                iconSize: 50,
                onPressed: (){
                  _displayDialog(context);
                },
                tooltip: "Cancel",
              ),
            ),
            rec
                ? Expanded(
                    child: IconButton(
                        icon: Icon(Icons.stop),
                        iconSize: 50,
                        onPressed: () async {
                          ScreenRecorder.stopRecordScreen;
                          // Provider.of<Function>(context);
                          Fluttertoast.showToast(
                              msg: "$fileName.mp4 successfully saved");
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(user)));
                        },
                        tooltip: "Stop Recording"),
                  )
                : Container()
          ]),
          RaisedButton(
            child: Text("Enter Small Screen mode"),
            onPressed: () async {
              ScreenRecorder.PIPmode;
            },
          )

          //  RaisedButton(
          //   child: Text("Pause/Resume"),
          //   onPressed: () async{
          //   //  final result=await FlutterScreenRecording.stopRecordScreen;
          //                 // print(result);
          //                 ScreenRecorder.
          // }),
        ],
      ),
    );
    // );
  }
  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Are you sure want to cancel the recording'),
            actions: <Widget>[
              new FlatButton(
                child: new Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('YES'),
                onPressed: () {
                  if(rec)
                  { ScreenRecorder.stopRecordScreen;
                    var dir = Directory(
                      '/storage/emulated/0/Movies/StreamingApp/' +
                          "$fileName.mp4");
                  dir.deleteSync(recursive: true);}
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomePage(user)));
                },
              )
            ],
          );
        });
  }
}

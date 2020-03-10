import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:streaming_app/cameraView.dart';
// import 'package:flutter_android_pip/flutter_android_pip.dart';
// import 'package:screen_recorder/screen_recorder.dart';
// import 'package:flutter_screen_recording/flutter_screen_recording.dart';
// import 'package:flutter_screen_recorder/flutter_screen_recorder.dart';
import 'dart:async';

// import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class HomePage extends StatefulWidget{
  FirebaseUser user;
  HomePage(this.user);
  @override
  _HomePageState createState() => _HomePageState(user);
}

class _HomePageState extends State<HomePage> {
   static const platform = const MethodChannel('samples.flutter.dev/battery');
  bool pip=false;
  FirebaseUser user;
  FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  _HomePageState(this.user);
  requestPermissions() async {
    await PermissionHandler().requestPermissions([
      PermissionGroup.storage,
      PermissionGroup.photos,
    ]);
  }
  @override
  void initState()
  {
    super.initState();
    requestPermissions();
  }
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
       return ListView(
        children: <Widget>[
          CameraApp(pip),
          RaisedButton(
            child: Text("Start Recording"),
            onPressed: () async{
              // bool result=await FlutterScreenRecording.startRecordScreen("ABC.mp4");
              // print(result);
              // _getBatteryLevel('Battery');
              _callToNative('Start');
              setState(() {
                pip=true;
              });
          }),
          RaisedButton(
            child: Text("Stop Recording"),
            onPressed: () async{
                          // print(result);
                          _callToNative('Stop');
          }),
          RaisedButton(
            child: Text("Enter PIP"),
            onPressed: () async{
            //  final result=await FlutterScreenRecording.stopRecordScreen;
                          // print(result);
                          _callToNative('PIP');
          }),
        ],
      );
    // );
  }
  Future<void> _callToNative(String x) async {
    try {
     await platform.invokeMethod(x);
    } on PlatformException catch (e) {
      print(e.message);
    } 
  }
}
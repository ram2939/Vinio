import 'dart:async';
import 'dart:io';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_notifications/local_notifications.dart';
// import 'package:provider/provider.dart';
import 'package:streaming_app/MainPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:streaming_app/RecordCamera.dart';
// import 'package:streaming_app/HomePage.dart';
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
  bool isCountDown = false;
  String fileName;
  FirebaseUser user;
  _NewVideoState(this.fileName, this.user);
  bool pip = false;
  bool rec = false;

  static const AndroidNotificationChannel channel =
      const AndroidNotificationChannel(
          id: 'default_notification',
          name: 'Default',
          description: 'Grant this app the ability to show notifications',
          importance: AndroidNotificationChannelImportance.HIGH);
  BuildContext c;
  @override
  void initState() {
    super.initState();
    c = context;
  }
  bool cameraMode=false;
  onNotificationClick(String payload) async {
    ScreenRecorder.stopRecordScreen;
    Fluttertoast.showToast(msg: "$fileName.mp4 successfully saved");
    Navigator.pushReplacement(
        c, MaterialPageRoute(builder: (c) => MainPage(user)));
    LocalNotifications.removeNotification(0);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _displayDialog(context);
      },
      child: Material(
        child: ListView(
          children: <Widget>[
            Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                CameraApp(pip),
                isCountDown ? countDown() : Container()
              ],
            ),
            
            !cameraMode
            ? Row(children: <Widget>[
              !rec
                  ? Expanded(
                      child: IconButton(
                        icon: Icon(Icons.play_circle_outline),
                        iconSize: 50,
                        onPressed: () async {
                          setState(() {
                            _start = 5;
                            isCountDown = true;
                            // pip=true;
                            rec = true;
                          });
                          await Future.delayed(Duration(seconds: 4));
                          setState(() {
                            isCountDown = false;
                          });
                          Fluttertoast.showToast(msg: "Recording Started");
                          ScreenRecorder.changeFileName(fileName);
                          ScreenRecorder.startRecordScreen();
                          await LocalNotifications
                              .createAndroidNotificationChannel(
                                  channel: channel);
                          await LocalNotifications.createNotification(
                              imageUrl: 'app_icon',
                              title: "Vinio",
                              content: "Recording. Tap to Stop Recording ",
                              id: 0,
                              androidSettings:
                                  new AndroidSettings(
                                    isOngoing: true,
                                    channel: channel),
                                    onNotificationClick:
                                    NotificationAction(
                                    actionText: "Stop Recording",
                                    callback: onNotificationClick,
                                    payload: "firstAction",
                                    launchesApp: true),
                              // actions: [
                              //   new NotificationAction(
                              //       actionText: "Stop Recording",
                              //       callback: onNotificationClick,
                              //       payload: "firstAction",
                              //       launchesApp: true),
                              // ]
                              );
                        },
                        tooltip: "Start Recording",
                      ),
                    )
                  : Container(),
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.cancel),
                  iconSize: 50,
                  onPressed: () {
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
                            Fluttertoast.showToast(
                                msg: "$fileName.mp4 successfully saved");
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainPage(user)));
                            LocalNotifications.removeNotification(0);
                          },
                          tooltip: "Stop Recording"),
                    )
                  : Container()
            ])
            : Container(),
            !cameraMode
            ? FlatButton(
              clipBehavior: Clip.hardEdge,
              textColor: Colors.blueAccent,
              child: Text("Enter Small Screen mode"),
              onPressed: () async {
                ScreenRecorder.PIPmode;
              },
            )
            :Container(
              color: Colors.black,
              height: 200),

            FlatButton(
              clipBehavior: Clip.hardEdge,
              textColor: Colors.blueAccent,
              child: cameraMode
              ? Text("Show Buttons")
              : Text("Hide Buttons"),
              onPressed: () async {
                setState(() {
                  cameraMode=!cameraMode;
                });
              },
            )
          ],
        ),
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
                  if (rec) {
                    ScreenRecorder.stopRecordScreen;
                    var dir = Directory(
                        '/storage/emulated/0/Movies/Vinio/' +
                            "$fileName.mp4");
                    dir.deleteSync(recursive: true);
                  }
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MainPage(user)));
                },
              )
            ],
          );
        });
  }

  var _start = 5;
  Widget countDown() {
    const oneSec = const Duration(seconds: 1, milliseconds: 50);
    Timer _timer = new Timer.periodic(
        oneSec,
        (Timer timer) => setState(
              () {
                if (_start <= 1) {
                  timer.cancel();
                } else {
                  _start = _start - 1;
                }
              },
            ));
    return Container(
        child: Text(
      "$_start",
      style: TextStyle(
        fontSize: 200,
      ),
    ));
  }
}

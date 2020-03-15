import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:streaming_app/NewVideo.dart';
import 'package:streaming_app/ScreenRecorder.dart';
import 'package:streaming_app/VideoPlayer.dart';
import 'package:streaming_app/LoginPage.dart';

// import 'package:streaming_app/ScreenRecorder.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as p;
class HomePage extends StatefulWidget {
  FirebaseUser user;
  HomePage(this.user);
  @override
  _HomePageState createState() => _HomePageState(user);
}

class _HomePageState extends State<HomePage> {
  TextEditingController fileName = TextEditingController();
  FirebaseUser user;
  bool isHD = false;
  List<FileSystemEntity> x = [];
  var dir = Directory('/storage/emulated/0/Movies/StreamingApp');
  // String _tempDir;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  _HomePageState(this.user);
  _updateList() async {
    setState(() {
      x = dir.listSync();
    });
    //     dir.list(recursive: false).listen((FileSystemEntity entity) {
    //   setState(() {
    //     if(!x.contains(entity.path.split('/').last))
    //     x.add(entity.path.split('/').last);
    //   });
    //   print(entity.path);
    // });
  }

  @override
  void initState() {
    super.initState();
    _updateList();

  }

  // _getPath() async {
  //   x=await ScreenRecorder.getFilePath();
  // }
//  _getImage(videoPathUrl) async {
//                       final thumbnail = await VideoThumbnail.thumbnailFile(
//                       video: videoPathUrl,
//                       thumbnailPath: _tempDir,
//                       imageFormat: ImageFormat.JPEG,
//                       maxHeight: 100,
//                       maxWidth: 100,
//                       quality: 10);
//                       // final y=File(_getImage("/storage/emulated/0/Movies/hi.mp4"));
//                       setState(() {
//                       final file = File(thumbnail);
//                         x.add(Image(image: AssetImage(file.path)));
//     });
//                   }
//   print(thumb);
//   return thumb;
// }
  _share(String x) async {
    await FlutterShare.shareFile(title: "Share video", filePath: x);
  }

  FlutterSecureStorage storage = FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(user.email),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () async {
                  if (storage.read(key: '1') == "email")
                    await firebaseAuth.signOut();
                  else
                    await GoogleSignIn().signOut();
                  storage.delete(key: "1");
                  Fluttertoast.showToast(
                      msg: "You have been successfully logged out");
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => new LoginPage()));
                },
                tooltip: "Logout"),
          ],
        ),
        floatingActionButton: CircleAvatar(
          child: IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: () {
              _displayDialog(context);
            },
            tooltip: "Create a new Recording",
          ),
          backgroundColor: Colors.blueAccent,
          radius: 30,
        ),
        body: x.isEmpty
            ? Center(
                child: Text("No Recordings Found"),
              )
            : ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    subtitle: FutureBuilder(
                        future: x[index].stat().then((FileStat fileStat) {
                          return fileStat.changed.toString();
                        }),
                        builder: (context, snapshot) {
                          return Text(
                              "\n" + snapshot.data.toString().split(" ").first);
                        }),
                    title: Row(
                      children: <Widget>[
                        Flexible(
                          flex: 2,
                          child: Container(
                              color: Colors.white,
                              height: 50,
                              // width: 220,
                              // margin: EdgeInsets.all(10),
                              child: Center(
                                  child: Text(x[index].path.split('/').last))),
                        ),
                        IconButton(
                          icon: Icon(Icons.play_circle_outline),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        VideoPlayerScreen(x[index].path)));
                          },
                          tooltip: "Play the video",
                        ),
                        IconButton(
                            icon: Icon(Icons.share),
                            onPressed: () {
                              _share(x[index].path);
                            },
                            tooltip: "Share the video"),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _displayDeleteDialog(context, x[index]);
                          },
                          tooltip: "Delete the video",
                        ),
                      ],
                    ),
                  );
                },
                itemCount: x.length,
                physics: const AlwaysScrollableScrollPhysics(),
              ));
  }

  _displayDeleteDialog(BuildContext context, FileSystemEntity y) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Are you sure want to delete the recording'),
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
                    Fluttertoast.showToast(
                        msg: "File successfully deleted",
                        toastLength: Toast.LENGTH_SHORT);
                    Navigator.of(context).pop();
                    Directory(y.path).deleteSync(recursive: true);
                    _updateList();
                    setState(() {});
                  })
            ],
          );
        });
  }

  
  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('New Recording'),
            content: TextField(
              controller: fileName,
              decoration:
                  InputDecoration(hintText: "Name of the New Recording"),
            ),
            actions: <Widget>[
              Text("HD"),
              Switch(
                onChanged: (bool value) {
                  if (!value) {
                    setState(() {
                      isHD = false;
                    });
                  } else {
                    setState(() {
                      isHD = true;
                    });
                  }
                },
                value: isHD,
              ),
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  fileName.text = "";
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('NEXT'),
                onPressed: () {
                  if (!fileName.text.isEmpty) {
                    var file = fileName.text;
                    bool original = true;
                    FileSystemEntity y;
                    for (y in x) {
                      if (y.path.split("/").last == (file + ".mp4"))
                        original = false;
                    }
                    if (original) {
                      fileName.text = "";
                      if (isHD) ScreenRecorder.changeHD();
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewVideo(file, user)));
                    } else
                      Fluttertoast.showToast(msg: "File already exists");
                  } else
                    Fluttertoast.showToast(msg: "Name can not be blank");
                },
              )
            ],
          );
        });
  }
}

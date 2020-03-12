import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:streaming_app/NewVideo.dart';
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
  List<FileSystemEntity> x = [];
  // Stream<FileSystemEntity> y;
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
    // y=dir.list(recursive: false);
    // getTemporaryDirectory().then((d) => _tempDir = d.path);
    // String path= await ScreenRecorder.getFilePath();
    // print(path);
    // _getImage(path);
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(user.email),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.exit_to_app), onPressed: ()
            {
              Fluttertoast.showToast(msg: "You have been successfully logged out");
              Navigator.of(context).pop();
              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>new LoginPage()));

            },
            tooltip:"Logout"
            ),
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
                          future: x[index].stat().then((FileStat fileStat){
                          return  fileStat.changed.toString();
                        }),
                        builder: (context, snapshot)
                        {
                          return Text("\n"+snapshot.data.toString().split(" ").first);
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
                            // Navigator.of(context).pop();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        VideoPlayerScreen(x[index].path)));
                          },
                          tooltip: "Play the video",
                        ),
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
  _displayDeleteDialog(BuildContext context,FileSystemEntity y) async {
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
                  Navigator.of(context).pop();
                Directory(y.path)
                                .deleteSync(recursive: true);
                            _updateList();
                            setState(() {});
                }
              )
            ],
          );
        });
  }

  // body: Column(
  //   // child: RaisedButton(
  //   //   onPressed: () async
  //   //   {
  //   //       print(await ScreenRecorder.getFilePath());

  //   //   }),
  //   children:<Widget>[
  //    x!=null
  //   ? Image(image:AssetImage(x))
  //   :Text("No image"),
  //   ]
  // ),
  //             body: FutureBuilder(
  //               future: ScreenRecorder.getFilePath(),
  //               builder: (BuildContext context,AsyncSnapshot<String> snapshot)
  //               {
  //                   if(snapshot.hasData)
  //                   {
  //                     return Image.file(File(_getImage(x))
  //                     );

  //                   }
  //                   else return Container();
  //               }
  //             )
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
                  var file = fileName.text;
                  fileName.text = "";
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewVideo(file, user)));
                },
              )
            ],
          );
        });
  }
}

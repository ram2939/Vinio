import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:streaming_app/NewVideo.dart';
import 'package:streaming_app/ScreenRecorder.dart';
import 'package:streaming_app/VideoPlayer.dart';
// import 'package:streaming_app/LoginPage.dart';
// import 'package:video_player/video_player.dart';

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
  var dir = Directory('/storage/emulated/0/Movies/Vinio');
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

  // FlutterSecureStorage storage = FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text(user.email),
        //   backgroundColor: Colors.pink[300],
        //   actions: <Widget>[
        //     IconButton(
        //         icon: Icon(Icons.exit_to_app),
        //         onPressed: () async {
        //
        //         tooltip: "Logout"),
        //   ],
        // ),
        // backgroundColor: Colors.pink[100],
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right:20.0),
          child: CircleAvatar(
            child: Center(
              child: IconButton(
                icon: Icon(Icons.video_call),
                iconSize: 35,
                color: Colors.white,
                onPressed: () {
                  _displayDialog(context);
                },
                tooltip: "Create a new Recording",
              ),
            ),
            backgroundColor: Color(0xffFA817E),
            radius: 35,
          ),
        ),
        body: x.isEmpty
            ? Center(
                child: Text("No Recordings Found"),
              )
            : ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return ListItem(x[index]);
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
                  setState(() {
                    isHD = !isHD;
                  });
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
                  if (fileName.text.isNotEmpty) {
                    var file = fileName.text;
                    bool original = true;
                    FileSystemEntity y;
                    for (y in x) {
                      if (y.path.split("/").last == (file + ".mp4"))
                        original = false;
                    }
                    if (original) {
                      fileName.text = "";
                      ScreenRecorder.changeHD(isHD);
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

  // getVideoDuration(File file)
  // {
  //   VideoPlayerController videoPlayerController=VideoPlayerController.file(file)..initialize().then((){
  //       return
  //   });
  // }
  final FlutterFFmpeg fFmpeg = FlutterFFmpeg();
  Widget ListItem(FileSystemEntity file) {
    File fileProperties = File(file.path);
    return Column(
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.all(0),
          dense: true,
          // subtitle:
          title: Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.only(left: 20, right: 5),
            decoration: BoxDecoration(
              border: Border(
              
                // color: Colors.black
                // top: BorderSide(color:Colors.black)
                // width: 
              ),
              borderRadius: BorderRadius.circular(0),
              // color: Color(0xffFA817E),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 30,
                      child: IconButton(
                        icon: Icon(Icons.play_arrow),
                        iconSize: 40,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      VideoPlayerScreen(file.path,false)));
                        },
                        tooltip: "Play the recording",
                      ),
                    ),
                    // Text(video.value.duration.toString()),
                    // FutureBuilder(
                    // future: fFmpeg.execute("-i ${file.path} -hide_banner").then((info){
                    //   duration=info.toString();
                    // }),
                    // builder: (context, snapshot) {
                    //   if(snapshot.connectionState==ConnectionState.done)
                    //   return
                    //   Container(
                    //     color: Colors.black,
                    //     child: Text(
                    //      duration,
                    //      style: TextStyle(
                    //        color: Colors.white
                    //      ),),

                    //   );
                    //   else return Text("...");
                    // }
                    // ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left:20.0),
                  child: Container(
                    width: 200,
                    child: GestureDetector(
                      onTap:(){
                        Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          VideoPlayerScreen(file.path,false)));
                      },
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Title: " +
                            (file.path.split('/').last).split(".").first,
                            style:TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            ) ,),
                            
                        Padding(
                          padding: const EdgeInsets.only(top:10.0),
                          child: FutureBuilder(
                              future: file.stat().then((FileStat fileStat) {
                                return fileStat.changed.toString();
                              }),
                              builder: (context, snapshot) {
                                return Text("Date: " +
                                    snapshot.data.toString().split(" ").first,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey
                                    ),);
                              }),
                        ),
                        Text("Size: " +
                            (fileProperties.lengthSync() / (1000 * 1000))
                                .toStringAsPrecision(3) +
                            " MB",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey
                            ),),
                      ],
                    ),
                    ),
                  ),
                ),
                // IconButton(
                //   icon: Icon(Icons.play_circle_outline),
                //   onPressed: () {

                //   },
                //   tooltip: "Play the video",
                // ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () {
                          _share(file.path);
                        },
                        tooltip: "Share the video"),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _displayDeleteDialog(context, file);
                      },
                      tooltip: "Delete the video",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Divider(
          thickness: 0.2,
          color: Colors.grey,
        )
      ],
    );
  }
}
                                                   
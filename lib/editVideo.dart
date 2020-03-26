import 'dart:io';
// import 'package:audio_picker/audio_picker.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:streaming_app/NewVideo.dart';
import 'package:streaming_app/ScreenRecorder.dart';
import 'package:streaming_app/VideoPlayer.dart';

// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:streaming_app/NewVideo.dart';
// import 'package:streaming_app/ScreenRecorder.dart';
// import 'package:streaming_app/VideoPlayer.dart';
// import 'package:streaming_app/LoginPage.dart';
// import 'package:video_player/video_player.dart';
// import 'package:streaming_app/ScreenRecorder.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as p;
class EditPage extends StatefulWidget {
  FirebaseUser user;
  EditPage(this.user);
  @override
  _EditPageState createState() => _EditPageState(user);
}

class _EditPageState extends State<EditPage> {
  // TextEditingController fileName = TextEditingController();
  FirebaseUser user;
  List<FileSystemEntity> x = [];
  var dir = Directory('/storage/emulated/0/Movies/Vinio');
  // FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  _EditPageState(this.user);
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

  // FlutterSecureStorage storage = FlutterSecureStorage();
  bool isHD=false;
  TextEditingController fileName = TextEditingController();
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




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right:20.0),
          child: CircleAvatar(
            child: IconButton(
              icon: Icon(Icons.video_call),
              color: Colors.white,
              iconSize: 35,
              onPressed: () {
                _displayDialog(context);
              },
                 tooltip: "Create a new Recording",
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

  TextEditingController startPos = TextEditingController();
  TextEditingController stopPos = TextEditingController();

  // _displayTrimDialog(BuildContext context, FileSystemEntity y) async {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text('Trim'),
  //           content: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               Text("Start Position"),
  //               TextField(
  //                 controller: startPos,
  //                 maxLength: 8,
  //                 keyboardType: TextInputType.datetime,
  //                 decoration: InputDecoration(hintText: "00:00:00"),
  //               ),
  //               Text("\nStop Position"),
  //               TextField(
  //                 maxLength: 8,
  //                 controller: stopPos,
  //                 keyboardType: TextInputType.datetime,
  //                 decoration: InputDecoration(hintText: "00:00:00"),
  //               ),
  //             ],
  //           ),
  //           actions: <Widget>[
  //             new FlatButton(
  //               child: new Text('CANCEL'),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //             new FlatButton(
  //                 child: new Text('SAVE'),
  //                 onPressed: () async {
  //                   String path = y.path;
  //                   await fFmpeg.execute(
  //                       '-i $path -ss ${startPos.text} -ss ${stopPos.text} -c copy /storage/emulated/0/Movies/StreamingApp/${y.path.split('/').last.split('.').first}_trimmed.mp4');
  //                   startPos.clear();
  //                   stopPos.clear();
  //                   Navigator.of(context).pop();
  //                   _updateList();
  //                   setState(() {});
  //                   Fluttertoast.showToast(
  //                       msg:
  //                           "${y.path.split('/').last.split('.').first}_trimmed.mp4 saved");
  //                 })
  //           ],
  //         );
  //       });
  // }

  final FlutterFFmpeg fFmpeg = FlutterFFmpeg();
  Widget ListItem(FileSystemEntity file) {
    File fileProperties = File(file.path);
    return Column(
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.all(0),
          // subtitle:
          title: Container(
            margin: EdgeInsets.only(top: 10),
            // padding: EdgeInsets.only(left: 20, right: 5),
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(50),
              // color: Color(0xffFA817E),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left:20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Center(
                          child: Text("Title: " +
                              (file.path.split('/').last).split(".").first,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                              ),
                              )),
                      Padding(
                        padding: const EdgeInsets.only(top:8.0),
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
                      Center(
                        child: Text("Size: " +
                            (fileProperties.lengthSync() / (1000 * 1000))
                                .toStringAsPrecision(3) +
                            " MB",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14
                            ),),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      tooltip: "Trim",
                      icon: Icon(Icons.content_cut),
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    VideoPlayerScreen(file.path, true)));
                      },
                    ),
                    IconButton(
                      tooltip: "Remove Audio",
                      icon: Icon(Icons.volume_off),
                      onPressed: () async {
                        await fFmpeg.execute(
                            '-i ${file.path} -c copy -an /storage/emulated/0/Movies/Vinio/${file.path.split('/').last.split('.').first}_muted.mp4');
                        _updateList();
                        setState(() {
                          Fluttertoast.showToast(
                              msg:
                                  "${file.path.split('/').last.split('.').first}_muted.mp4 saved");
                        });
                      },
                    ),
                    // IconButton(
                    //   tooltip: "Remove Audio",
                    //   icon: Icon(Icons.volume_up),
                    //   onPressed: () async{
                    //     File audio = await FilePicker.getFile();
                    //     print(audio);
                    //     if(audio.path.isNotEmpty)
                    //    {await fFmpeg.execute('-i ${file.path} -i ${audio.path} -acodec copy -vcodec copy  /storage/emulated/0/Movies/StreamingApp/${file.path.split('/').last.split('.').first}_newAudio.mp4');
                    //     _updateList();
                    //     setState(() { });
                    //       Fluttertoast.showToast(msg: "${file.path.split('/').last.split('.').first}_muted.mp4 saved");
                    //    }
                    //   },
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Divider(
          color: Colors.grey,
          thickness: 0.2,
        )
      ],
    );
  }
}

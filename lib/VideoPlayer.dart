// import 'dart:async';
import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  String path;
  bool trim;
  VideoPlayerScreen(this.path, this.trim);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState(path, trim);
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  bool trim;
  String path;
  ChewieController chewieController;
  VideoPlayerController _controller;
  // Future<void> _initializeVideoPlayerFuture;
  _VideoPlayerScreenState(this.path, this.trim);
  @override
  void initState() {
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.file(File(path));
    // network(path);
    chewieController = ChewieController(
        videoPlayerController: _controller,
        aspectRatio: 2/4,
        autoInitialize: true,
        autoPlay: false,
        looping: false,
        startAt: Duration(milliseconds: 10));
    // Initialize the controller and store the Future for later use.
    // _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    // _controller.setLooping(false);
    start = "0:00:00.00";
    stop = "0:00:00.00";

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

// _displayDialog(BuildContext context) async {
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text('The file already exists. Do you want to replace'),
//             actions: <Widget>[
//               new FlatButton(
//                 child: new Text('NO'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//               new FlatButton(
//                 child: new Text('YES'),
//                 onPressed: () {
//                   await fFmpeg.execute(
//                             '-y -i $path -ss $start -to $stop -c copy /storage/emulated/0/Movies/StreamingApp/${path.split('/').last.split('.').first}_trimmed.mp4');
//                         Navigator.of(context).pop();
//                         Fluttertoast.showToast(
//                             msg:
//                                 "${path.split('/').last.split('.').first}_trimmed.mp4 saved");
//                 },
//               )
//             ],
//           );
//         });
//   }


  String start, stop;

  final FlutterFFmpeg fFmpeg = FlutterFFmpeg();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     title: Text(path.split('/').last),
      //     backgroundColor: Color(0xffFA817E)),
      body: ListView(
        children: <Widget>[
          Center(
              child: Chewie(
            controller: chewieController,
          )),
          trim
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Start Position: "),
                    Text("$start"),
                    RaisedButton(
                        onPressed: () {
                          _controller.pause();
                          setState(() {
                            start = _controller.value.position
                                .toString()
                                .replaceRange(10, 14, "");
                          });
                        },
                        child: Text("Set Start Position: ")),
                  ],
                )
              : Container(),
          trim
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("Stop Position: "),
                    Text("$stop"),
                    RaisedButton(
                        onPressed: () {
                          _controller.pause();
                          setState(() {
                            // stop=_controller.value.duration.toString();
                            stop = _controller.value.position
                                .toString()
                                .replaceRange(10, 14, "");
                          });
                        },
                        child: Text("Set Stop Position: ")),
                  ],
                )
              : Container(),
          trim
              ? Center(
                  child: GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xffFA817E),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text(
                        "Trim",
                        style: TextStyle(
                            color: Colors.white,
                            // fontWeight: FontWeight.w800,
                            fontSize: 40),
                      )),
                    ),
                    onTap: () async {
                      if (start.compareTo(stop) < 0) {
                        await fFmpeg.execute(
                            '-i $path -t $start -c copy -bsf:v h264_mp4toannexb -f mpegts /storage/emulated/0/Movies/Vinio/segment1.ts');
                            await fFmpeg.execute(
                            '-i $path -ss $stop -c copy -bsf:v h264_mp4toannexb -f mpegts /storage/emulated/0/Movies/Vinio/segment2.ts');
                            print(File("/storage/emulated/0/Movies/Vinio${path.split('/').last.split('.').first}_trim.mp4").existsSync());
                        if(File("/storage/emulated/0/Movies/Vinio/${path.split('/').last.split('.').first}_trim.mp4").existsSync()) 
                        { await fFmpeg.execute('-i "concat:/storage/emulated/0/Movies/Vinio/segment1.ts|/storage/emulated/0/Movies/Vinio/segment2.ts" -c copy  /storage/emulated/0/Movies/Vinio/${path.split('/').last.split('.').first}_trim(1).mp4');
                          File("/storage/emulated/0/Movies/Vinio/segment1.ts").deleteSync();
                          File("/storage/emulated/0/Movies/Vinio/segment2.ts").deleteSync();
                          // await fFmpeg.execute(
                        //     '-i $path -ss $start -to $stop -c copy /storage/emulated/0/Movies/Vinio/${path.split('/').last.split('.').first}_trimmed(1).mp4');
                        Navigator.of(context).pop();
                        Fluttertoast.showToast(
                            msg:
                                "${path.split('/').last.split('.').first}_trim(1).mp4 saved");
                        }
                        else 
                        { 
                          // await fFmpeg.execute(
                        //     '-i $path -ss $start -to $stop -c copy /storage/emulated/0/Movies/Vinio/${path.split('/').last.split('.').first}_trimmed.mp4');
                      
                            await fFmpeg.execute('-i "concat:/storage/emulated/0/Movies/Vinio/segment1.ts|/storage/emulated/0/Movies/Vinio/segment2.ts" -c copy  /storage/emulated/0/Movies/Vinio/${path.split('/').last.split('.').first}_trim.mp4');
                          File("/storage/emulated/0/Movies/Vinio/segment1.ts").deleteSync();
                          File("/storage/emulated/0/Movies/Vinio/segment2.ts").deleteSync();
                            // file.deleteSync();
        

                        Navigator.of(context).pop();
                        Fluttertoast.showToast(
                            msg:
                                "${path.split('/').last.split('.').first}_trim.mp4 saved");
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg:
                                "Start Position cannot be after Stop position");
                      }
                    },
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}

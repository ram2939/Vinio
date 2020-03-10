import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
// import 'package:flutter_android_pip/flutter_android_pip.dart';

List<CameraDescription> cameras;

class CameraApp extends StatefulWidget {
  final bool pip;
  CameraApp(this.pip);
  @override
  _CameraAppState createState() => _CameraAppState(pip);
}

class _CameraAppState extends State<CameraApp> {
  CameraController controller;
  bool pip;
  _CameraAppState(this.pip);
  call() async{
    cameras = await availableCameras();
    controller = CameraController(cameras[1], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }
  @override
  void initState() {
    super.initState();
    call();
    // FlutterAndroidPip.enterPictureInPictureMode(1);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (!controller.value.isInitialized) {
    //   return Container();
    // }
      // return Scaffold(
    //       appBar: AppBar(title: Text("Camera")),
    //       body:
      return Container(
              child: controller!=null
          ? AspectRatio(
            aspectRatio: pip!=true
            ? controller.value.aspectRatio
            : 1/1,
            child: CameraPreview(controller))
           :Center(
             child: CircularProgressIndicator(
          ),
          )
           );
  }
}
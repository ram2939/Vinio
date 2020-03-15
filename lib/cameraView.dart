import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

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
  call(int x) async {
    cameras = await availableCameras();
    controller = CameraController(cameras[x], ResolutionPreset.medium);
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
    call(1);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      return Container();
    } else
      return Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: <Widget>[
            controller != null
                ? AspectRatio(
                    aspectRatio:
                        pip != true ? controller.value.aspectRatio : 1 / 1,
                    child: CameraPreview(controller))
                : Center(
                    child: CircularProgressIndicator(),
                  ),
            controller.description == cameras[0]
                ? IconButton(
                    icon: Icon(Icons.camera_front),
                    iconSize: 50,
                    onPressed: () {
                      call(1);
                    },
                    tooltip: "Switch to Front Camera",
                  )
                : IconButton(
                    icon: Icon(Icons.camera_rear),
                    iconSize: 50,
                    onPressed: () {
                      call(0);
                    },
                    tooltip: "Switch to rear Camera",
                  )
          ]);
  }
}

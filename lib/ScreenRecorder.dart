import 'dart:async';

import 'package:flutter/services.dart';

class ScreenRecorder {
  static const _channel = const MethodChannel('samples.flutter.dev/battery');

  static Future<bool> startRecordScreen() async {
    final bool start = await _channel.invokeMethod('startRecording');
    return start;
  }

  static Future<String> get stopRecordScreen async {
    final String path =  await _channel.invokeMethod('stopRecording');
    return path;
  }
   static Future<String> get PIPmode async {
    final String path =  await _channel.invokeMethod('Pip');
    return path;
  }

  static Future<String> changeFileName(String x) async {
    final String path =  await _channel.invokeMethod('changeFileName',x);
    return path;
  }
  static Future<String> changeHD(bool isHD) async {
    final String path =  await _channel.invokeMethod('changeHD',isHD);
    return path;
  }
   static Future<String> getFilePath() async {
     final String path = await _channel.invokeMethod('getFilePath');
     return path;
   }

}

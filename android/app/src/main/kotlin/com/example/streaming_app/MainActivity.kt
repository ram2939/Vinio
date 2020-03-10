package com.example.streaming_app
import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import io.flutter.plugin.common.MethodChannel;
// import androidx.annotation.NonNull;
import android.media.projection.MediaProjectionManager;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import com.hbisoft.hbrecorder.HBRecorder;
import com.hbisoft.hbrecorder.HBRecorderCodecInfo;
import com.hbisoft.hbrecorder.HBRecorderListener;
import android.app.PictureInPictureParams;
import android.util.Rational;
class MainActivity: FlutterActivity(),HBRecorderListener{
    private val CHANNEL = "samples.flutter.dev/battery"
    final val SCREEN_RECORD_REQUEST_CODE:Int= 777;
    // private var hbRecorder:HBRecorder=HBRecorder(this,this);
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        var hbRecorder = HBRecorder(this, this);
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
            call, result ->
            if (call.method == "Start") {
                  startRecordingScreen();
            } else if(call.method == "Stop") {
                hbRecorder.stopScreenRecording();
            }
            // else if(call.method == "PIP") {
            //     enterPictureInPictureMode(PictureInPictureParams.Builder().setAspectRatio(Rational(1,1)).build());
            // //  
            // }
            else {
                result.notImplemented()
            }
          }
    }
    override fun HBRecorderOnError(p0: Int,p1: String)
    {

    }
    override fun HBRecorderOnComplete(){

    }
    fun startRecordingScreen() {
        var mediaProjectionManager:MediaProjectionManager  = getSystemService(Context.MEDIA_PROJECTION_SERVICE) as MediaProjectionManager;
        var permissionIntent: Intent?=null
        if(mediaProjectionManager != null) 
        {
        permissionIntent= mediaProjectionManager.createScreenCaptureIntent()
        }
        // else {
        // permissionIntent= null
        // }
        startActivityForResult(permissionIntent, SCREEN_RECORD_REQUEST_CODE);
    }
    override fun onActivityResult(requestCode:Int,resultCode:Int,data: Intent) {
        super.onActivityResult(requestCode, resultCode, data);
        var hbRecorder:HBRecorder=HBRecorder(this,this);
        if (requestCode == SCREEN_RECORD_REQUEST_CODE) {
            if (resultCode == RESULT_OK) {
                enterPictureInPictureMode(PictureInPictureParams.Builder().setAspectRatio(Rational(1,1)).build());
                //Start screen recording
                hbRecorder.startScreenRecording(data, resultCode, this);
    
            }
        }
    }
    

  
}

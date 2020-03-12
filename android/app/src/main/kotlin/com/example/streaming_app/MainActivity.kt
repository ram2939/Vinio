package com.example.streaming_app
import android.os.Environment;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import io.flutter.plugin.common.MethodChannel;
import java.io.File;
// import java.util.ArrayList;
// import java.util.Arrays;
// import java.util.List;
// import java.io.FilenameFilter;
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
    private lateinit var hbRecorder:HBRecorder;
  
    // private var hbRecorder:HBRecorder=HBRecorder(this,this);
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        hbRecorder = HBRecorder(this, this);
        val file:File= File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MOVIES).toString()+"/StreamingApp");
        if(!file.exists()) { file.mkdirs();}
        hbRecorder.setOutputPath(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MOVIES).toString()+"/StreamingApp");
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
            call, result ->
            if (call.method == "startRecording") {
                  startRecordingScreen();
            } else if(call.method == "stopRecording") {
                hbRecorder.stopScreenRecording();
            }
            else if(call.method == "changeFileName") {
                 hbRecorder.setFileName(call.arguments.toString());
            }
            else if(call.method == "getFilePath") {
                result.success(hbRecorder.getFilePath());
            }
            else if(call.method == "Pip") {
            enterPictureInPictureMode(PictureInPictureParams.Builder().setAspectRatio(Rational(1,1)).build());        
           }
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
        // var hbRecorder:HBRecorder=HBRecorder(this,this);
        if (requestCode == SCREEN_RECORD_REQUEST_CODE) {
            if (resultCode == RESULT_OK) {
                enterPictureInPictureMode(PictureInPictureParams.Builder().setAspectRatio(Rational(1,1)).build());
                //Start screen recording
                hbRecorder.startScreenRecording(data, resultCode, this);
    
            }
        }
    }
    // private fun getImages(): List<String> {
    //      var folder: File=File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MOVIES).toString()+"/denphy walls/");
    //     folder.mkdirs();
    //     allFiles: File[] = folder.listFiles(new FilenameFilter() {
    //         public boolean accept(File dir, String name) {
    //             return (name.endsWith(".jpg") || name.endsWith(".jpeg") || name.endsWith(".png"));
    //         }
    //     });
    //     List<String> item = new ArrayList<String>();
    //     for (File file : allFiles) {
    //         item.add(file + "");
    //     }
    //     return item;
    // }

  
}

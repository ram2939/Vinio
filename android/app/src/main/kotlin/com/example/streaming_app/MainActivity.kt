package com.example.streaming_app
import android.app.PendingIntent;
import android.app.RemoteAction;
import android.graphics.drawable.Icon;
import android.R.drawable;
// import android.graphics.drawable;
import android.net.Uri;
import android.os.Environment;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Parcelable;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import io.flutter.plugin.common.MethodChannel;
import java.io.File;
import android.content.BroadcastReceiver
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
import 	android.content.res.Configuration
;
class MainActivity: FlutterActivity(),HBRecorderListener{
    private val ACTION_MEDIA_CONTROL = "media_control"
    private val CHANNEL = "samples.flutter.dev/battery"
    final val SCREEN_RECORD_REQUEST_CODE:Int= 777;
    private val REQUEST_PAUSE = 2
    private lateinit var hbRecorder:HBRecorder;
    // private val mReceiver = object : BroadcastReceiver() {
    //     override fun onReceive(context: Context, intent: Intent?) {
    //         if (intent != null) {
    //             if (intent.action != ACTION_MEDIA_CONTROL) {
    //                 return
    //             }
    //             else  hbRecorder.stopScreenRecording();
    //             // This is where we are called back from Picture-in-Picture action items.
    //             // when (intent.getIntExtra(EXTRA_CONTROL_TYPE, 0)) {
    //             //     CONTROL_TYPE_PLAY -> mMovieView.play()
    //             //     CONTROL_TYPE_PAUSE -> mMovieView.pause()
    //             // }
    //         }
    //     }
    // }

    // private var hbRecorder:HBRecorder=HBRecorder(this,this);
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        hbRecorder = HBRecorder(this, this);
        hbRecorder.recordHDVideo(false);
        val file:File= File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MOVIES).toString()+"/Vinio");
        if(!file.exists()) { file.mkdirs();}
        // hbRecorder.shouldShowNotification(true);
        hbRecorder.setOutputPath(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MOVIES).toString()+"/Vinio");
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
           else if(call.method=="changeHD"){
               if(call.arguments.toString()=="true")
               hbRecorder.recordHDVideo(true);
               else hbRecorder.recordHDVideo(false);
           }
            else {
                result.notImplemented()
            }
          }
    }
    // fun playVideo(url:String)
    // {
    //     val intent: Intent=Intent(Intent.ACTION_VIEW);
    //         val uri:Uri=Uri.fromFile(File(url));
    //         intent.setDataAndType(uri, "video/*");
    //         intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
    //         startActivity(intent);
    //     }
    // fun getPIPActions():ArrayList<RemoteAction> {
    //    val intent:Intent=Intent("media control");
    //     // intent.setAction(Intent.PIP_ACTION_MUTE);   
    //     // intent.putExtra(Values.VIDEO_URL, video.getUrl());
    //     val pendingIntent:PendingIntent = PendingIntent.getBroadcast(context,0 ,intent, 0);
    //     val icon:Icon = Icon.createWithResource(this@MainActivity,drawable.ic_media_pause);
    //      var actions= ArrayList<RemoteAction>();
    //     actions.add(RemoteAction(icon,"Stop Recording","To stop recording", pendingIntent));
    //     //…
    //     return actions;
    //    }

    


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
        else {
        permissionIntent= null
        }
        if(permissionIntent!=null) 
        { startActivityForResult(permissionIntent, SCREEN_RECORD_REQUEST_CODE);
        }
    }
    override fun onActivityResult(requestCode:Int,resultCode:Int,data: Intent) {
        super.onActivityResult(requestCode, resultCode, data);
        // var hbRecorder:HBRecorder=HBRecorder(this,this);
        if (requestCode == SCREEN_RECORD_REQUEST_CODE) {
            if (resultCode == RESULT_OK) {
                // enterPictureInPictureMode(PictureInPictureParams.Builder().setAspectRatio(Rational(1,1)).build());
                //Start screen recording
                hbRecorder.startScreenRecording(data, resultCode, this);
    
            }
        }
    }
      
}

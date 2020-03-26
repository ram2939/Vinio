import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:local_notifications/local_notifications.dart';
// import 'package:provider/provider.dart';
// import 'package:streaming_app/HomePage.dart';
import 'package:streaming_app/LoginPage.dart';
import 'package:streaming_app/MainPage.dart';

// import 'package:streaming_app/ScreenRecorder.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final storage = FlutterSecureStorage();
  checkLogin() async {
    return await storage.read(key: "1");
  }

  loginWithEmail() async {
    var email = await storage.read(key: '2');
    var pass = await storage.read(key: '3');
    FirebaseUser user = (await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: pass))
        .user;
    return MainPage(user);
  }

  loginWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    return MainPage(user);
  }

  Widget loadingScreen(){
    return  Container(
      child: Center(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
               Padding(
                 padding: const EdgeInsets.only(top: 50.0),
                 child: Image(image: AssetImage("assets/logo.png"),
                 height: 200,
                 ),
               ),
               Padding(
                 padding: const EdgeInsets.only(top: 50,bottom: 20),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: <Widget>[
                     
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: <Widget>[
                         Text("Experience  ",
                         textAlign: TextAlign.center,
                         style: TextStyle(
                           color: Colors.grey,
                           fontSize: 35,
                         ),
                         ),
                         Text("the",
                         textAlign: TextAlign.center,
                         style: TextStyle(
                           color: Colors.grey,
                           fontSize: 25,
                         ),
                         ),
                       ],
                     ),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: <Widget>[
                         Text("Future  ",
                         textAlign: TextAlign.center,
                         style: TextStyle(
                           color: Colors.grey,
                           fontSize: 35,
                         ),
                         ),
                         Text("of",
                         textAlign: TextAlign.center,
                         style: TextStyle(
                           color: Colors.grey,
                           fontSize: 25,
                         ),
                         ),
                       ],
                     ),
                     Text("Expressions",
                        //  textAlign: TextAlign.center,
                         style: TextStyle(
                           color: Colors.grey,
                           fontSize: 35,
                         ),
                         ),
                   ],
                 ),
               ),
              ],
            )
      ),
    );

  }
  // // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Vinio',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
          future: checkLogin(),
          builder: (context, snapshot) {
            if (snapshot.data == "email") {
              return FutureBuilder(
                  future: loginWithEmail(),
                  builder: (context, snap) {
                    if (snap.hasData)
                      return snap.data;
                    else
                      return Scaffold(
                          backgroundColor: Colors.white,
                          body: loadingScreen());
                  });
            } else if (snapshot.data == "google") {
              return FutureBuilder(
                  future: loginWithGoogle(),
                  builder: (context, snap) {
                    if (snap.hasData)
                      return snap.data;
                    else
                      return Scaffold(
                          backgroundColor: Colors.white,
                          body: loadingScreen());
                  });
            } else
              return LoginPage();
          },
        ));
  }
}

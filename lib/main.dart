import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:provider/provider.dart';
import 'package:streaming_app/HomePage.dart';
import 'package:streaming_app/LoginPage.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final storage=FlutterSecureStorage();
  // //Future<String> isLoggedIn;
  // FirebaseUser user;
  checkLogin() async{
    return await storage.read(key: "1");
  }
  loginWithEmail() async
   {
     var email =await storage.read(key: '2');
     var pass =await storage.read(key: '3');
     FirebaseUser user= (await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass)).user;
     return HomePage(user);
   }
   loginWithGoogle() async
   {
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
     return HomePage(user);
   }
  // // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return Provider<FlutterSecureStorage>(
    //   create:(context)=>storage,
    // child: 
     return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StreamingApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: checkLogin(),
        builder: (context,snapshot)
      {
        if(snapshot.data=="email")
        {
          return FutureBuilder(
            future: loginWithEmail(),
            builder: (context,snap)
          {
            if(snap.hasData) return snap.data;
            else return Container(color: Colors.white,
              child: Center(child: CircularProgressIndicator()));
          }
          );
        }
        else if(snapshot.data=="google")
        {
          return FutureBuilder(
            future: loginWithGoogle(),
            builder: (context,snap)
          {
            if(snap.hasData) return snap.data;
            else return Container(color: Colors.white,
              child: Center(child: CircularProgressIndicator()));
          } 

          );
        }
        else return LoginPage();

      },)
      
    );
    // );
  }
}


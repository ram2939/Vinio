// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:provider/provider.dart';
// import 'package:streaming_app/HomePage.dart';
import 'package:streaming_app/LoginPage.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // final storage=FlutterSecureStorage();
  // //Future<String> isLoggedIn;
  // FirebaseUser user;
  // loginWithEmail() async
  //  {
  //    var email =await storage.read(key: "2");
  //    var pass =await storage.read(key: "3");
  //    FirebaseUser user= (await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass)).user;
  //    return HomePage(user);
  //  }
  //  loginWithGoogle() async
  //  {
  //    var accessToken =await storage.read(key: "2");
  //    var idToken =await storage.read(key: "3");
  //    final AuthCredential credential = GoogleAuthProvider.getCredential(
  //     accessToken: accessToken,
  //     idToken: idToken,
  //   );
  //   final FirebaseUser user =
  //       (await FirebaseAuth.instance.signInWithCredential(credential)).user;
  //    return HomePage(user);
  //  }
  // // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return Provider<FlutterSecureStorage>(
    //   create:(context)=>storage,
    // child: 
     return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      // home:FutureBuilder(
      //   future: storage.read(key: "1"),
      //   builder: (context,snapshot)
      //   {
      //     if(snapshot.hasData)
      //     {
      //       if(snapshot.data=="email")
      //       {
      //         return loginWithEmail();
      //       }
      //       else if(snapshot.data=="google"){
      //           return loginWithGoogle();
      //       }
      //       else {
      //         return LoginPage();
      //       }
      //     }
      //     else 
      //     {
      //       return CircularProgressIndicator();
      //     }
      //   }
      // )
    );
    // );
  }
}


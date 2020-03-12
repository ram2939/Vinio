import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:provider/provider.dart';
import 'package:streaming_app/HomePage.dart';
import 'package:streaming_app/SignIn.dart';
import 'package:streaming_app/Signup.dart';
import 'package:permission_handler/permission_handler.dart';


class LoginPage extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> _handleSignIn(BuildContext context) async {
    // final storage=Provider.of<FlutterSecureStorage>(context,listen: false);
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    // await storage.write(key: "1", value: "google");
    // await storage.write(key: "2", value: googleAuth.accessToken);
    // await storage.write(key: "1", value: googleAuth.idToken);
    print("signed in " + user.displayName);
    return user;
  }

  requestPermissions() async {
    await PermissionHandler().requestPermissions([
      PermissionGroup.storage,
      PermissionGroup.photos,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    requestPermissions();
    BoxDecoration decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(10), color: Colors.redAccent);

    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  child: Container(
                    decoration: decoration,
                    height: 50,
                    width: 150,
                    child: Center(child: Text("Sign In")),
                  ),
                  onTap: () {
                    print("Signin tapped");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignIn()));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  child: Container(
                    decoration: decoration,
                    height: 50,
                    width: 150,
                    child: Center(child: Text("Sign Up")),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUp()));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                    child: Container(
                      decoration: decoration,
                      height: 50,
                      width: 150,
                      child: Center(child: Text("Sign In with Google")),
                    ),
                    onTap: () {
                      _handleSignIn(context).then((FirebaseUser user) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage(user)));
                      });
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

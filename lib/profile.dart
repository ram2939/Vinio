import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:streaming_app/LoginPage.dart';
import 'package:streaming_app/my_flutter_app_icons.dart';

class Profile extends StatefulWidget{
  FirebaseUser user;
  Profile(this.user);
  @override
  _ProfileState createState() => _ProfileState(user);
}

class _ProfileState extends State<Profile> {
  // final FlutterSecureStorage storage=FlutterSecureStorage();
  final FirebaseUser user;
  _ProfileState(this.user);
  final FlutterSecureStorage storage=FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () async{
                if(await storage.read(key: "1")=="email")
                _displayDialog(context);
                else Fluttertoast.showToast(msg: "Change Password not available for google sign in");
              },
              child: Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                  color:Colors.pink[300],
                  borderRadius: BorderRadius.circular(50)
                ),
                child: Center(child: Text("Change Password")),
              ),
            ),
          ),
          Center(
            child: GestureDetector(
                      child: Container(child: Center(child: Text("Sign Out")),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.pink[300]
                      ),

                      height: 50,
                      width: 150,),
                      onTap: () async{
                        if (await storage.read(key: '1') == "email")
                        {print("Email signout");
                        await FirebaseAuth.instance.signOut();
                        }
                      else
                        await GoogleSignIn().signOut();
                      storage.delete(key: "1");
                      Fluttertoast.showToast(
                          msg: "You have been successfully logged out");
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => new LoginPage()));
                    },
                    ),
          ),
        ],
      )
    );
  }
_displayDialog(BuildContext context) async {
    // TextEditingController oldPass=TextEditingController();
    TextEditingController newPass=TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
                     builder: (BuildContext context, StateSetter setState){
                       bool showPass=false;
                    return  AlertDialog(
              title: Text('Change Password'),
              content: TextField(
                controller: newPass,
                obscureText: !showPass,
                decoration:
                    InputDecoration(hintText: "New Password",
                    suffixIcon: IconButton(
                      icon: showPass
                      ? Icon(MyFlutterApp.eye)
                      : Icon(MyFlutterApp.eye_off),
                      onPressed: (){
                        setState((){
                          showPass=!showPass;
                        });
                                              },
                    )),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('CANCEL'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text('CHANGE'),
                  onPressed: () {
                    if(newPass.text.length>5)
                    {user.updatePassword(newPass.text).then((_){
                        Fluttertoast.showToast(msg: "Password Successfully changed");
                        Navigator.of(context).pop();
                        storage.write(key: "3", value: newPass.text);
                        
                    });}
                    else Fluttertoast.showToast(msg: "Password cannot be less han 6 characters") ;
                  },
                )
              ],
            );
          }
          );
        });
  }

  
}
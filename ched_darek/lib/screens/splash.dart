import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  initState() {
    FirebaseAuth.instance
        .currentUser()
        .then((currentUser) => {
              if (currentUser == null)
                {Navigator.pushReplacementNamed(context, "/login")}
              else
                {
                  Firestore.instance
                      .collection("users")
                      .document(currentUser.uid)
                      .get()
                      .then((DocumentSnapshot result) =>
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(
                                        uid: currentUser.uid,
                                      ))))
                      .catchError((err) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 20),
                            title: Text(
                              " !!خطأ",
                              textAlign: TextAlign.end,
                            ),
                            actions: <Widget>[
                              FlatButton(
                                padding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                                textColor: Theme.of(context).primaryColor,
                                child: Text("جرب مرة أخرى؟"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                              )
                            ],
                          );
                        });
                  })
                }
            })
        .catchError((err) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              title: Text(
                " !!خطأ",
                textAlign: TextAlign.end,
              ),
              actions: <Widget>[
                FlatButton(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  textColor: Theme.of(context).primaryColor,
                  child: Text("جرب مرة أخرى؟"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                )
              ],
            );
          });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset('assets/icons/icon.png')),
    );
  }
}

import 'package:ched_darek_volunteer/shared/loading.dart';
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
        .then((currentVolunteer) => {
              if (currentVolunteer == null)
                {Navigator.pushReplacementNamed(context, "/login")}
              else
                {
                  Firestore.instance
                      .collection("volunteers")
                      .document(currentVolunteer.uid)
                      .get()
                      .then((DocumentSnapshot result) =>
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(
                                        uid: currentVolunteer.uid,
                                      ))))
                      .catchError((err) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 20),
                            title: Text(
                              "Erreur !!",
                              textAlign: TextAlign.end,
                            ),
                            actions: <Widget>[
                              FlatButton(
                                padding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                                textColor: Theme.of(context).primaryColor,
                                child: Text("Réessayer"),
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
                "Erreur !",
                textAlign: TextAlign.end,
              ),
              actions: <Widget>[
                FlatButton(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  textColor: Theme.of(context).primaryColor,
                  child: Text("Réessayer"),
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

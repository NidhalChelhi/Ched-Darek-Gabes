import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ched_darek_volunteer/screens/home.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;

  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email incorrect';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Mot de passe doit être d\'au moins 8 caractères';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('S\'identifier'),
        ),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Form(
              key: _loginFormKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                        icon: Icon(Icons.person),
                        labelText: 'Email',
                        hintText: "Tunisia@gmail.com"),
                    controller: emailInputController,
                    keyboardType: TextInputType.emailAddress,
                    validator: emailValidator,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        labelText: 'Mot de passe',
                        hintText: "********"),
                    controller: pwdInputController,
                    obscureText: true,
                    validator: pwdValidator,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  RaisedButton(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(130.0),
                    ),
                    child: Text("Se Connecter"),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      if (_loginFormKey.currentState.validate()) {
                        try {
                          FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: emailInputController.text,
                                  password: pwdInputController.text)
                              .catchError((error) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 20),
                                    title: Text(
                                      "Erreur",
                                      textAlign: TextAlign.end,
                                    ),
                                    content: Text(
                                      "Ce compte n'existe pas, essayer de modifier les données ou créer un nouveau compte.",
                                      textAlign: TextAlign.end,
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 10),
                                        textColor:
                                            Theme.of(context).primaryColor,
                                        child: Text("D'accord"),
                                        onPressed: () {
                                          emailInputController.clear();
                                          pwdInputController.clear();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                      )
                                    ],
                                  );
                                });
                          }).then((currentVolunteer) {
                            Firestore.instance
                                .collection("volunteers")
                                .document(currentVolunteer.uid)
                                .get()
                                .then((DocumentSnapshot result) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HomePage(uid: currentVolunteer.uid)));
                            }).catchError((err) {
                              setState(() {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 20),
                                        title: Text(
                                          "Erreur",
                                          textAlign: TextAlign.end,
                                        ),
                                        content: Text(
                                          "Ce compte n'existe pas, essayer de modifier les données ou créer un nouveau compte.",
                                          textAlign: TextAlign.end,
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 10),
                                            textColor:
                                                Theme.of(context).primaryColor,
                                            child: Text("D'accord"),
                                            onPressed: () {
                                              emailInputController.clear();
                                              pwdInputController.clear();
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
                            });
                          }).catchError((err) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 20),
                                    title: Text(
                                      "Erreur",
                                      textAlign: TextAlign.end,
                                    ),
                                    content: Text(
                                      "Ce compte n'existe pas, essayer de modifier les données ou créer un nouveau compte.",
                                      textAlign: TextAlign.end,
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 10),
                                        textColor:
                                            Theme.of(context).primaryColor,
                                        child: Text("D'accord"),
                                        onPressed: () {
                                          emailInputController.clear();
                                          pwdInputController.clear();
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
                        } on PlatformException catch (e) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 20),
                                  title: Text(
                                    "Erreur",
                                    textAlign: TextAlign.end,
                                  ),
                                  content: Text(
                                    "Ce compte n'existe pas, essayer de modifier les données ou créer un nouveau compte.",
                                    textAlign: TextAlign.end,
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 10),
                                      textColor: Theme.of(context).primaryColor,
                                      child: Text("D'accord"),
                                      onPressed: () {
                                        emailInputController.clear();
                                        pwdInputController.clear();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                    )
                                  ],
                                );
                              });
                        }
                      }
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text("Nouveau volontaire ?"),
                  OutlineButton(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 1),
                      textColor: Theme.of(context).primaryColor,
                      highlightedBorderColor: Theme.of(context).primaryColor,
                      child: Text("S'inscrire"),
                      onPressed: () {
                        Navigator.pushNamed(context, "/register");
                      },
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      )),
                ],
              ),
            ))));
  }
}

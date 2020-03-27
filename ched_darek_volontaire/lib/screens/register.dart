import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ched_darek_volunteer/screens/home.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController fullnameInputController;
  TextEditingController adressInputController;
  TextEditingController phoneInputController;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;

  @override
  initState() {
    fullnameInputController = new TextEditingController();
    adressInputController = new TextEditingController();
    phoneInputController = new TextEditingController();

    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    confirmPwdInputController = new TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'S\'il vous plaît, mettez une adresse email valide';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return "Mot de passe doit être d'au moins 8 caractères";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> locations = [
      "سيدي ابولبابه",
      "السبخة",
      "حي الأمل",
      "زريق",
      "المنارة",
      "مطرش",
      "شنتش",
      "باب بحر",
      "جارة",
      "البلد القديم",
      "بدورة",
      "تبلبو",
      "شنني نحال"
    ];
    randomListItem(List locations) =>
        locations[new Random().nextInt(locations.length)];
    return Scaffold(
        appBar: AppBar(
          title: Text("S'inscrire comme nouveau volontaire"),
        ),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Form(
              key: _registerFormKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Nom et Prénom'),
                    controller: fullnameInputController,
                    validator: (value) {
                      if (value.length < 5) {
                        return "Veuillez saisir un nom valide";
                      }
                    },
                  ),
                  TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 2,
                      decoration: InputDecoration(
                          labelText: 'Adresse exacte',
                          hintText: randomListItem(locations)),
                      controller: adressInputController,
                      validator: (value) {
                        if (value.length < 10) {
                          return "Veuillez saisir une adresse précise";
                        }
                      }),
                  TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Numéro de téléphone',
                          hintText: "00 000 000"),
                      controller: phoneInputController,
                      validator: (value) {
                        if (value.length < 8) {
                          return "Numéro de téléphone est requis";
                        }
                      }),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Email', hintText: "Gabes@gmail.com"),
                    controller: emailInputController,
                    keyboardType: TextInputType.emailAddress,
                    validator: emailValidator,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Mot de passe', hintText: "********"),
                    controller: pwdInputController,
                    obscureText: true,
                    validator: pwdValidator,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Confirmez le mot de passe',
                        hintText: "********"),
                    controller: confirmPwdInputController,
                    obscureText: true,
                    validator: pwdValidator,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  RaisedButton(
                    child: Text("S\'inscrire"),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      if (_registerFormKey.currentState.validate()) {
                        if (pwdInputController.text ==
                            confirmPwdInputController.text) {
                          FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: emailInputController.text,
                                  password: pwdInputController.text)
                              .then((currentVolunteer) {
                            Firestore.instance
                                .collection("volunteers")
                                .document(currentVolunteer.uid)
                                .setData({
                                  "uid": currentVolunteer.uid,
                                  "fullname": fullnameInputController.text,
                                  "adress": adressInputController.text,
                                  "phone": phoneInputController.text,
                                  "email": emailInputController.text,
                                })
                                .then((result) => {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HomePage(
                                                    uid: currentVolunteer.uid,
                                                  )),
                                          (_) => false),
                                      fullnameInputController.clear(),
                                      adressInputController.clear(),
                                      phoneInputController.clear(),
                                      emailInputController.clear(),
                                      pwdInputController.clear(),
                                      confirmPwdInputController.clear()
                                    })
                                .catchError((err) {
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
                                          actions: <Widget>[
                                            FlatButton(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 10),
                                              textColor: Theme.of(context)
                                                  .primaryColor,
                                              child: Text("Réessayer?"),
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
                          }).catchError((err) => {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 20),
                                            title: Text(
                                              "Erreur",
                                              textAlign: TextAlign.end,
                                            ),
                                            actions: <Widget>[
                                              FlatButton(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 10),
                                                textColor: Theme.of(context)
                                                    .primaryColor,
                                                child: Text("Réessayer"),
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
                                        })
                                  });
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Erreur"),
                                  content: Text(
                                      "Les mots de passe ne correspondent pas"),
                                  actions: <Widget>[
                                    FlatButton(
                                      textColor: Theme.of(context).primaryColor,
                                      child: Text("Réessayer ?"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
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
                  Text("Vous avez déjà un compte?"),
                  OutlineButton(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 1),
                    textColor: Theme.of(context).primaryColor,
                    child: Text("Se connecter"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ))));
  }
}

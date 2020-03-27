import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ched_darek/screens/home.dart';

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
      return 'البريد الالكتروني مش صحيح';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'كلمة السر لازم تكون أكثر من 8 حروف';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('تسجيل دخول'),
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
                        labelText: 'البريد الالكتروني',
                        hintText: "Tunisia@gmail.com"),
                    controller: emailInputController,
                    keyboardType: TextInputType.emailAddress,
                    validator: emailValidator,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        labelText: 'كلمة السر',
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
                    child: Text("دخول"),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      if (_loginFormKey.currentState.validate()) {
                        try {
                          FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: emailInputController.text,
                                  password: pwdInputController.text)
                              .then((currentUser) {
                            Firestore.instance
                                .collection("users")
                                .document(currentUser.uid)
                                .get()
                                .then((DocumentSnapshot result) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HomePage(uid: currentUser.uid)));
                            }).catchError((err) {
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
                                      content: Text(
                                        "لا يوجد حساب بهذه المعلومات",
                                        textAlign: TextAlign.end,
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 10),
                                          textColor:
                                              Theme.of(context).primaryColor,
                                          child: Text("جرب مرة أخرى؟"),
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
                          }).catchError((err) {
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
                                    content: Text(
                                      "لا يوجد حساب بهذه المعلومات",
                                      textAlign: TextAlign.end,
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 10),
                                        textColor:
                                            Theme.of(context).primaryColor,
                                        child: Text("جرب مرة أخرى؟"),
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
                        } catch (e) {
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
                                  content: Text(
                                    "لا يوجد حساب بهذه المعلومات",
                                    textAlign: TextAlign.end,
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 10),
                                      textColor: Theme.of(context).primaryColor,
                                      child: Text("جرب مرة أخرى؟"),
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
                  Text("مازلت معملتش حساب ؟؟"),
                  OutlineButton(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 1),
                      textColor: Theme.of(context).primaryColor,
                      child: Text("!حساب جديد"),
                      onPressed: () {
                        Navigator.pushNamed(context, "/register");
                      },
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ))
                ],
              ),
            ))));
  }
}

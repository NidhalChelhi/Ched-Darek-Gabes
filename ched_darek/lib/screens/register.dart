import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ched_darek/screens/home.dart';

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
          title: Text("تسجيل حساب جديد"),
        ),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Form(
              key: _registerFormKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'اسمك الكامل'),
                    controller: fullnameInputController,
                    validator: (value) {
                      if (value.length < 5) {
                        return "من فضلك إكتب اسمك الكامل";
                      }
                    },
                  ),
                  TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'العنوان',
                      ),
                      controller: adressInputController,
                      validator: (value) {
                        if (value.length < 5) {
                          return "من فضلك أدخل عنوانك بدقة";
                        }
                      }),
                  TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'رقم الهاتف', hintText: "00 000 000"),
                      controller: phoneInputController,
                      validator: (value) {
                        if (value.length < 8) {
                          return "لازم تعطينا نيمروك";
                        }
                      }),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: 'البريد الالكتروني',
                        hintText: "Gabes@gmail.com"),
                    controller: emailInputController,
                    validator: emailValidator,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'كلمة السر', hintText: "********"),
                    controller: pwdInputController,
                    obscureText: true,
                    validator: pwdValidator,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'تأكيد كلمة السر', hintText: "********"),
                    controller: confirmPwdInputController,
                    obscureText: true,
                    validator: pwdValidator,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  RaisedButton(
                    child: Text("تسجيل"),
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
                              .then((currentUser) {
                            Firestore.instance
                                .collection("users")
                                .document(currentUser.uid)
                                .setData({
                                  "uid": currentUser.uid,
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
                                                    uid: currentUser.uid,
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
                                            " !!خطأ",
                                            textAlign: TextAlign.end,
                                          ),
                                          actions: <Widget>[
                                            FlatButton(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 10),
                                              textColor: Theme.of(context)
                                                  .primaryColor,
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
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(" !!خطأ"),
                                  content: Text("!كلمات السر مهمش كيف كيف"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("عاود مرة أخرى ؟"),
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
                  Text("عندك حساب؟"),
                  OutlineButton(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 1),
                    textColor: Theme.of(context).primaryColor,
                    child: Text("!سجل دخولك"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ))));
  }
}

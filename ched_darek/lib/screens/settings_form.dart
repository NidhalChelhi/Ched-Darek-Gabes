import 'dart:math';

import 'package:ched_darek/models/user.dart';
import 'package:ched_darek/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SettingForm extends StatefulWidget {
  SettingForm({Key key, this.uid}) : super(key: key);

  final String uid;

  @override
  _SettingFormState createState() => _SettingFormState();
}

class _SettingFormState extends State<SettingForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController serviceInputController;

  @override
  initState() {
    serviceInputController = new TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> orders = [
      "🥚 حارة عظم",
      "🥔 كيلو بطاطا",
      "🥖 خبزتين",
      "Doliprane 1000 💊",
      "🥤 دبوزتين قازوز",
      "🍝 سباقيتي نيمرو 2"
    ];
    randomListItem(List orders) => orders[new Random().nextInt(orders.length)];

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Text('اطلب خدمة واحنا نوصلوهالك لباب الدار',
              style: TextStyle(fontSize: 20.0), textAlign: TextAlign.center),
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: 'الطلب',
              hintText: randomListItem(orders),
            ),
            controller: serviceInputController,
            validator: (value) {
              if (value.length < 5) {
                return "من فضلك اكتب طلب واضح";
              }
            },
          ),
          SizedBox(height: 15.0),
          StreamBuilder<Object>(
              stream: DatabaseService(uid: widget.uid).userData,
              builder: (context, snapshot) {
                UserData userData = snapshot.data;
                return RaisedButton(
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      'تسجيل طلب',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      Firestore.instance
                          .collection("users")
                          .document(widget.uid)
                          .collection('services')
                          .add({
                        "overview": serviceInputController.text,
                        "date": new DateFormat.yMEd()
                            .add_jms()
                            .format(new DateTime.now()),
                        "done": false
                      }).then((currentservice) {
                        Firestore.instance
                            .collection('users')
                            .document(widget.uid)
                            .collection('services')
                            .document(currentservice.documentID)
                            .updateData({"sid": currentservice.documentID});
                        Firestore.instance
                            .collection('services')
                            .document(currentservice.documentID)
                            .setData({
                          "sid": currentservice.documentID,
                          "overview": serviceInputController.text,
                          "date": new DateFormat.yMEd()
                              .add_jms()
                              .format(new DateTime.now()),
                          "fullname": userData.fullname,
                          "phone": userData.phone,
                          "adress": userData.adress,
                          "done": false,
                        });
                        Navigator.pop(context);
                      });
                      //  else {
                      //   showDialog(
                      //       context: context,
                      //       builder: (BuildContext context) {
                      //         return AlertDialog(
                      //           title: Text(" !!خطأ"),
                      //           content: Text("!من فضلك اكتب طلب واضح"),
                      //           actions: <Widget>[
                      //             FlatButton(
                      //               child: Text("عاود مرة أخرى ؟"),
                      //               onPressed: () {
                      //                 Navigator.of(context).pop();
                      //               },
                      //             )
                      //           ],
                      //         );
                      //       });
                      // }
                    });
              }),
          SizedBox(height: 20),
          IconButton(
            icon: Icon(
              Icons.arrow_downward,
              size: 40,
              color: Colors.grey[800],
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

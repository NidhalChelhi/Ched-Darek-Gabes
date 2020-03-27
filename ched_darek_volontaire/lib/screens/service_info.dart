import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceInfo extends StatefulWidget {
  ServiceInfo({
    Key key,
    this.sid,
    this.overview,
    this.date,
    this.done,
    this.fullname,
    this.phone,
    this.adress,
  }) : super(key: key);

  final String sid;
  final String overview;
  final String date;
  final String fullname;
  final String phone;
  final String adress;
  final bool done;

  @override
  _ServiceInfoState createState() => _ServiceInfoState();
}

class _ServiceInfoState extends State<ServiceInfo> {
  @override
  Widget build(BuildContext context) {
    bool _isButtonDisabled = widget.done;
    String _check() {
      if (widget.done) {
        return 'Terminé';
      } else {
        return 'Terminé ?';
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 50,
        ),
        Center(
          child: Text('Informations sur le service:',
              style: TextStyle(fontSize: 24.0), textAlign: TextAlign.center),
        ),
        SizedBox(
          height: 32,
        ),
        Row(
          children: <Widget>[
            Icon(
              Icons.shopping_cart,
              color: Colors.grey[800],
            ),
            SizedBox(width: 7),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Text('Service: ' + widget.overview,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.grey[800])),
            ),
          ],
        ),
        SizedBox(
          height: 7,
        ),
        Row(
          children: <Widget>[
            Icon(
              Icons.account_circle,
              color: Colors.grey[800],
            ),
            SizedBox(width: 7),
            Text('Citoyen: ' + widget.fullname,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.grey[800])),
          ],
        ),
        SizedBox(
          height: 7,
        ),
        Row(
          children: <Widget>[
            Icon(
              Icons.phone_android,
              color: Colors.grey[800],
            ),
            SizedBox(width: 7),
            Text('Téléphone: ' + widget.phone,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.grey[800])),
          ],
        ),
        SizedBox(
          height: 7,
        ),
        Row(
          children: <Widget>[
            Icon(
              Icons.my_location,
              color: Colors.grey[800],
            ),
            SizedBox(width: 7),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Text('Adresse: ' + widget.adress,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  maxLines: 10,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.grey[800])),
            ),
          ],
        ),
        SizedBox(
          height: 7,
        ),
        Row(
          children: <Widget>[
            Icon(
              Icons.date_range,
              color: Colors.grey[800],
            ),
            SizedBox(width: 7),
            Text('Date: ' + widget.date,
                style: TextStyle(fontSize: 15, color: Colors.grey[800])),
          ],
        ),
        SizedBox(
          height: 32,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          // buttonPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),

          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton.icon(
                    padding: EdgeInsets.all(0),
                    icon: Icon(Icons.delete),
                    disabledTextColor: Colors.grey[500],
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                "Avertissement",
                              ),
                              content: Text(
                                "Vous allez effacer ce service ?",
                              ),
                              actions: <Widget>[
                                ButtonBar(
                                  children: <Widget>[
                                    FlatButton(
                                      color: Theme.of(context).primaryColor,
                                      textColor: Colors.white,
                                      child: Text("D'accord"),
                                      onPressed: () {
                                        Firestore.instance
                                            .collection('services')
                                            .document(widget.sid)
                                            .delete();

                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    FlatButton(
                                      textColor: Theme.of(context).primaryColor,
                                      child: Text("Annuler"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                )
                              ],
                            );
                          });
                    },
                    label: Text('Effacer'),
                    textColor: Theme.of(context).primaryColor,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(50.0),
                    )),
                OutlineButton.icon(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    icon: Icon(Icons.call),
                    disabledTextColor: Colors.grey[500],
                    onPressed: () async {
                      String number = 'tel:' + widget.phone;
                      if (await canLaunch(number)) {
                        await launch(number);
                      } else {
                        throw 'Could not launch $number';
                      }
                    },
                    label: Text('Appeler'),
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 1),
                    textColor: Theme.of(context).primaryColor,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(50.0),
                    )),
              ],
            ),
            FlatButton.icon(
                padding: EdgeInsets.symmetric(horizontal: 10),
                icon: Icon(Icons.done),
                color: Theme.of(context).primaryColor,
                onPressed: _isButtonDisabled
                    ? null
                    : () {
                        Firestore.instance
                            .collection('services')
                            .document(widget.sid)
                            .updateData({'done': true});
                        Navigator.pop(context);
                      },
                label: Text(_check()),
                textColor: Colors.white,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                )),
          ],
        ),
      ],
    );
  }
}

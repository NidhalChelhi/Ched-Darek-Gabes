import 'package:ched_darek_volunteer/models/service.dart';
import 'package:ched_darek_volunteer/screens/service_info.dart';
import 'package:ched_darek_volunteer/services/database.dart';
import 'package:ched_darek_volunteer/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.uid}) : super(key: key);
  final String uid;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _showServiceInfoPanel(String sid, String overview, String date,
      bool done, String fullname, String phone, String adress) async {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: ServiceInfo(
                sid: sid,
                overview: overview,
                date: date,
                done: done,
                fullname: fullname,
                phone: phone,
                adress: adress,
              ));
        });
  }

  Widget build(BuildContext context) {
    double containerHeight = MediaQuery.of(context).size.height / 1.5;
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
            onPressed: () {
              FirebaseAuth.instance
                  .signOut()
                  .then((result) =>
                      Navigator.pushReplacementNamed(context, "/login"))
                  .catchError((err) => print(err));
            },
            child: Text(
              'Se déconnecter',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
        title: Text('Page d\'accueil'),
      ),
      body: StreamBuilder<List<Service>>(
          stream: DatabaseService(uid: widget.uid).services,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }
            if (snapshot.hasData) {
              List<Service> services = snapshot.data;
              if (services.length > 0) {
                return new ListView(
                  children: services.map((document) {
                    return Card(
                        // color: Theme.of(context).cardColor,
                        color: Colors.white,
                        child: ListTile(
                          enabled: true,
                          title: Text(document.overview,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).primaryColor,
                              )),
                          subtitle: Text(document.adress,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).primaryColor,
                              )),
                          onTap: () {
                            _showServiceInfoPanel(
                                document.sid,
                                document.overview,
                                document.date,
                                document.done,
                                document.fullname,
                                document.phone,
                                document.adress);
                          },
                        ));
                  }).toList(),
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.cancel,
                        color: Colors.grey[400],
                        size: 90,
                      ),
                      Text(
                        'Pas de services',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.grey[400],
                        ),
                      )
                    ],
                  ),
                );
              }
            } else {
              return Loading(
                color: Colors.white,
                size: 70,
              );
            }
          }),
    );
  }
}

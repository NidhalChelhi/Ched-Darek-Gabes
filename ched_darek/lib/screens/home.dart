import 'package:ched_darek/models/service.dart';
import 'package:ched_darek/models/user.dart';
import 'package:ched_darek/models/volunteer.dart';
import 'package:ched_darek/screens/settings_form.dart';
import 'package:ched_darek/services/database.dart';
import 'package:ched_darek/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.uid}) : super(key: key);
  final String uid;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _showSettingsPanel() async {
    showModalBottomSheet(
      isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
              padding: EdgeInsets.symmetric(horizontal: 60, vertical: 150),
              child: SettingForm(
                uid: widget.uid,
              ));
        });
  }

  int bottomSelectedIndex = 1;

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
          icon: Icon(
            Icons.info,
            size: 18,
          ),
          title: Text(
            'من نحن',
            style: TextStyle(fontSize: 12),
          )),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.home,
          size: 18,
        ),
        title: Text(
          'الصفحة الرئيسية',
          style: TextStyle(fontSize: 12),
        ),
      ),
      BottomNavigationBarItem(
          icon: Icon(
            Icons.format_list_bulleted,
            size: 18,
          ),
          title: Text(
            'قائمة المتطوعين',
            style: TextStyle(fontSize: 12),
          ))
    ];
  }

  PageController pageController = PageController(
    initialPage: 1,
    keepPage: true,
  );

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    double containerHeight = MediaQuery.of(context).size.height / 2.6;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        elevation: 80,
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Theme.of(context).accentColor,
        unselectedItemColor: Colors.grey[400],
        showSelectedLabels: true,
        showUnselectedLabels: false,
        currentIndex: bottomSelectedIndex,
        items: buildBottomNavBarItems(),
        onTap: (index) {
          bottomTapped(index);
        },
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          pageChanged(index);
        },
        children: <Widget>[
          Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                FlatButton(
                  textColor: Colors.white,
                  onPressed: () {
                    FirebaseAuth.instance
                        .signOut()
                        .then((result) =>
                            Navigator.pushReplacementNamed(context, "/login"))
                        .catchError((err) => print(err));
                  },
                  child: Text(
                    'تسجيل خروج',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
              title: Text('من نحن ؟'),
            ),
            body: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        child: Text(
                      "شد دارك هي مبادرة هدفها المساهمة في تطبيق الحجر الصحي بصفة أفضل. بالمبادرة هاذي تنجم تطلب أي قضية (ماكلة، دواء..)، يوصلك عن طريق أحد المتطوعين إلي سخروا أنفسهم للخدمة هذي. بالطبيعة بعدما تطلب قضيتك يكلمك المتطوع بش يثبت منك وياخذ أكثر تفاصيل. كل إلي نرجوه منك كمواطن انك تقوم بدورك وواجبك تجاه بلادك.. انك تشد دارك",
                      textAlign: TextAlign.end,
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    )),
                    SizedBox(height: 15,),
                    Text(
                      'خاتر نحبوك و نخافو عليك',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'خممنا  نجيبولك قضيتك لبين يديك',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'ما عليك كان تكتب لي حشتك بيه',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'و متطوعينا يوصلولك لي تقول عليه',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'نعرفوك واعي ماشاء الله عليك',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'هكا علاه بربّي منغير منوصيك',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'خروج من الدار مفمّش',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'حتى وباء الكورونا يتكمّش',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'ومتنساش القضية لي طلبتها',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'بعد متخلصها، من باب دارك  تعقمّها ',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Scaffold(
              appBar: AppBar(
                actions: <Widget>[
                  FlatButton(
                    textColor: Colors.white,
                    onPressed: () {
                      FirebaseAuth.instance
                          .signOut()
                          .then((result) =>
                              Navigator.pushReplacementNamed(context, "/login"))
                          .catchError((err) => print(err));
                    },
                    child: Text(
                      'تسجيل خروج',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
                title: Text('الصفحة الرئيسية'),
              ),
              body: ListView(
                children: <Widget>[
                  StreamBuilder<UserData>(
                      stream: DatabaseService(uid: widget.uid).userData,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          UserData userData = snapshot.data;
                          return Card(
                            color: Theme.of(context).accentColor,
                            margin: EdgeInsets.fromLTRB(35, 15, 35, 15),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    ':بروفيلك',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        userData.fullname,
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        ' :الاسم الكامل',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 18,
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Text(
                                          userData.adress,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        ' :العنوان',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.my_location,
                                        color: Colors.white,
                                        size: 18,
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        userData.phone,
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        ' :رقم الهاتف',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.phone_android,
                                        color: Colors.white,
                                        size: 18,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Loading(
                            color: Colors.white,
                            size: 70,
                          );
                        }
                      }),
                  Card(
                    margin: EdgeInsets.fromLTRB(35, 0, 35, 0),
                    color: Theme.of(context).accentColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            ':طلباتك',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          height: containerHeight,
                          padding: const EdgeInsets.all(12.0),
                          child: StreamBuilder<List<Service>>(
                              stream: DatabaseService(uid: widget.uid).services,
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  print(snapshot.error);
                                }
                                if (snapshot.hasData) {
                                  List<Service> services = snapshot.data;
                                  if (services.length > 0) {
                                    return Scrollbar(
                                      child: new ListView(
                                        children: services.map((document) {
                                          return Card(
                                            color: Theme.of(context).cardColor,
                                            child: ListTile(
                                              onTap: () {
                                                return;
                                              },
                                              title: new Text(
                                                '-' + document.overview,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                              subtitle: new Text(
                                                document.date,
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white),
                                              ),
                                              trailing: IconButton(
                                                onPressed: () {
                                                  print(document.overview);
                                                  Firestore.instance
                                                      .collection("users")
                                                      .document(widget.uid)
                                                      .collection('services')
                                                      .document(document.sid)
                                                      .delete()
                                                      .then((currentservice) {
                                                    Firestore.instance
                                                        .collection('services')
                                                        .document(document.sid)
                                                        .delete();
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    );
                                  } else {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.cancel,
                                          color: Colors.grey[400],
                                          size: 90,
                                        ),
                                        Text(
                                          'مازالت ماطلبت حتى خدمة',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.grey[400],
                                          ),
                                        )
                                      ],
                                    );
                                  }
                                } else {
                                  return Loading(
                                    color: Colors.white,
                                    size: 70,
                                  );
                                }
                              }),
                        )
                      ],
                    ),
                  )
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  _showSettingsPanel();
                },
                backgroundColor: Theme.of(context).primaryColor,
                label: Text('اطلب خدمة'),
                icon: Icon(Icons.add_circle_outline),
              )),
          Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                FlatButton(
                  textColor: Colors.white,
                  onPressed: () {
                    FirebaseAuth.instance
                        .signOut()
                        .then((result) =>
                            Navigator.pushReplacementNamed(context, "/login"))
                        .catchError((err) => print(err));
                  },
                  child: Text(
                    'تسجيل خروج',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
              title: Text('قائمة المتطوعين'),
            ),
            body: StreamBuilder<List<VolunteerData>>(
                stream: DatabaseService().volunteers,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                  }
                  if (snapshot.hasData) {
                    List<VolunteerData> services = snapshot.data;
                    if (services.length > 0) {
                      return Scrollbar(
                        child: new GridView.count(
                          childAspectRatio: (size.width / itemHeight),
                          primary: false,
                          padding: const EdgeInsets.all(10),
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                          crossAxisCount: 2,
                          children: services.map((document) {
                            return Card(
                              color: Theme.of(context).cardColor,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.account_circle,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          document.fullname,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.my_location,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          document.adress,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.phone_android,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          document.phone,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        FlatButton.icon(
                                            padding: EdgeInsets.all(0),
                                            onPressed: () async {
                                              String number =
                                                  'tel:' + document.phone;
                                              if (await canLaunch(number)) {
                                                await launch(number);
                                              } else {
                                                throw 'Could not launch $number';
                                              }
                                            },
                                            icon: Icon(
                                              Icons.call,
                                              size: 15,
                                              color: Colors.white,
                                            ),
                                            label: Text(
                                              'مكالمة',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white),
                                            )),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    } else {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.cancel,
                              color: Colors.grey[800],
                              size: 90,
                            ),
                            Text(
                              'لا يوجد متطوع حالياً',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.grey[800],
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
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'screens/register.dart';
import 'screens/splash.dart';
import 'screens/login.dart';
import 'screens/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Ched Darek - Gabès',
        theme: ThemeData(
          primaryColor: Colors.redAccent,
          cardColor: Colors.red[600],
          accentColor: Colors.red[400],
          fontFamily: 'Cairo',
        ),
        home: SplashPage(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => HomePage(),
          '/login': (BuildContext context) => LoginPage(),
          '/register': (BuildContext context) => RegisterPage(),
        });
  }
}

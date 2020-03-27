import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  Loading({Key key, @required this.color, @required this.size})
      : super(key: key);
  final Color color;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SpinKitChasingDots(
          color: color,
          size: size,
        ),
      ),
    );
  }
}


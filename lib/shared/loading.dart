import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.pink[50],
      child: Center(
        child: SpinKitChasingDots(
          color: Colors.black,
          size: 50.0,
        ),
      ),
    );
  }
}
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:aliaapp/ConsValue.dart';

class CloseApp extends StatefulWidget {
  CloseApp({Key? key}) : super(key: key);

  @override
  _CloseAppState createState() => _CloseAppState();
}

class _CloseAppState extends State<CloseApp> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 500), () {
      //infoClass().ShowImage1();
      exit(0);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Color4,
        body: Center(
          child: MainImageSmall(),
        ),
      ),
    );
  }
}

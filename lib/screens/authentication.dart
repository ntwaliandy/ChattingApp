//@dart=2.9
import 'package:chatapp_draft/screens/login.dart';
import 'package:chatapp_draft/screens/register.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSigIn = true;
  void toggleView() {
    setState(() => showSigIn = !showSigIn);
  }

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    if (showSigIn) {
      return Login(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}

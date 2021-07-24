//@dart=2.9
import 'package:chatapp_draft/screens/authentication.dart';
import 'package:chatapp_draft/screens/home.dart';
import 'package:chatapp_draft/services/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserF>(context);
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}

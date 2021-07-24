//@dart=2.9
import 'package:chatapp_draft/screens/register.dart';
import 'package:chatapp_draft/screens/wrapper.dart';
import 'package:chatapp_draft/services/auth.dart';
import 'package:chatapp_draft/services/user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserF>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/register': (context) => Register(),
        },
        home: Wrapper(),
      ),
    );
  }
}

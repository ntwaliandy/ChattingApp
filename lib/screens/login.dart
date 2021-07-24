//@dart=2.9

import 'package:chatapp_draft/services/auth.dart';
import 'package:chatapp_draft/services/database.dart';
import 'package:chatapp_draft/services/helperfunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  final Function toggleView;
  Login({this.toggleView});
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  QuerySnapshot snapshotUserInfo;
  //validator
  String email;
  String password;
  String error;

  DatabaseMethods databaseMethods = new DatabaseMethods();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Sign In to Exclusive App',
          style: TextStyle(
            letterSpacing: 2.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35.0),
                  topRight: Radius.circular(35.0),
                ),
              ),
              padding: EdgeInsets.only(left: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 25,
                    ),
                    SizedBox(width: 20),
                    Center(
                      child: Text(
                        'Email',
                        style: TextStyle(
                          letterSpacing: 1.8,
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.email,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextFormField(
                            validator: (val) =>
                                val.isEmpty ? 'Please Enter Your Number' : null,
                            onChanged: (val) {
                              setState(() => email = val);
                            },
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            autofocus: false,
                            decoration: InputDecoration(
                              hintText: 'Enter Your Email.....',
                              hintStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        'password',
                        style: TextStyle(
                          letterSpacing: 1.8,
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.password,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextFormField(
                            obscureText: true,
                            validator: (val) =>
                                val.length < 6 ? 'Invalid passowrd' : null,
                            onChanged: (val) {
                              setState(() => password = val);
                            },
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            autofocus: false,
                            decoration: InputDecoration(
                              hintText: 'Enter Your password.....',
                              hintStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Center(
                      // ignore: deprecated_member_use
                      child: RaisedButton(
                        color: Colors.grey[400],
                        elevation: 0.0,
                        padding: EdgeInsets.fromLTRB(50, 15.0, 50.0, 15.0),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            dynamic result = await _auth
                                .signInWithEmailAndPassword(email, password);

                            databaseMethods.getUserByEmail(email).then((val) {
                              snapshotUserInfo = val;
                              HelperFunctions.saveUserEmailSharedPreference(
                                  snapshotUserInfo.docChanges[0].doc["email"]);
                            });
                            print(email);

                            HelperFunctions.saveUserLoggedInSharedPreference(
                                true);

                            if (result == null) {
                              setState(() =>
                                  error = 'Wrong Information, couldnt sign in');
                            }
                          }
                        },
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Center(
                      child: Text(
                        error ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Center(
                      // ignore: deprecated_member_use
                      child: RaisedButton(
                        padding: EdgeInsets.fromLTRB(50, 15.0, 50.0, 15.0),
                        elevation: 0.0,
                        onPressed: () {
                          widget.toggleView();
                        },
                        color: Colors.grey[400],
                        child: Text(
                          'Sign Up',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              'Designed By Andy250',
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}

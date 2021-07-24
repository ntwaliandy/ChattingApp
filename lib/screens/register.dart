//@dart=2.9

import 'package:chatapp_draft/services/auth.dart';
import 'package:chatapp_draft/services/database.dart';
import 'package:chatapp_draft/services/helperfunctions.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  //validator
  String email;
  String password;
  String error;
  //
  DatabaseMethods databaseMethods = new DatabaseMethods();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0.0,
        title: Text(
          'Sign Up to Exclusive App',
          style: TextStyle(
            letterSpacing: 2.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          // ignore: deprecated_member_use
          FlatButton.icon(
            onPressed: () {
              widget.toggleView();
            },
            icon: Icon(Icons.person),
            label: Text(
              'Sign In',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
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
                            validator: (val) => val.length < 6
                                ? 'Your Password is too short!'
                                : null,
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
                                .registerWithEmailAndPassoword(email, password);

                            Map<String, String> userInfoMap = {"email": email};

                            HelperFunctions.saveUserEmailSharedPreference(
                                email);

                            databaseMethods.uploadUserInfo(userInfoMap);

                            //saving shared preferences
                            HelperFunctions.saveUserLoggedInSharedPreference(
                                true);

                            if (result == null) {
                              setState(
                                  () => error = 'please apply a valid email');
                            }
                          }
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Center(
                      child: Text(
                        error ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1.8,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
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

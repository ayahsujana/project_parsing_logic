import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:parsingjson/bookmark.dart';
import 'package:parsingjson/category.dart';
import 'package:parsingjson/dataprofil.dart';
import 'package:parsingjson/models/custom.dart';
import 'package:parsingjson/new_product.dart';
import 'package:parsingjson/register.dart';
import 'package:parsingjson/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyApp extends StatefulWidget {
  final VoidCallback signOut;
  MyApp({this.signOut});
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  TabController controller;

  _logout() {
    var dialog = AlertDialog(
        title: Text("Confirmation"),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                widget.signOut();
              });
            },
            child: Text("Yes"),
          )
        ],
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[Text("Are you sure you want sign out?")],
          ),
        ));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        bottomNavigationBar: TabBar(
          controller: controller,
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.black,
          indicatorWeight: 2.0,
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.fiber_new),
              text: "Product",
            ),
            Tab(
              icon: Icon(Icons.format_list_bulleted),
              text: "Category",
            ),
            Tab(
              icon: Icon(Icons.bookmark_border),
              text: "Bookmark",
            ),
            Tab(
              icon: Icon(Icons.settings),
              text: "Settings",
            )
          ],
        ),
        appBar: AppBar(
          // bottom: TabBar(
          //   controller: controller,
          //   tabs: <Widget>[
          //     Tab(
          //       icon: Icon(Icons.fiber_new),
          //       text: "New Product",
          //     ),
          //     Tab(
          //       icon: Icon(Icons.category),
          //       text: "Category",
          //     ),
          //     Tab(
          //      icon: Icon(Icons.settings),
          //       text: "Settings",
          //     )
          //   ],
          // ),
          title: Text('Parsing Json Logic'),
          leading: Icon(Icons.reorder),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => Profil()));
              },
              icon: Icon(Icons.account_circle),
            ),
            IconButton(
              onPressed: _logout,
              icon: Icon(Icons.lock_open),
            )
          ],
        ),
        body: TabBarView(
          controller: controller,
          children: <Widget>[
            NewProduct(),
            CategoryProduct(),
            Bookmark(),
            Settings()
          ],
        ),
      ),
    );
  }
}

class Login extends StatefulWidget {
  LoginState createState() => LoginState();
}

enum CekLogin { notSign, signIn }

class LoginState extends State<Login> {
  CekLogin cekLogin = CekLogin.notSign;
  var _key = new GlobalKey<FormState>();
  final _keySnack = GlobalKey<ScaffoldState>();
  String email, password;
  var isLoading = true;
  var passwordFocus = FocusNode();

  nextPasswordFocus(){
    FocusScope.of(context).requestFocus(passwordFocus);
  }

  void checkForm() {
    final formKey = _key.currentState;
    if (formKey.validate()) {
      formKey.save();
      login();
    } else {
      print("object");
    }
  }

  login() async {
    final response = await http.post(
        "http://sampulbox.com/parsinglogic/login.php",
        body: {"email": email.trim(), "password": password.trim()});
    final data = json.decode(response.body);
    int value = data['value'];
    if (value == 1) {
      savePref(data['name'], data['email'], data['password'], data['telpon']);
      setState(() {
        cekLogin = CekLogin.signIn;
      });
    } else {
      var dialog = AlertDialog(
          title: Text("Login failed!!"),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            )
          ],
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Your email or password is incorrect, please try again.")
              ],
            ),
          ));
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return dialog;
          });
    }
  }

  void savePref(
      String nama, String email, String password, String telpon) async {
    SharedPreferences sharePref = await SharedPreferences.getInstance();
    sharePref.setString('nama', nama);
    sharePref.setString('email', email);
    sharePref.setString('password', password);
    sharePref.setString("telpon", telpon);
    sharePref.commit();
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString('email');
    });
    setState(() {
      cekLogin = email == null ? CekLogin.notSign : CekLogin.signIn;
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('email', null);
    preferences.commit();
    setState(() {
      cekLogin = CekLogin.notSign;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (cekLogin) {
      case CekLogin.notSign:
        return Scaffold(
          body: Container(
            padding: EdgeInsets.all(10.0),
            child: Form(
              key: _key,
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Hero(
                        tag: 'hero',
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 75.0,
                          child: Image.asset('img/logo.png'),
                        ),
                      ),
                    ),
                    EditText(
                      onFieldSubmitted: (e) {nextPasswordFocus();},
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (e) => email = (e),
                      labelText: "Email Address",
                      errorText: "Please input your email address",
                    ),
                    EditText(
                      focusNode: passwordFocus,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      onSaved: (e) => password = (e),
                      labelText: "Password",
                      errorText: "Please input your password",
                    ),
                    ButtonClick(
                      labelText: "Sign In",
                      onPressed: checkForm,
                    ),
                    ButtonClick(
                      labelText: "Register",
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => Register()));
                      },
                    ),
                    FlatButton(
                      child: Text(
                        'Forgot password? Click here',
                        style: TextStyle(color: Colors.black54),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ForgotPassword()));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      case CekLogin.signIn:
        return MyApp(
          signOut: signOut,
        );
    }
  }
}

class ForgotPassword extends StatefulWidget {
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _key = GlobalKey<FormState>();
  String email;

  _cekEmail() {
    final _formKey = _key.currentState;
    if (_formKey.validate()) {
      _formKey.save();
      _showDialog();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Form(
          key: _key,
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Hero(
                    tag: 'hero',
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 75.0,
                      child: Image.asset('img/logo.png'),
                    ),
                  ),
                ),
                EditText(
                  onSaved: (e) => email = (e),
                  keyboardType: TextInputType.emailAddress,
                  errorText: "Please fill your email address",
                  labelText: "Email Address",
                ),
                ButtonClick(
                  onPressed: _cekEmail,
                  labelText: "Submit",
                ),
                FlatButton(
                  child: Text(
                    'Already have account? Click here',
                    style: TextStyle(color: Colors.black54),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showDialog() {
    var dialog = AlertDialog(
        title: Text("Reset Password"),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("OK"),
          )
        ],
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                  "Please check your email in a few minutes and follow the instructions provided to reset your password.")
            ],
          ),
        ));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parsingjson/custom.dart';

class Register extends StatefulWidget {
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  final _fromkey = GlobalKey<FormState>();
  String email, password, name, phone;

  void daftar() {
    final form = _fromkey.currentState;
    if (form.validate()) {
      form.save();
      register();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Form(
        key: _fromkey,
        child: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            EditText(
              keyboardType: TextInputType.text,
              onSaved: (e) => name = (e),
              labelText: "Full Name",
              errorText: "Please input your full name",
            ),
            EditText(
              keyboardType: TextInputType.phone,
              onSaved: (e) => phone = (e),
              labelText: "Phone Number",
              errorText: "Please input your phone number",
            ),
            EditText(
              keyboardType: TextInputType.emailAddress,
              onSaved: (e) => email = (e),
              labelText: "Email Address",
              errorText: "Please input your email address",
            ),
            EditText(
              obscureText: true,
              keyboardType: TextInputType.text,
              onSaved: (e) => password = (e),
              labelText: "Password",
              errorText: "Please input your password",
            ),
            ButtonClick(
              labelText: "Sign Up",
              onPressed: daftar,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Already have account? Click here",
                        style: TextStyle(
                            fontStyle: FontStyle.normal, color: Colors.blue),
                      ),
                    )
                  ]),
            )
          ],
        ),
      ),
    ));
  }

  void register() async {
    final response = await http
        .post("http://sampulbox.com/parsinglogic/register.php", body: {
      "email": email,
      "password": password,
      "nama": name,
      "telpon": phone
    });
    final registerJson = json.decode(response.body);
    print("$registerJson");
  }
}

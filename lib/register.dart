import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parsingjson/models/custom.dart';

class Register extends StatefulWidget {
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  final _fromkey = GlobalKey<FormState>();
  String email, password, name, phone;

  var phoneNumber = FocusNode();
  var emailAddress = FocusNode();
  var passwordFocus = FocusNode();

  focusPhoneNumber(){
    FocusScope.of(context).requestFocus(phoneNumber);
  }
  focusEmailAddress(){
    FocusScope.of(context).requestFocus(emailAddress);
  }
  focusPassword(){
    FocusScope.of(context).requestFocus(passwordFocus);
  }

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
              onFieldSubmitted: (e){focusPhoneNumber();},
              keyboardType: TextInputType.text,
              onSaved: (e) => name = (e),
              labelText: "Full Name",
              errorText: "Please input your full name",
            ),
            EditText(
              focusNode: phoneNumber,
              onFieldSubmitted: (e){focusEmailAddress();},
              keyboardType: TextInputType.phone,
              onSaved: (e) => phone = (e),
              labelText: "Phone Number",
              errorText: "Please input your phone number",
            ),
            EditText(
              focusNode: emailAddress,
              onFieldSubmitted: (e){focusPassword();},
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
              labelText: "Sign Up",
              onPressed: daftar,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Already have account? Click here",
                  style: TextStyle(
                      fontStyle: FontStyle.normal, color: Colors.black54),
                ),
              )
            ])
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

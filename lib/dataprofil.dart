import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:parsingjson/custom.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Profil extends StatefulWidget {
  ProfilState createState() => ProfilState();
}

class ProfilState extends State<Profil> {
  String nama, email, password, telpon;
  var loading = true;
  getPref() async {
    SharedPreferences showPref = await SharedPreferences.getInstance();
    setState(() {
      nama = showPref.getString("nama");
      email = showPref.getString("email");
      password = showPref.getString("password");
      telpon = showPref.getString("telpon");
      loading = false;
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Profil"),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                FlatButton(
                  child: Text("Edit Profil"),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => EditProfil()));
                  },
                ),
                Divider(
                  color: Colors.black38,
                  height: 3.0,
                ),
                FlatButton(
                  child: Text("Change Password"),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => ChangePassword()));
                  },
                ),
                Divider(
                  color: Colors.black38,
                  height: 3.0,
                ),
              ],
            ),
    );
  }
}

class EditProfil extends StatefulWidget {
  _EditProfilState createState() => _EditProfilState();
}

class _EditProfilState extends State<EditProfil> {
  String email;
  void getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nama = preferences.getString("nama");
      phone = preferences.getString("telpon");
      email = preferences.getString("email");
      init();
    });
  }

  void init() {
    namaController = TextEditingController(text: nama);
    phoneController = TextEditingController(text: phone);
  }

  final _formKey = new GlobalKey<FormState>();
  void getEdit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _update();
    }
  }

  _savePref(String nama, String phone) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("nama", nama);
    sharedPreferences.setString("telpon", phone);
    sharedPreferences.commit();
  }

  _update() async {
    final response = await http
        .post("http://sampulbox.com/parsinglogic/edit.php", body: {
      "nama": namaController.text,
      "telpon": phoneController.text,
      "email": email
    });

    final edit = jsonDecode(response.body);
    int value = edit["value"];
    if (value == 1) {
      setState(() {
        _savePref(namaController.text, phoneController.text);
      });
      var dialog = AlertDialog(
          title: Text("Information"),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Close"),
            )
          ],
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text("Profil has been updated")],
            ),
          ));
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return dialog;
          });
    }
  }

  TextEditingController namaController, phoneController;
  String nama, phone;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profil'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            EditText(
              controller: namaController,
              labelText: "Full Name",
              keyboardType: TextInputType.text,
              onSaved: (e) => nama = (e),
            ),
            EditText(
              controller: phoneController,
              labelText: "Nomor Telpon",
              keyboardType: TextInputType.text,
              onSaved: (e) => phone = (e),
            ),
            ButtonClick(
              onPressed: getEdit,
              labelText: "Ubah",
            )
          ],
        ),
      ),
    );
  }
}

class ChangePassword extends StatefulWidget {
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = new GlobalKey<FormState>();
String password, confirmpass, email;

  _setPassword(String password) async {
    SharedPreferences preferencesPassword = await SharedPreferences.getInstance();
    preferencesPassword.setString("password", password);
  }

  getPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
          email = sharedPreferences.getString("email");
        });
  }

  _password() async {
    final response = await http
        .post("http://sampulbox.com/parsinglogic/password.php", body: {
      "password": password,
      "email": email
    });

    final data = jsonDecode(response.body);
    int value = data["value"];
    if (value == 1) {
      setState(() {
        _setPassword(password);
      });
      var dialog = AlertDialog(
          title: Text("Information"),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Close"),
            )
          ],
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text("Password has been change")],
            ),
          ));
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return dialog;
          });
    }
  }

  _getPassword() {
    final formpass = _formKey.currentState;
    if (formpass.validate()) {
      formpass.save();
      if (password.toString() == confirmpass.toString()) {
        _password();
        print("password berhasil");
      } else {
        print("password tidak sama");
      }
      
    }
  }

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      getPref();
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            EditText(
              obscureText: true,
              keyboardType: TextInputType.text,
              onSaved: (e) => password = (e),
              labelText: "New password",
            ),
            EditText(
              obscureText: true,
              keyboardType: TextInputType.text,
              onSaved: (e) => confirmpass = (e),
              labelText: "Confirm password",
            ),
            ButtonClick(
              onPressed: _getPassword,
              labelText: "Change Password",
            ),
            ButtonClick(
              onPressed: () {
                Navigator.pop(context);
              },
              labelText: "Cancel",
            )
          ],
        ),
      ),
    );
  }
}

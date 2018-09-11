import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profil extends StatefulWidget{
  ProfilState createState()=>  ProfilState();
}


class ProfilState extends State<Profil> {
  String nama , email, password, telpon;
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
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(),
      body: loading? Center(child: CircularProgressIndicator(),) : Column(
        children: <Widget>[
          Text("Nama :" + nama),
          Text("Email : "+ email),
          Text("Password : $password"),
          Text("Telpon : $telpon")
        ],
      ),
    );
  }
}

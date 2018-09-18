import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:parsingjson/custom.dart';
import 'package:parsingjson/dataprofil.dart';
import 'package:parsingjson/register.dart';
import 'dart:async';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Picture;
import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:parsingjson/model.dart';

void main() {
  runApp(FirstPage());
}

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
    );
  }
}

class MyApp extends StatefulWidget {
  final VoidCallback signOut;
  MyApp({this.signOut});
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final dataList = List<ModelData>();

  var data = false;
  var isLoading = true;

  Future<Null> _loadData() async {
    await Future.delayed(Duration(seconds: 2));
    _fetchData();
  }

  _fetchData() async {
    final response = await http.get('http://sampulbox.com/parsinglogic/');

    if (response.statusCode == 200) {
      print("Data ditemukan");
      if (response.body.length > 2) {
        dataList.clear();
        final loadListData = json.decode(response.body);
        loadListData.forEach((api) {
          final apiList = ModelData(
              api['id'], api['imageName'], api['fileName'], api['createdData']);

          dataList.add(apiList);
        });
        setState(() {
          isLoading = false;
          data = true;
        });
      } else {
        setState(() {
          isLoading = false;
          data = false;
        });
      }
    } else {
      print("Data tidak ditemukan");
    }
  }

  saveLogout() async {
    setState(() {
      widget.signOut();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    var kosong = isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Data Kosong",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              Image.asset(
                'img/error_data.png',
                width: 75.0,
                height: 75.0,
              )
            ],
          );

    var ada = isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (context, i) {
              final modelData = dataList[i];
              return ListItem(modelData);
            },
          );
    return Scaffold(
      appBar: AppBar(
        title: Text('Parsing Json Logic'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Profil()));
            },
            icon: Icon(Icons.account_circle),
          ),
          IconButton(
            onPressed: saveLogout,
            icon: Icon(Icons.lock_open),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: Container(
          child: data ? ada : kosong,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => AddNewImageFromGallery()));
        },
        child: Icon(Icons.image),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final url = "http://sampulbox.com/parsinglogic/image/";
  final ModelData dataListItem;
  ListItem(this.dataListItem);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Material(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          elevation: 3.0,
          child: SingleChildScrollView(
            child: InkWell(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Hero(
                      tag: dataListItem,
                      child: FadeInImage.assetNetwork(
                        placeholder: 'img/picture.png',
                        image: url + dataListItem.file,
                        fit: BoxFit.cover,
                        height: 200.0,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      dataListItem.nameGambar,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddNewImageFromGallery extends StatefulWidget {
  AddNewImageFromGalleryState createState() => AddNewImageFromGalleryState();
}

class AddNewImageFromGalleryState extends State<AddNewImageFromGallery> {
  File _imageFile;
  final imageKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String imageName, imageFromGallery;
  TextEditingController _textController = new TextEditingController();

  void addImage() {
    final formImage = _formKey.currentState;
    if (formImage.validate()) {
      formImage.save();
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
      appBar: AppBar(
        title: Text('Upload New Image'),
      ),
      key: imageKey,
      body: Container(
        child: Column(
          children: <Widget>[
            _buildImagePreview(),
            _buildTextFieldName(),
            _buildRaiseButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    var placeholder = Stack(
      children: <Widget>[
        Container(
          constraints: BoxConstraints.expand(),
          child: Image.asset(
            'img/picture.png',
            fit: BoxFit.cover,
            colorBlendMode: BlendMode.darken,
            color: Colors.black38,
          ),
        ),
        Align(
          child: Text('No selected image',
              textScaleFactor: 1.2,
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                  fontSize: 20.0)),
        )
      ],
    );
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Material(
            shadowColor: Theme.of(context).accentColor,
            type: MaterialType.card,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            elevation: 3.0,
            child: _imageFile == null
                ? placeholder
                : Image.file(
                    _imageFile,
                    fit: BoxFit.cover,
                  )),
      ),
      fit: FlexFit.tight,
    );
  }

  Widget _buildTextFieldName() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _textController,
        decoration: InputDecoration(
          labelText: 'Name of image', fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.all(8.0),
        ),
        maxLines: 1,
      ),
    );
  }

  Widget _buildRaiseButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: FlatButton(
            padding: EdgeInsets.all(20.0),
            onPressed: _chooseImage,
            child: Text(
              'Gallery',
              textAlign: TextAlign.center,
            ),
            color: Colors.white30,
          ),
          fit: FlexFit.tight,
        ),
        Flexible(
          child: FlatButton(
            padding: EdgeInsets.all(20.0),
            onPressed: _chooseCamera,
            child: Icon(Icons.camera_alt),
            color: Colors.white30,
          ),
          fit: FlexFit.tight,
        ),
        Flexible(
          child: FlatButton(
            padding: EdgeInsets.all(20.0),
            onPressed: _uploadImageToServer,
            child: Text(
              'Upload',
              textAlign: TextAlign.center,
            ),
            color: Colors.white30,
          ),
          fit: FlexFit.tight,
        )
      ],
    );
  }

  _chooseImage() async {
    _imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );

    final tempDir = await getTemporaryDirectory();
    final pathImage = tempDir.path;

    int randomTitle = Math.Random().nextInt(100000);

    Picture.Image img = Picture.decodeImage(_imageFile.readAsBytesSync());
    Picture.Image reSizeImg = Picture.copyResize(img, 720);

    var convertImg = File('$pathImage/image_$randomTitle.png')
      ..writeAsBytesSync(Picture.encodeJpg(reSizeImg, quality: 85));

    _textController.text = path.basename(_imageFile.path);
    setState(() {
      _imageFile = convertImg;
    });
  }

  _chooseCamera() async {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

    final tempDir = await getTemporaryDirectory();
    final pathImage = tempDir.path;

    int randomTitle = Math.Random().nextInt(100000);

    Picture.Image img = Picture.decodeImage(_imageFile.readAsBytesSync());
    Picture.Image reSizeImg = Picture.copyResize(img, 720);

    var convertImg = File('$pathImage/image_$randomTitle.png')
      ..writeAsBytesSync(Picture.encodeJpg(reSizeImg, quality: 85));

    _textController.text = path.basename(_imageFile.path);
    setState(() {
      _imageFile = convertImg;
    });
  }

  _showSnackBar(String text,
      {Duration duration = const Duration(seconds: 1, milliseconds: 500)}) {
    return imageKey.currentState.showSnackBar(SnackBar(
      content: Text(text),
      duration: duration,
    ));
  }

  bool _validate() {
    if (_imageFile == null) {
      _showSnackBar('Please select image');
      return false;
    }
    if (_textController.text.isEmpty) {
      _showSnackBar('Please input image name');
      return false;
    }
    return true;
  }

  _uploadImageToServer() async {
    if (!_validate()) {
      return;
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text('Image uploading...'),
                  )
                ],
              ),
            ),
          );
        });

    try {
      var stream =
          http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
      var length = await _imageFile.length();
      var url = Uri.parse('http://sampulbox.com/parsinglogic/insert.php');

      var request = http.MultipartRequest("POST", url);

      var multiPartFile = new http.MultipartFile("image", stream, length,
          filename: path.basename(_imageFile.path));

      request.fields['title'] = _textController.text;
      request.files.add(multiPartFile);

      var response = await request.send();
      print(response.statusCode);
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });

      if (response.statusCode > 2) {
        print('Image uploaded');
      } else {
        print('Upload failed');
      }

      Navigator.pop(context);
      _showSnackBar('Image uploaded successfully');
    } catch (e) {
      Navigator.pop(context);
      _showSnackBar("An uploaded image has error");
      debugPrint('Error $e');
    }
  }
}

class Login extends StatefulWidget {
  LoginState createState() => LoginState();
}

enum CekLogin { notSign, signIn }

class LoginState extends State<Login> {
  CekLogin cekLogin = CekLogin.notSign;
  var _key = new GlobalKey<FormState>();
  String email, password;

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
    } else {}
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
                      labelText: "Sign In",
                      onPressed: checkForm,
                    ),
                    ButtonClick(
                      labelText: "Register",
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => Register()
                        ));
                      },
                    ),
                    ButtonClick(
                      labelText: "Forgot Password",
                      onPressed: () {},
                    )
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

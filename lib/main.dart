import 'package:flutter/material.dart';
import 'package:parsingjson/login.dart';

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

// class MyApp extends StatefulWidget {
//   final VoidCallback signOut;
//   MyApp({this.signOut});
//   MyAppState createState() => MyAppState();
// }

// class MyAppState extends State<MyApp> {
//   TabController controller;

//   _logout() {
//     var dialog = AlertDialog(
//         title: Text("Confirmation"),
//         actions: <Widget>[
//           FlatButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: Text("Cancel"),
//           ),
//           FlatButton(
//             onPressed: () {
//               Navigator.pop(context);
//               setState(() {
//                 widget.signOut();
//               });
//             },
//             child: Text("Yes"),
//           )
//         ],
//         content: SingleChildScrollView(
//           child: ListBody(
//             children: <Widget>[Text("Are you sure you want sign out?")],
//           ),
//         ));
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return dialog;
//         });
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 4,
//       child: Scaffold(
//         bottomNavigationBar: TabBar(
//           controller: controller,
//           unselectedLabelColor: Colors.grey,
//           labelColor: Colors.black,
//           indicatorWeight: 2.0,
//           tabs: <Widget>[
//             Tab(
//               icon: Icon(Icons.fiber_new),
//               text: "Product",
//             ),
//             Tab(
//               icon: Icon(Icons.format_list_bulleted),
//               text: "Category",
//             ),
//             Tab(
//               icon: Icon(Icons.bookmark_border),
//               text: "Bookmark",
//             ),
//             Tab(
//               icon: Icon(Icons.settings),
//               text: "Settings",
//             )
//           ],
//         ),
//         appBar: AppBar(
//           // bottom: TabBar(
//           //   controller: controller,
//           //   tabs: <Widget>[
//           //     Tab(
//           //       icon: Icon(Icons.fiber_new),
//           //       text: "New Product",
//           //     ),
//           //     Tab(
//           //       icon: Icon(Icons.category),
//           //       text: "Category",
//           //     ),
//           //     Tab(
//           //      icon: Icon(Icons.settings),
//           //       text: "Settings",
//           //     )
//           //   ],
//           // ),
//           title: Text('Parsing Json Logic'),
//           actions: <Widget>[
//             IconButton(
//               onPressed: () {
//                 Navigator.of(context).push(MaterialPageRoute(
//                     builder: (BuildContext context) => Profil()));
//               },
//               icon: Icon(Icons.account_circle),
//             ),
//             IconButton(
//               onPressed: _logout,
//               icon: Icon(Icons.lock_open),
//             )
//           ],
//         ),
//         body: TabBarView(
//           controller: controller,
//           children: <Widget>[NewProduct(), CategoryProduct(), Bookmark(), Settings()],
//         ),
//       ),
//     );
//   }
// }
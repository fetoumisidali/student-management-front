

import 'package:flutter/material.dart';
import 'package:stduents_management/pages/class_list_page.dart';

void main() {
  runApp(const MaterialApp(
    title: "Studnets",
    home: MyApp(),
  ));
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}
const appUrl = "http://10.0.2.2:8080";

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClassList(appUrl),
    );
  }
}




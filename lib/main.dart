import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:irefighter/modules/Styler.dart';
import 'package:irefighter/views/LogIn.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Styler styler= Styler();
    return GetMaterialApp(

      title: 'Flutter Demo',
      theme: styler.themeData,
      home: MyHomePage(),
    );
  }
}
class MyHomePage extends StatelessWidget {

   MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {



    return LogIn();
  }

}

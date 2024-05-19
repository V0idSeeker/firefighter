

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:irefighter/modules/DatabaseManeger.dart';
import 'package:irefighter/modules/FireFighter.dart';
import 'package:irefighter/modules/Styler.dart';
import 'package:irefighter/views/AccountSettings.dart';

import '../views/LogIn.dart';
import '../views/cameraView.dart';
import '../views/mapView.dart';

class InterfaceControler extends GetxController {
  late FireFighter firefighter;
  late DatabaseManeger db;
  late Widget mainscreen ;
  Styler styler=Styler();
  int index=0;
  bool isConnected = true;
  InterfaceControler(this.firefighter);


  @override
  onInit() {
    super.onInit();
    mainscreen =CameraView();
    db = DatabaseManeger();
  }

  Future<void> cnx() async {
    bool t = await db.connectionStatus();

    if (isConnected != t) isConnected = t;
    Timer.periodic(Duration(milliseconds: 400), (Timer timer) async {
      t = await db.connectionStatus();
      if (isConnected != t) {
        isConnected = t;
        if (!isConnected) {
          timer.cancel();
          styler.showSnackBar("You have been disconnected", "Connection issue");
          index=0;
          Get.offAll(() => LogIn());
        }
      }
    });
  }
  changeScreen(String to) async{
    if( to=="camera" && mainscreen is  CameraView)return ;
    if( to=="map" && mainscreen is  MapView)return ;
    if(to=="Settings" && mainscreen is AccountSettings)return ;
    if(to=="map") {
      index=0;
      mainscreen = MapView(firefighter);
    }
    if(to=="camera") {
      index=1;
      mainscreen = CameraView();
    }
    if(to=="Settings"){
      index=2;
      Map<String,dynamic> data=firefighter.toMap();
      data["accountType"]="firefighter";
      mainscreen=AccountSettings(data );
    }


    update();
    }

  }






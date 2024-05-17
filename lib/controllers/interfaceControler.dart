

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:irefighter/modules/DatabaseManeger.dart';
import 'package:irefighter/modules/FireFighter.dart';
import 'package:irefighter/views/AccountSettings.dart';

import '../views/LogIn.dart';
import '../views/cameraView.dart';
import '../views/mapView.dart';

class InterfaceControler extends GetxController {
  late FireFighter firefighter;
  late DatabaseManeger db;
  late Widget mainscreen ;
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
        print("change");
        isConnected = t;
        if (!isConnected) {
          timer.cancel();
          Get.snackbar("You have been disconnected", "Connection issue");
          Get.offAll(() => LogIn());
        }
      }
    });
  }
  changeScreen(String to) async{
    if( to=="camera" && mainscreen is  CameraView)return ;
    if( to=="map" && mainscreen is  MapView)return ;
    if(to=="Settings" && mainscreen is AccountSettings)return ;
    if(to=="map") mainscreen=MapView(firefighter);
    if(to=="Settings"){
      Map<String,dynamic> data=firefighter.toMap();
      data["accountType"]="firefighter";
      mainscreen=AccountSettings(data );}
      if(to=="camera") mainscreen=CameraView();

      update();
    }

  }






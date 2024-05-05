

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:irefighter/modules/FireFighter.dart';
import 'package:irefighter/views/AccountSettings.dart';

import '../views/cameraView.dart';
import '../views/mapView.dart';

class InterfaceControler extends GetxController {
  late FireFighter firefighter;
  late Widget mainscreen ;
  InterfaceControler(this.firefighter);


  @override
  onInit() {
    super.onInit();
    mainscreen =CameraView();
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






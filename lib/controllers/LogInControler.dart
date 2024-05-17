import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:irefighter/modules/DatabaseManeger.dart';




class LogInControler extends GetxController{
late DatabaseManeger db;
late String username , password;
bool isConnected=true;
@override
  void onInit() {
  super.onInit();
    username="";
    password="";
    db=new DatabaseManeger();

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

Future<void> cnx() async {
  bool t = await db.connectionStatus();

  if(isConnected!=t)isConnected=t;

}
getIp()=>db.getIp();

bool changeIp(String newIp){
  if(!RegExp(r'\b((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\b').hasMatch(newIp)) return false ;
  db.setIp(newIp);
  return true;
}

  Future<Map<String , dynamic>>logIn()async {
    return await db.logIn(username,password);
  }






}
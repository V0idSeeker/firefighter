import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:irefighter/modules/FireFighter.dart';
import 'package:irefighter/modules/Styler.dart';

import '../controllers/interfaceControler.dart';

class FireFighterInterface extends StatelessWidget {
  FireFighter firefighter;
  FireFighterInterface(this.firefighter, {super.key});
  final styler=Styler();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InterfaceControler>(
      init: InterfaceControler(firefighter),
      builder: (controller) {
        controller.cnx();
        return Scaffold(
            body: controller.mainscreen,
            bottomNavigationBar: styler.bottomNavigationBar(
              currentIndex: controller.index,
              onTap: (index) {
                switch (index) {
                  case 0:
                    {
                      controller.changeScreen("map");

                      break;
                    }

                  case 1:
                    {
                      controller.changeScreen("camera");

                      break;
                    }
                  case 2:
                    {
                      controller.changeScreen("Settings");
                      break;
                    }
                }
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.map), label: "Fire Map"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.camera), label: "Camera"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), label: "Account Settings"),
              ],
            ));
      },
    );
  }
}

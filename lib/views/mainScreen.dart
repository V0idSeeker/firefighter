import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:irefighter/modules/FireFighter.dart';

import '../controllers/interfaceControler.dart';

class FireFighterInterface extends StatelessWidget {
  FireFighter firefighter;
  FireFighterInterface(this.firefighter, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InterfaceControler>(
      init: InterfaceControler(firefighter),
      builder: (controller) {
        return Scaffold(
            body: controller.mainscreen,
            bottomNavigationBar: BottomNavigationBar(
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

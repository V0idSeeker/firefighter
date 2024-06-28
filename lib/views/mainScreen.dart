import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:irefighter/modules/FireFighter.dart';
import 'package:irefighter/modules/Styler.dart';

import '../controllers/interfaceControler.dart';

class FireFighterInterface extends StatelessWidget {
  FireFighter firefighter;
  FireFighterInterface(this.firefighter, {super.key});
  final styler = Styler();

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
                    icon: Container(
                        decoration: BoxDecoration(
                          color: controller.index == 0
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: controller.index == 0
                              ? [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        child: Padding(
                          padding:
                              EdgeInsets.all(controller.index == 0 ? 8.0 : 0.0),
                          child: Icon(Icons.map),
                        )),
                    label: "Fire Map"),
                BottomNavigationBarItem(
                    icon: Container(
                        decoration: BoxDecoration(
                          color: controller.index == 1
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: controller.index == 1
                              ? [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ]
                              : [],
                        ),
                        child: Padding(
                          padding:
                          EdgeInsets.all(controller.index == 1 ? 8.0 : 0.0),
                          child: Icon(Icons.camera),
                        )),
                     label: "Camera"),
                BottomNavigationBarItem(
                    icon: Container(
                        decoration: BoxDecoration(
                          color: controller.index == 2
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: controller.index == 2
                              ? [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ]
                              : [],
                        ),
                        child: Padding(
                          padding:
                          EdgeInsets.all(controller.index == 2 ? 8.0 : 0.0),
                          child: Icon(Icons.settings),
                        )),
                     label: "Account Settings"),
              ],
            ));
      },
    );
  }
}

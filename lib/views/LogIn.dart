import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:irefighter/modules/FireFighter.dart';
import '../controllers/LogInControler.dart';
import 'mainScreen.dart';

class LogIn extends StatelessWidget {
  const LogIn({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LogInControler>(
        init: LogInControler(),
        builder: (controller) {
          final formkey = GlobalKey<FormState>();

          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      "https://images.pexels.com/photos/338936/pexels-photo-338936.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Container(
                  //width: MediaQuery.of(context).size.width /1.5,
                  height: MediaQuery.of(context).size.height / 4,
                  color: Theme.of(context).primaryColorLight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextFormField(
                            textAlign: TextAlign.center,
                            decoration:
                                InputDecoration(labelText: "Username :"),
                            validator: (value) {
                              if (value!.isEmpty)
                                return "Invalid Username";
                              else
                                controller.username = value;
                            },
                          ),
                          TextFormField(
                            textAlign: TextAlign.center,
                            obscureText: true,
                            decoration:
                                InputDecoration(labelText: "Password :"),
                            validator: (value) {
                              if (value!.isEmpty)
                                return "Invalid Password";
                              else
                                controller.password = value;
                            },
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (!formkey.currentState!.validate())
                                return null;
                              Map<String , dynamic> data = await controller.logIn();
                              if (data["Error"]!=null || data["accountStatus"]=="disabled")
                                Get.snackbar("", "",
                                    maxWidth:
                                        MediaQuery.of(context).size.width / 4,
                                    titleText: Text("Error Logging in"),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Colors.blue,
                                    colorText: Colors.white,
                                    messageText: Text(data["Error"]!=null ? data["Error"] : "Account is disabled"   ),

                                    showProgressIndicator: true);
                              else {

                                if(data["accountType"]=="firefighter"){
                                  FireFighter firefighter= FireFighter.fromMap(data);
                                  Get.off(()=>FireFighterInterface(firefighter));

                                }
                                else{
                                  Get.snackbar("", "",
                                      maxWidth:
                                      MediaQuery.of(context).size.width / 4,
                                      titleText: Text("Access Denied"),
                                      duration: Duration(seconds: 2),
                                      backgroundColor: Colors.blue,
                                      colorText: Colors.white,
                                      messageText: Text("Invalid account"),

                                      showProgressIndicator: true);

                                }
                              }
                            },
                            child: Text("Submit"),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

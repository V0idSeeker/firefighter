import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:irefighter/modules/FireFighter.dart';
import '../controllers/LogInControler.dart';
import 'mainScreen.dart';

class LogIn extends StatelessWidget {
   LogIn({super.key});

  @override
  Widget build(BuildContext context) {


    final formkey = GlobalKey<FormState>();
    return GetBuilder<LogInControler>(
      init: LogInControler(),
      builder: (controller) {

        return Scaffold(
          resizeToAvoidBottomInset: false,

       

          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    "https://images.pexels.com/photos/338936/pexels-photo-338936.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Builder(
                builder: (context) {
                  return Container(
                    height: MediaQuery.of(context).size.height/3,
                    width: MediaQuery.of(context).size.width*0.8,
                    color: Theme.of(context).primaryColorLight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:

                           Form(
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
                                    await controller.cnx();

                                    if(!controller.isConnected){

                                      Get.snackbar("Connection Issues", "No Connection To The Server");

                                      return null;
                                    }
                                    Map<String , dynamic> data = await controller.logIn();
                                    if (data["Error"]!=null || data["accountStatus"]=="disabled")
                                      Get.snackbar("", "",
                                          maxWidth:
                                              500/ 4,
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
                                            maxWidth: 500/ 4,
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
                          )
                       ,
                    ),
                  );
                }
              ),
            ),
          ),
          floatingActionButton: ElevatedButton(
            onPressed: () {
              String val=controller.getIp();
              Get.dialog(AlertDialog(
                title: Text("Change Ip address"),
                content: TextFormField(
                  initialValue: val,
                  onChanged: (value){
                    val=value;

                  },
                ),
                actions: [
                  ElevatedButton(onPressed: ()=>Get.back(), child: Text("Cancel")),
                  ElevatedButton(onPressed: (){
                    bool changed=controller.changeIp(val);
                    if(!changed){
                      Get.snackbar("invalid Ip" ,"Ip Not Valid", snackPosition: SnackPosition.BOTTOM);
                    }else{
                      Get.back();
                      Get.snackbar("Ip Changed",'' );


                    }

                  },
                      child: Text("Submit")),
                ],

              ));
            },
            child: Text("Change Ip"),


          ),
        );
      }
    );
  }
}

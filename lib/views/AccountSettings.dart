import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:irefighter/modules/Styler.dart';
import 'package:irefighter/views/LogIn.dart';


import '../controllers/AccountSettingsController.dart';

class AccountSettings extends StatelessWidget {
  Map<String,dynamic> passedParams;
  AccountSettings(this.passedParams, {super.key});
  final styler = Styler();

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<AccountSettingsController>(
      id: "SettingsPage",
      init: AccountSettingsController(passedParams),
      builder: (controller) {
        final formKey = GlobalKey<FormState>();
        return Scaffold(
          body: Container(
            decoration:styler.orangeBlueBackground(),
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width *0.8,
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Styler().lightGreyBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Settings",
                            style: Theme.of(context).textTheme.headlineLarge
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          readOnly: true,
                          initialValue: controller.accountInfo["lastName"],
                          decoration: Styler().inputDecoration("Last Name:"),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          readOnly: true,
                          initialValue: controller.accountInfo["firstName"],
                          decoration: Styler().inputDecoration("First Name:"),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          readOnly: true,
                          initialValue: controller.accountInfo["birthDate"]
                              .toString()
                              .substring(0, 10),
                          decoration: Styler().inputDecoration("Birth Date"),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          readOnly: true,
                          initialValue: controller.accountInfo["city"],
                          decoration: Styler().inputDecoration("City:"),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          initialValue: controller.accountInfo["username"],
                          decoration: Styler().inputDecoration("UserName:"),
                          onChanged: (value) {
                            controller.accountInfo["username"] = value.toString();
                          },
                          validator: (value) {
                            if (value!.isEmpty)
                              return "This field must be filled";
                            if (!RegExp(r'^[A-Za-z0-9 \d]+$').hasMatch(value))
                              return "Invalid characters";
                            if (!controller.validUsername)
                              return "This username is already taken";
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          initialValue: controller.accountInfo["password"],
                          obscureText: true,
                          decoration: Styler().inputDecoration("Password:"),
                          onChanged: (value) {
                            controller.accountInfo["password"] = value.toString();
                          },
                          validator: (value) {
                            if (value!.isEmpty)
                              return "This field must be filled";
                            if (!RegExp(r'^[A-Za-z0-9 \d]+$').hasMatch(value))
                              return "Invalid characters";
                            if (!controller.validPassword)
                              return "This password is already taken";
                          },
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              await controller.checkCity();
                              if (!formKey.currentState!.validate()) return;
                              Get.dialog(FutureBuilder(
                                future: controller.updateSettings(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return styler.returnDialog(
                                        title: "waiting",
                                        content: LinearProgressIndicator(),
                                        actions: []);
                                  }
                                  if (snapshot.hasError) {
                                    return styler.returnDialog(
                                        title: "Error",
                                        content: Text("${snapshot.error}"),
                                        actions: []);
                                  }
                                  if (snapshot.data == false) {
                                    return styler.returnDialog(
                                      title: "There has been an error",
                                      content: Text("Update was Unsuccessful"),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () => Get.back(),
                                          child: Text("Close"),
                                        ),
                                      ],
                                    );
                                  }
                                  return styler.returnDialog(
                                    title: "Account Settings Updated",
                                    content:
                                    Text("You will have to log in again"),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Get.offAll(() => LogIn());
                                        },
                                        child: Text("Close"),
                                      ),
                                    ],
                                  );
                                },
                              ));
                            },
                            style: Styler().elevatedButtonStyle(),
                            child: Text("Update Settings"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

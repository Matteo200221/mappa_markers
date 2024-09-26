import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mappa_indicatore/ui/permissions/position_permission.dart';
import 'package:mappa_indicatore/ui/providers/geolocalization_provider.dart';
import 'package:mappa_indicatore/ui/providers/login_provider.dart';
import 'package:provider/provider.dart';

import '../controller/call_controller.dart';
import '../controller/login_controller.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final formKey = GlobalKey<FormState>();
  final LoginController loginController = Get.put(LoginController());
  final CallController callController = Get.put(CallController());

  @override
  Widget build(BuildContext context) {
    final localizationProvider = Provider.of<GeolocalizationProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
      ),
      backgroundColor: Colors.black54,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Image.network(
                  'https://images-ext-1.discordapp.net/external/a_6q7uwHEXYKFKwYmRv6b5LxVbDeXo9NvWuridGbSYo/https/upload.wikimedia.org/wikipedia/commons/f/ff/Netflix-new-icon.png?format=webp&quality=lossless&width=670&height=670',
                  width: 150,
                ),
                SizedBox(height: 30),
                // Row to hold buttons side by side
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90A4),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      callController.loginToken.value =
                          await callController.login(
                              loginController.username.value,
                              loginController.password.value);
                      if (callController.loginToken.value.isNotEmpty &&
                          loginController.password.value == 'admin' &&
                          loginController.password.value == 'admin') {
                        localizationProvider.geolocalization =
                            await determinePosition();
                        loginProvider.token = callController.loginToken.value;
                        Get.toNamed('/');
                      } else {
                        Get.snackbar(
                          'Errore di Login',
                          'Email o password non validi',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(10),
                        );
                      }
                    }
                  },
                  child: const Text('Login', style: TextStyle(color: Colors.white),),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserire dati completi';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    loginController.username.value = value!;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.white),
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: Colors.white),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserire dati completi';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    loginController.password.value = value!;
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

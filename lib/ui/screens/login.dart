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
        backgroundColor: const Color(0xFF2A3C56),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.white, // Sfondo bianco
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Image.network(
                  'https://media.glassdoor.com/sqll/6356750/digitality-consulting-s-r-l-squarelogo-1647509960651.png',
                  width: 110,
                ),
                const SizedBox(height: 40),
                // Casella di testo per l'username
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: const TextStyle(color: Colors.black),
                    fillColor: const Color(0xFFDFE6EF),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0), // Casella più grande
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30), // Forme ovali
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30), // Forme ovali
                      borderSide: BorderSide(color: Colors.blue.shade300),
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
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
                const SizedBox(height: 20),
                // Casella di testo per la password
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.black),
                    fillColor: const Color(0xFFDFE6EF),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0), // Casella più grande
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30), // Forme ovali
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30), // Forme ovali
                      borderSide: BorderSide(color: Colors.blue.shade300),
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
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
                const SizedBox(height: 30),
                // Pulsante di login più lungo e ovale
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90A4),
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 100.0), // Pulsante più lungo
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Forme ovali
                    ),
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
                          'Username o password non validi',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(10),
                        );
                      }
                    }
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    // Azione per password dimenticata
                  },
                  child: const Text(
                    'Password dimenticata?',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    // Azione per registrati
                  },
                  child: const Text(
                    'Registrati',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

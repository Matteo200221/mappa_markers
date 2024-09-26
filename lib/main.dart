import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:mappa_indicatore/ui/binding/app_binding.dart';
import 'package:mappa_indicatore/ui/providers/geolocalization_provider.dart';
import 'package:mappa_indicatore/ui/providers/login_provider.dart';
import 'package:mappa_indicatore/ui/screens/home_page.dart';
import 'package:mappa_indicatore/ui/screens/login.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GeolocalizationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoginProvider(),
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialBinding: AppBinding(),
        initialRoute: '/',
        routes: {
          '/login': (context) => Login(),
          '/': (context) => HomePage(),
        },
      ),
    );
  }
}

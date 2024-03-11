import 'package:flutter/material.dart';
import 'package:nfc_reader/login.dart';
import 'nfc.dart'; 
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(seconds: 5));
  FlutterNativeSplash.remove();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
  
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home': (context) => LoginScreen(), // Pantalla de inicio de sesión
        '/nfc': (context) => NFCScreen(), // Pantalla NFC
        '/login': (context) => LoginScreen(), // Pantalla Login
      },
    );
  }
}


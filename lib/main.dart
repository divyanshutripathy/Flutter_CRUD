import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hello_flutter/HomePage.dart';
import 'package:hello_flutter/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Firebase CRUD',
        theme: ThemeData(
          primarySwatch: Colors.brown,
        ),
        themeMode: ThemeMode.light,
        // initialRoute: "/login",
        routes: {
          "/": (context) => const LoginPage(),
          "/home": (context) => const HomePage()
        });
  }
}

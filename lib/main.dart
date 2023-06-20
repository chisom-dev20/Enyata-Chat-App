// ignore_for_file: prefer_const_constructors

import 'package:chat/global_variables.dart';
import 'package:chat/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Chisom\'s Chat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: white, 
          centerTitle: false,
          iconTheme: IconThemeData(color: Colors.white), 
          elevation: 0,
          titleTextStyle: ptstyle(size: 15, weight: 500, color: white)
        ),
      ),
      home: SplashScreen(),
    );
  }
}


// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:chat/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'global_variables.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});


  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2),() {
        Navigator.push(context, MaterialPageRoute(
        builder: (context) => const HomePage(),
        ),
      );
    },
  );
  }


  @override
  Widget build(BuildContext context) {

  return Scaffold(
    body: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: const Color.fromRGBO(154, 181, 158, 1),
            child: SvgPicture.asset('assets/svgs/group.svg', color: white, height: 35,),
          ),
          const SizedBox(height: 30),
          Text('Enyata Chat App', style: ptstyle(size: 25.0, color: green, weight: 600),
        ),
      ],
      ),
    ),
   );
 }
}
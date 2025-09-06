
import 'dart:async';

import 'package:demo/repository/loginscreens/Loginscreens.dart';
import 'package:flutter/material.dart';

import '../../domain/constants/appcolors.dart';
import '../widgets/uihelper.dart';

class Splashscreen extends StatefulWidget {

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Loginscreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldbackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          UiHelper.CustomImage(img: "flutter.jpg")
        ],
        ),
      )
    );
  }
}

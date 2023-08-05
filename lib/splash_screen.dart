import 'dart:async';

import 'package:flutter/material.dart';
import 'package:med_care/constants.dart';
import 'package:med_care/pages/home_page.dart';
class SplashScreen extends StatefulWidget{
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds:3), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=> HomePage(),));
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/med_care_full_logo_new.png"),
                  fit: BoxFit.cover
              ),
            color: kPrimaryColor,
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
      ),
    );
  }
}
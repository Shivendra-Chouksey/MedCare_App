import 'dart:async';

import 'package:flutter/material.dart';
//import 'package:flare_flutter/flare_actor.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState(){
    super.initState();
    Timer(const Duration(milliseconds: 1500), () { 
        Navigator.popUntil(context, ModalRoute.withName('/'));
    });
  }
  
  // @override
  // Widget build(BuildContext context) {
  //   return Material(
  //     color: Colors.white,
  //     child: Center(
  //       child: FlareActor(
  //         'assets/animation/Favorite.flr',
  //         alignment: Alignment.center,
  //         fit: BoxFit.contain,
  //         animation : 'Untitled' ,
  //        ),
  //     ),
  //   );
  // }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding:  EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: 200,
              ),
              Center(
                child: Container(
                    height: 300,
                    width: 300,
                    // color: Colors.blue,
                     child: Image.asset('assets/images/splash.png',
                     height: 195,
                     width: 195,
                     ),
                  ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(child: Text(' Added !!',
               style: TextStyle(
                fontSize: 50,
                color: Color.fromARGB(255, 0, 148, 167),
                fontWeight: FontWeight.bold,
               ),
              )),
            ],
          ),
        ),
      ),

    );
  }
}
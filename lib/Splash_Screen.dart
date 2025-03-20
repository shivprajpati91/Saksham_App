import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'HomeScreen.dart';
import 'LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  String fullText = "IndiaHiring";
  int index = 0;

  @override
  void initState() {
    super.initState();

    Timer.periodic(Duration(milliseconds:150), (timer) {
      if (index < fullText.length) {
        setState(() {
          index++;
        });
      } else {
        timer.cancel();
        Future.delayed(Duration(seconds: 4), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Loginpage()),
          );
        } );
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade400,
      body: Center(
        child: Container(
          height: double.infinity,
          width: 440,
          child: Stack(
            children:[
              Positioned(
                  top: 60,
                  left: 0,
                  child: Container(
                      height: 100,
                      width: 400,
                      child: Lottie.asset("anim/line9.json",fit: BoxFit.fill))),
              Positioned(
                  bottom: 0,
                  left: -240,
                  child: Container(
                      height: 100,
                      width: 630,
                      child: Lottie.asset("anim/beach.json",fit: BoxFit.fill))),
              // Positioned(
              //     bottom: 5,
              //     left: 1,
              //     child: Container(
              //         height: 100,
              //         width: 390,
              //         child: Lottie.asset("anim/line2.json",fit: BoxFit.fill))),
              Positioned(
              left: 120,
              bottom: 400,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(index, (i) {
                  return AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: 1.0,
                    child: Transform.translate(
                      offset: Offset(0, i == index - 1 ? 1 : 0), // Sliding effect on last letter
                      child: Text(
                        fullText[i],
                        style: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),),
                    ),);
                }),),
            ),]
          ),),
      ),
    );}
}
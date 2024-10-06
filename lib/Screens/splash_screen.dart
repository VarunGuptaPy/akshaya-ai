import 'package:akshaya_ai/Screens/detail_screen.dart';
import 'package:akshaya_ai/Screens/home_screen.dart';
import 'package:akshaya_ai/Screens/login_screen..dart';
import 'package:akshaya_ai/Screens/no_internet.dart';
import 'package:akshaya_ai/Screens/onboarding_screen.dart';
import 'package:akshaya_ai/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void renderHome() {
    if (sharedPreferences!.getBool("opened") == Null ||
        sharedPreferences!.getBool("opened") == false) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (c) => OnboardingScreen()));
    } else if (FirebaseAuth.instance.currentUser == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (c) => SignInScreen()));
    } else {
      try {
        FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((value) {
          Map<String, dynamic> data = value.data()!;
          print(value.data()!);
          if (data["status"] == "registering") {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (c) => DetailScreen(
                          uid: FirebaseAuth.instance.currentUser!.uid,
                        )));
          } else {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (c) => HomeScreen()));
          }
        });
      } catch (e) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => NoInternet()));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      renderHome();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/logo.png"),
      ),
    );
  }
}

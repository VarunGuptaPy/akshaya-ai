import 'package:akshaya_ai/Screens/splash_screen.dart';
import 'package:akshaya_ai/globals.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/no_internet.png"),
            SizedBox(
              height: 20,
            ),
            Text(
              "No Internet",
              style: GoogleFonts.montserrat(
                  color: primary, fontSize: 30, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: primary),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (c) => SplashScreen()));
                },
                child: Text(
                  "Retry",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor),
                ))
          ],
        ),
      ),
    );
  }
}

import 'package:akshaya_ai/Screens/login_screen..dart';
import 'package:akshaya_ai/globals.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/logo.png"),
            Image.asset("assets/Onboarding_img.png"),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9 > 375
                  ? 375
                  : MediaQuery.of(context).size.width * 0.9,
              child: Text(
                "Akshaya.ai instantly turns photos of textbooks or notes into organized study materials, including flashcards,Notes,QNA, to help students review and learn more efficiently.",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                sharedPreferences!.setBool("opened", true);
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (c) => SignInScreen()));
              },
              child: Text(
                "Start 👍",
                style: TextStyle(color: textColor, fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: secondary),
            )
          ],
        ),
      ),
    );
  }
}

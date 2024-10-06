import 'package:akshaya_ai/globals.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class WaitScreen extends StatefulWidget {
  String prompt;
  Widget rediredctTo;
  WaitScreen({
    super.key,
    required this.prompt,
    required this.rediredctTo,
  });
  @override
  State<WaitScreen> createState() => _WaitScreenState();
}

class _WaitScreenState extends State<WaitScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset("assets/wait_animation.json"),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Text(
                "Akshaya.ai instantly turns photos of textbooks or notes into organized study materials, including flashcards,Notes,QNA, to help students review and learn more efficiently.",
                textAlign: TextAlign.center,
                softWrap: true,
                style: GoogleFonts.montserrat(
                  fontSize: 15,
                  color: headingColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

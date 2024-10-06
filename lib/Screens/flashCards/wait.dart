import 'package:akshaya_ai/Screens/MCQ/show_mcq.dart';
import 'package:akshaya_ai/Screens/Notes/notes_show.dart';
import 'package:akshaya_ai/Screens/Q&A/qanda.dart';
import 'package:akshaya_ai/Screens/Summary/summary_show.dart';
import 'package:akshaya_ai/Screens/flashCards/FlashCard_main.dart';
import 'package:akshaya_ai/backend/chat.dart';
import 'package:akshaya_ai/globals.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class WaitScreenFeature extends StatefulWidget {
  String text;
  String prompt;
  String service;
  WaitScreenFeature(
      {super.key,
      required this.text,
      required this.prompt,
      required this.service});

  @override
  State<WaitScreenFeature> createState() => _WaitScreenFeatureState();
}

class _WaitScreenFeatureState extends State<WaitScreenFeature> {
  List<List<String>>? data;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chat(widget.prompt + widget.text).then((ans) => {
          if (widget.service == "flashcard")
            {
              data = convertPythonArrayStringToDart(ans),
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (c) => FlashcardMain(flashCardArray: data!))),
            }
          else if (widget.service == "notes")
            {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (c) => NotesShow(notes: ans))),
            }
          else if (widget.service == "summary")
            {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (c) => SummaryShow(text: ans))),
            }
          else if (widget.service == "MCQ")
            {
              print(ans.substring(ans.length - 10)),
              // print(ans),
              data = convertPythonArrayStringToDart(ans),
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (c) => ShowMcq(questionArray: data!))),
            }
          else if (widget.service == "Doubt")
            {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (c) => QuestionAndAnswer(
                            text: widget.text,
                          ))),
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset("assets/book_loading.json"),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 300,
            child: Text(
              "Akshaya.ai with the magic of ai is converting your input into flashcard.",
              style: GoogleFonts.montserrat(fontSize: 15),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:akshaya_ai/Screens/MCQ/show_mcq.dart';
import 'package:akshaya_ai/Screens/Notes/notes_show.dart';
import 'package:akshaya_ai/Screens/Q&A/qanda.dart';
import 'package:akshaya_ai/Screens/Summary/summary_show.dart';
import 'package:akshaya_ai/Screens/flashCards/FlashCard_main.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FolderDetail extends StatefulWidget {
  Map<String, dynamic> folderData;
  FolderDetail({super.key, required this.folderData});

  @override
  State<FolderDetail> createState() => _FolderDetailState();
}

class _FolderDetailState extends State<FolderDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Image.asset("assets/top_screen_graphic.png"),
              Column(
                children: [
                  SizedBox(
                    height: 70,
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back)),
                      Text(
                        // widget.folderData["name"],
                        widget.folderData["name"],
                        style: GoogleFonts.montserrat(
                            fontSize: 34, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
          GestureDetector(
            onTap: () {
              if (widget.folderData["flashcard"] != Null ||
                  widget.folderData["flashcard"] != []) {
                int count = 0;
                List<dynamic> mainArray = widget.folderData["flashcard"];
                List<String> tempList = [];
                List<List<String>> flashCard = [];
                for (int i = 0; i < mainArray.length; i++) {
                  count++;
                  tempList.add(mainArray[i].toString());
                  if (count == 2) {
                    flashCard.add(tempList);
                    count = 0;
                    tempList = [];
                  }
                }
                print("flashCard");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) =>
                            FlashcardMain(flashCardArray: flashCard)));
              }
            },
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                color: Color(0xffFFD1D1),
                padding: EdgeInsets.all(30),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage("assets/flashCard.png"),
                      radius: 40,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      "Flashcards",
                      style: GoogleFonts.montserrat(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (widget.folderData["Note"] != null)
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) =>
                            NotesShow(notes: widget.folderData["Note"])));
            },
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                color: Color(0xffE9D1FF),
                padding: EdgeInsets.all(30),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage("assets/Notes.png"),
                      radius: 40,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      "Notes",
                      style: GoogleFonts.montserrat(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (widget.folderData["Summary"] != null)
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) =>
                            SummaryShow(text: widget.folderData["Summary"])));
            },
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                color: Color(0xffDDFFD1),
                padding: EdgeInsets.all(30),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage("assets/Summary.png"),
                      radius: 40,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      "Summary",
                      style: GoogleFonts.montserrat(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (widget.folderData["MCQ"] != Null ||
                  widget.folderData["MCQ"] != []) {
                int count = 0;
                List<dynamic> mainArray = widget.folderData["MCQ"];
                List<String> tempList = [];
                List<List<String>> MCQ = [];
                for (int i = 0; i < mainArray.length; i++) {
                  count++;
                  tempList.add(mainArray[i].toString());
                  if (count == 6) {
                    MCQ.add(tempList);
                    count = 0;
                    tempList = [];
                  }
                }
                print("flashCard");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => ShowMcq(questionArray: MCQ)));
              }
            },
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                color: Color(0xffFFE6CE),
                padding: EdgeInsets.all(30),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage("assets/QandA.png"),
                      radius: 40,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    SizedBox(
                      width: 170,
                      child: AutoSizeText(
                        "Question and Answer",
                        maxLines: 2,
                        softWrap: true,
                        minFontSize: 20,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

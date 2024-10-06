import 'dart:io';

import 'package:akshaya_ai/Screens/flashCards/wait.dart';
import 'package:akshaya_ai/backend/chat.dart';
import 'package:akshaya_ai/globals.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class FeatureScreen extends StatefulWidget {
  const FeatureScreen({super.key});

  @override
  State<FeatureScreen> createState() => _FeatureScreenState();
}

class _FeatureScreenState extends State<FeatureScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/logo.png"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FeatureCard(
                color: Color(0xffFFD1D1),
                title: "Flashcards📄",
                description:
                    "Flashcards are a study tool featuring a question on one side and an answer on the other, designed to enhance memory retention and quick recall.",
                image: "assets/flashCard.png",
                doNext: (text) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c) => WaitScreenFeature(
                                text: text,
                                service: "flashcard",
                                prompt:
                                    "Act as a teacher your student who is studying in grade ${sharedPreferences!.getString("class")} and name is ${sharedPreferences!.getString("name")}, you have to create flashcard using the provided text according to her level. Give the answer as a python 2d array excluding the first list bracket the list should contain the front side first then back side. No need to give type anything else just give me the list and no need add anything for formatting. The content is ",
                              )));
                }),
            FeatureCard(
                image: "assets/Notes.png",
                title: "Notes📋",
                description:
                    "Notes are brief written records of important information or ideas, used to aid memory and understanding.",
                color: Color(0xffE9D1FF),
                doNext: (text) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c) => WaitScreenFeature(
                                text: text,
                                service: "notes",
                                prompt:
                                    "Act as a devoted student of class ${sharedPreferences!.getString("class")} who loves to create well formatted notes. You are given a text. You have to create note out of it and give it as mmarkdown. With perfect formatting and spaces don't add any formatting you do for showing text and also don't add ```markdown in start and ``` in end that you do for showing markdown text. The text is:- ",
                              )));
                }),
            FeatureCard(
                image: "assets/Summary.png",
                title: "Summary📝",
                description:
                    "A summary condenses key information into a brief, clear overview, capturing the essential points for quick understanding.",
                color: Color(0xffDDFFD1),
                doNext: (text) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c) => WaitScreenFeature(
                                text: text,
                                service: "summary",
                                prompt:
                                    "You are a summarizer. Your task is to summarize the given text in the level of class ${sharedPreferences!.getString("class")} student. No need to give type anything else just give me the list and no need to add anything for formatting. The text is:- ",
                              )));
                }),
            FeatureCard(
                image: "assets/QandA.png",
                title: "Question & Answer🤔",
                description:
                    "Q&A formats enhance learning by engaging with key concepts through concise, targeted questions and answers.",
                color: Color(0xffFFE6CE),
                doNext: (text) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c) => WaitScreenFeature(
                                text: text,
                                service: "MCQ",
                                prompt:
                                    "Act as a teacher, your student studying in class ${sharedPreferences!.getString("class")} needs your help. She wanted mcq from the text given. Your job is to create the mcq. Create the MCQ in the form of python 2d array, each item in that array is going to consist of question, 1 option,2 option,3 option, 4 option and the correct options. Don't make it that the answer is always same option make it competitive and also give answer as full answer and not the number. Don't type anything else except the array, not even the text you type for formatting and variable name and equal sign. The text is:- ",
                              )));
                }),
          ],
        ),
      ),
    );
  }
}

class FeatureCard extends StatefulWidget {
  String image;
  String title;
  String description;
  Color color;
  Function(String)? doNext;
  FeatureCard({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.color,
    required this.doNext,
  });

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: widget.color,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(widget.image),
              radius: 35,
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 210,
                  child: Text(
                    widget.title,
                    softWrap: true,
                    style: GoogleFonts.montserrat(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: headingColor),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.54,
                  child: Text(
                    widget.description,
                    softWrap: true,
                    style: GoogleFonts.montserrat(
                      fontSize: 10,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 10, backgroundColor: primary),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text("Upload",
                          style: GoogleFonts.montserrat(
                              fontSize: 21,
                              color: textColor,
                              fontWeight: FontWeight.w600)),
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (c) => AlertDialog(
                                backgroundColor: textColor,
                                title: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(
                                          Icons.arrow_back,
                                          color: headingColor,
                                        )),
                                    Text(
                                      "Document Type",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 20,
                                        color: Color(0xff240045),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        FilePickerResult? result =
                                            await FilePicker.platform.pickFiles(
                                          type: FileType.custom,
                                          allowedExtensions: ['pdf'],
                                        );
                                        try {
                                          if (result != null &&
                                              result.files.single.path !=
                                                  null) {
                                            String filePath =
                                                result.files.single.path!;
                                            File file;
                                            if (filePath == "" &&
                                                filePath.contains('/drive')) {
                                              showSnackBar(context,
                                                  "pdf selected from wrong source or it is not selected");
                                            } else {
                                              file = File(
                                                  result.files.single.path!);
                                              final PdfDocument doc =
                                                  await PdfDocument(
                                                      inputBytes: file
                                                          .readAsBytesSync());
                                              String text =
                                                  PdfTextExtractor(doc)
                                                      .extractText();
                                              doc.dispose();
                                              // print(text);
                                              Navigator.pop(context);
                                              widget.doNext!(text);
                                            }
                                          } else {
                                            showSnackBar(
                                                context, "No PDF selected");
                                          }
                                        } catch (e) {
                                          showSnackBar(context, e.toString());
                                        }
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 50,
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Image.asset(
                                            "assets/pdf_il.png",
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "OR",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (c) => AlertDialog(
                                                  title: Row(
                                                    children: [
                                                      IconButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          icon: Icon(
                                                            Icons.arrow_back,
                                                            color: headingColor,
                                                          )),
                                                      Text(
                                                        "Which Source?",
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          fontSize: 25,
                                                          color:
                                                              Color(0xff240045),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  backgroundColor: textColor,
                                                  actionsAlignment:
                                                      MainAxisAlignment.center,
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () async {
                                                          try {
                                                            String text =
                                                                await pickImageAndConvertText(
                                                                    ImageSource
                                                                        .camera,
                                                                    context);
                                                            if (text.isEmpty) {
                                                              showSnackBar(
                                                                  context,
                                                                  "Image not selected");
                                                              Navigator.pop(
                                                                  context);
                                                            } else {
                                                              Navigator.pop(
                                                                  context);
                                                              widget.doNext!(
                                                                  text);
                                                            }
                                                          } catch (e) {
                                                            showSnackBar(
                                                                context,
                                                                "Image not selected");
                                                            Navigator.pop(
                                                                context);
                                                          }
                                                        },
                                                        child: Text(
                                                          "Camera",
                                                          style: GoogleFonts
                                                              .montserrat(
                                                            fontSize: 20,
                                                            color: primary,
                                                          ),
                                                        )),
                                                    TextButton(
                                                        onPressed: () async {
                                                          try {
                                                            String text =
                                                                await pickImageAndConvertText(
                                                                    ImageSource
                                                                        .gallery,
                                                                    context);
                                                            if (text.isEmpty) {
                                                              showSnackBar(
                                                                  context,
                                                                  "Image not selected");
                                                              Navigator.pop(
                                                                  context);
                                                            } else {
                                                              Navigator.pop(
                                                                  context);
                                                              widget.doNext!(
                                                                  text);
                                                            }
                                                          } catch (e) {
                                                            showSnackBar(
                                                                context,
                                                                "Image not selected");
                                                            Navigator.pop(
                                                                context);
                                                          }
                                                        },
                                                        child: Text(
                                                          "Gallery",
                                                          style: GoogleFonts
                                                              .montserrat(
                                                            fontSize: 20,
                                                            color: primary,
                                                          ),
                                                        )),
                                                  ],
                                                ));
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 50,
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Image.asset(
                                            "assets/Cam_il.png",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ));
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

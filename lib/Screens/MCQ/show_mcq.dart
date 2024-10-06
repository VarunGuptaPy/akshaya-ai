import 'package:akshaya_ai/globals.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ShowMcq extends StatefulWidget {
  List<List<String>> questionArray;
  ShowMcq({super.key, required this.questionArray});

  @override
  State<ShowMcq> createState() => _ShowMcqState();
}

class _ShowMcqState extends State<ShowMcq> {
  int currentIndex = 0;
  int? totalNumber;
  int correct = 0;
  bool selected = false;
  String currentSelected = "";
  TextEditingController folderName = TextEditingController();
  TextEditingController newFolderName = TextEditingController();
  bool newFolder = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalNumber = widget.questionArray.length;
  }

  BorderSide renderBorderSide({String? currentText}) {
    if (!selected || currentSelected != currentText) {
      return BorderSide(width: 1, color: Colors.grey);
    } else if (selected &&
        currentText != widget.questionArray[currentIndex][5]) {
      return BorderSide(width: 5, color: Colors.red);
    } else if (selected &&
        currentText == widget.questionArray[currentIndex][5]) {
      return BorderSide(width: 5, color: Colors.green);
    } else {
      return BorderSide(width: 5, color: Colors.green);
    }
  }

  void showDialogForSave(List<String> currentCard) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .collection("folders")
        .get()
        .then((value) {
      showDialog(
        context: context,
        builder: (c) => AlertDialog(
          content: SizedBox(
            width: double.maxFinite,
            child: SizedBox(
              height: 400,
              child: value.docs.length == 0
                  ? Center(
                      child: Text(
                        "No Folder are there. Create one!!",
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                      ),
                      itemCount: value.docs.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            folderName.text = value.docs[index].id;
                          },
                          child: Column(
                            children: [
                              Image.asset("assets/folderIcon.png"),
                              SizedBox(
                                height: 5,
                              ),
                              Text(value.docs[index].id),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
          actions: [
            TextField(
              controller: folderName,
              enabled: newFolder,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue, // Set the color of the border
                    width: 2.0, // Set the width of the border
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors
                        .grey, // Border color when TextField is not focused
                    width: 2.0, // Width of the border
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color:
                        Colors.blue, // Border color when TextField is focused
                    width: 2.0, // Width of the border
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      for (int i = 0; i < currentCard.length; i++) {
                        print("The most current card is " + currentCard[i]);
                      }
                      bool done = false;
                      for (int i = 0; i < value.docs.length; i++) {
                        if (value.docs[i].id == folderName.text) {
                          List<dynamic> currentList = [];
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(sharedPreferences!.getString("uid"))
                              .collection("folders")
                              .doc(folderName.text)
                              .get()
                              .then((value) => {
                                    currentList = value.data()!["MCQ"],
                                    for (int i = 0; i < currentCard.length; i++)
                                      {currentList.add(currentCard[i])},
                                    FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(
                                            sharedPreferences!.getString("uid"))
                                        .collection("folders")
                                        .doc(folderName.text)
                                        .update({
                                      "MCQ": currentList,
                                    })
                                  });
                          done = true;
                          break;
                        }
                      }
                      if (!done) {
                        FirebaseFirestore.instance
                            .collection("users")
                            .doc(sharedPreferences!.getString("uid"))
                            .collection("folders")
                            .doc(folderName.text)
                            .set({
                          "MCQ": currentCard,
                          "name": folderName.text,
                        });
                        newFolder = false;
                      }
                      Navigator.pop(context);
                    },
                    child: Text("Save")),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      newFolder = true;
                    });
                    Navigator.pop(context);

                    // Reopen the dialog after a short delay
                    Future.delayed(Duration(milliseconds: 100), () {
                      showDialogForSave(currentCard);
                    });
                  },
                  child: Text("New Folder"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            icon: Icon(Icons.arrow_back)),
        title: Text(
          "MCQ",
          style: GoogleFonts.montserrat(fontSize: 30, color: headingColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "${currentIndex + 1}/${totalNumber} Completed",
              style:
                  GoogleFonts.inter(fontSize: 25, fontWeight: FontWeight.w600),
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            //   child: LinearPercentIndicator(
            //     percent: currentIndex + 1 / totalNumber!,
            //     progressColor: secondary,
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.all(30),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: semiBackground,
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Q.${currentIndex + 1}",
                            style: GoogleFonts.inter(
                                fontSize: 30, color: headingColor),
                          ),
                          IconButton(
                              onPressed: () {
                                showDialogForSave(
                                    widget.questionArray[currentIndex]);
                              },
                              icon: Icon(
                                Icons.bookmark_outline,
                                size: 30,
                              ))
                        ],
                      ),
                      Text(
                        widget.questionArray[currentIndex][0],
                        style: GoogleFonts.inter(
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              if (!selected) {
                                selected = true;
                                currentSelected =
                                    widget.questionArray[currentIndex][1];
                                if (currentSelected ==
                                    widget.questionArray[currentIndex][5]) {
                                  correct++;
                                }
                              }
                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                              side: renderBorderSide(
                                  currentText:
                                      widget.questionArray[currentIndex][1]),
                            ),
                            child: AutoSizeText(
                              widget.questionArray[currentIndex][1],
                              style: GoogleFonts.montserrat(fontSize: 25),
                              textAlign: TextAlign.start,
                              maxLines: 2,
                              minFontSize: 12,
                              overflow: TextOverflow.ellipsis,
                            )),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              if (!selected) {
                                selected = true;
                                currentSelected =
                                    widget.questionArray[currentIndex][2];
                                if (currentSelected ==
                                    widget.questionArray[currentIndex][5]) {
                                  correct++;
                                }
                              }
                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                              side: renderBorderSide(
                                  currentText:
                                      widget.questionArray[currentIndex][2]),
                            ),
                            child: AutoSizeText(
                              widget.questionArray[currentIndex][2],
                              style: GoogleFonts.montserrat(fontSize: 25),
                              textAlign: TextAlign.start,
                              maxLines: 2,
                              minFontSize: 12,
                              overflow: TextOverflow.ellipsis,
                            )),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              if (!selected) {
                                selected = true;
                                currentSelected =
                                    widget.questionArray[currentIndex][3];
                                if (currentSelected ==
                                    widget.questionArray[currentIndex][5]) {
                                  correct++;
                                }
                              }
                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                              side: renderBorderSide(
                                  currentText:
                                      widget.questionArray[currentIndex][3]),
                            ),
                            child: AutoSizeText(
                              widget.questionArray[currentIndex][3],
                              style: GoogleFonts.montserrat(fontSize: 25),
                              textAlign: TextAlign.start,
                              maxLines: 2,
                              minFontSize: 12,
                              overflow: TextOverflow.ellipsis,
                            )),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (!selected) {
                                  selected = true;
                                  currentSelected =
                                      widget.questionArray[currentIndex][4];
                                  if (currentSelected ==
                                      widget.questionArray[currentIndex][5]) {
                                    correct++;
                                  }
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              side: renderBorderSide(
                                  currentText:
                                      widget.questionArray[currentIndex][4]),
                            ),
                            child: AutoSizeText(
                              widget.questionArray[currentIndex][4],
                              style: GoogleFonts.montserrat(fontSize: 25),
                              textAlign: TextAlign.start,
                              maxLines: 2,
                              minFontSize: 12,
                              overflow: TextOverflow.ellipsis,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(
              width: 300,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (currentIndex != 0) {
                          setState(() {
                            currentIndex--;
                          });
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor:
                            currentIndex == 0 ? Colors.red[100] : Colors.red,
                        radius: 35,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (currentIndex != widget.questionArray.length - 1) {
                          setState(() {
                            currentIndex++;
                            selected = false;
                            currentSelected = "";
                          });
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor:
                            currentIndex == widget.questionArray.length - 1
                                ? Colors.green[100]
                                : Colors.green,
                        radius: 35,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

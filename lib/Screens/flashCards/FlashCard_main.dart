import 'package:akshaya_ai/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class FlashcardMain extends StatefulWidget {
  List<List<String>> flashCardArray;
  FlashcardMain({super.key, required this.flashCardArray});

  @override
  State<FlashcardMain> createState() => _FlashcardMainState();
}

class _FlashcardMainState extends State<FlashcardMain> {
  int currentIndex = 0;
  int? totalNumber;
  TextEditingController folderName = TextEditingController();
  TextEditingController newFolderName = TextEditingController();
  bool newFolder = false;
  List<String> sample = [
    "vlkfsajf",
    "fdshal;",
    "fja;fdka",
    "fd;alfjk;a",
    "fd;sajf;l",
    "rewaqjkjkfd"
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalNumber = widget.flashCardArray.length;
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
                      bool done = false;
                      for (int i = 0; i < value.docs.length; i++) {
                        if (value.docs[i].id == folderName.text) {
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(sharedPreferences!.getString("uid"))
                              .collection("folders")
                              .doc(folderName.text)
                              .update({
                            "flashcard": FieldValue.arrayUnion(currentCard),
                            "name": folderName.text,
                          });
                          done = true;
                        }
                        break;
                      }
                      if (!done) {
                        FirebaseFirestore.instance
                            .collection("users")
                            .doc(sharedPreferences!.getString("uid"))
                            .collection("folders")
                            .doc(folderName.text)
                            .set({
                          "flashcard": FieldValue.arrayUnion(currentCard),
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
          "Flash Card",
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
            FlipCard(
              front: Padding(
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
                                      widget.flashCardArray[currentIndex]);
                                },
                                icon: Icon(
                                  Icons.bookmark_outline,
                                  size: 30,
                                ))
                          ],
                        ),
                        Text(
                          widget.flashCardArray[currentIndex][0],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                              fontSize: 40,
                              color: headingColor,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              back: Padding(
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
                                      widget.flashCardArray[currentIndex]);
                                },
                                icon: Icon(
                                  Icons.bookmark_outline,
                                  size: 30,
                                ))
                          ],
                        ),
                        Text(
                          widget.flashCardArray[currentIndex][1],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                              fontSize: 18,
                              color: headingColor,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
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
                        if (currentIndex != widget.flashCardArray.length - 1) {
                          setState(() {
                            currentIndex++;
                          });
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor:
                            currentIndex == widget.flashCardArray.length - 1
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

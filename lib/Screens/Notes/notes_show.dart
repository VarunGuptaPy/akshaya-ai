import 'package:akshaya_ai/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';

class NotesShow extends StatefulWidget {
  String notes;
  NotesShow({super.key, required this.notes});

  @override
  State<NotesShow> createState() => _NotesShowState();
}

class _NotesShowState extends State<NotesShow> {
  TextEditingController folderName = TextEditingController();
  TextEditingController newFolderName = TextEditingController();
  bool newFolder = false;
  @override
  void showDialogForSave(String note) async {
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
                              .get()
                              .then((value) => {
                                    if (value.data()!["Note"] != null)
                                      {
                                        FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(sharedPreferences!
                                                .getString("uid"))
                                            .collection("folders")
                                            .doc(folderName.text)
                                            .update({
                                          "Note":
                                              "${value.data()!["Note"]} \n${note}",
                                          "name": folderName.text,
                                        }),
                                      }
                                    else
                                      {
                                        FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(sharedPreferences!
                                                .getString("uid"))
                                            .collection("folders")
                                            .doc(folderName.text)
                                            .update({
                                          "Note": note,
                                          "name": folderName.text,
                                        }),
                                      }
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
                          "Note": note,
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
                      showDialogForSave(note);
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Notes",
              style: GoogleFonts.inter(fontSize: 30, color: headingColor),
            ),
            IconButton(
                onPressed: () {
                  showDialogForSave(widget.notes);
                },
                icon: Icon(
                  Icons.bookmark_outline,
                  size: 30,
                ))
          ],
        ),
      ),
      body: Markdown(
        data: widget.notes.replaceAll("â¹", ""),
        selectable: false,
      ),
    );
  }
}

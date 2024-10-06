import 'package:akshaya_ai/Screens/Folder/folder_detail.dart';
import 'package:akshaya_ai/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FileScreen extends StatefulWidget {
  const FileScreen({super.key});

  @override
  State<FileScreen> createState() => _FileScreenState();
}

class _FileScreenState extends State<FileScreen> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = [];
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .collection("folders")
        .get()
        .then((value) {
      if (value.docs.length > 0) {
        setState(() {
          docs = value.docs;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset("assets/top_screen_graphic.png"),
            docs.length == 0
                ? Center(
                    child: Text(
                      "No Folder are there. Go Study and create one!!",
                      textAlign: TextAlign.center,
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
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => FolderDetail(
                                      folderData: docs[index].data())));
                        },
                        child: Column(
                          children: [
                            Image.asset("assets/folderIcon.png"),
                            SizedBox(
                              height: 5,
                            ),
                            Text(docs[index].id),
                          ],
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

import 'package:akshaya_ai/Screens/login_screen..dart';
import 'package:akshaya_ai/Screens/splash_screen.dart';
import 'package:akshaya_ai/backend/chat.dart';
import 'package:akshaya_ai/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  String currentClass = "10";
  List<String> classes = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentClass = sharedPreferences!.getString("class") ?? "10";
    nameController.text = sharedPreferences!.getString("name")!;
    phoneNumberController.text = sharedPreferences!.getString("phoneNumber")!;
  }

  void showEditDialog() {
    showDialog(
        context: context,
        builder: (c) => AlertDialog(
              title: Text(
                "Edit Details",
                style: GoogleFonts.montserrat(
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    color: headingColor),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.person_outline,
                      size: 35,
                    ),
                    title: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                          hintText: "Name", border: InputBorder.none),
                      style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: headingColor),
                    ),
                  ),
                  Container(
                    height: 2,
                    color: Colors.black,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.person_outline,
                      size: 35,
                    ),
                    title: TextField(
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                          hintText: "Phone Number", border: InputBorder.none),
                      style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: headingColor),
                    ),
                  ),
                  Container(
                    height: 2,
                    color: Colors.black,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.person_outline,
                      size: 35,
                    ),
                    title: DropdownButton<String>(
                      value: currentClass, // Currently selected item
                      hint: Text('Select your  class'), // Placeholder text
                      icon: Icon(Icons.arrow_downward), // Icon on the dropdown
                      iconSize: 24,
                      elevation: 16, // Elevation of the dropdown menu
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18), // Text style of the selected item
                      underline: Container(),
                      onChanged: (String? newValue) {
                        setState(() {
                          currentClass = newValue!; // Update the selected item
                        });
                        Navigator.pop(context);
                        showEditDialog();
                      },
                      items:
                          classes.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                    height: 2,
                    color: Colors.black,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update({
                        "class": currentClass,
                        "name": nameController.text,
                        "phoneNumber": phoneNumberController.text,
                      });
                      sharedPreferences!.setString("name", nameController.text);
                      sharedPreferences!
                          .setString("phoneNumber", phoneNumberController.text);
                      sharedPreferences!.setString("class", currentClass);
                      Navigator.pop(context);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (c) => SplashScreen()));
                    },
                    child: Text(
                      "Submit",
                      style: GoogleFonts.montserrat(
                          fontSize: 20, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(backgroundColor: primary),
                  )
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  Image.asset("assets/top_screen_graphic.png"),
                  Positioned(
                    top: 32,
                    left: 25,
                    child: Text(
                      "Profile",
                      style: GoogleFonts.montserrat(
                        fontSize: 48,
                        color: primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 100,
                    left: 50,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                      radius: 50,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50.0),
              child: Text(
                sharedPreferences!.getString("name")!,
                style: GoogleFonts.montserrat(
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    color: headingColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Your Details",
                    style: GoogleFonts.montserrat(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: headingColor),
                  ),
                  IconButton(
                      onPressed: () {
                        showEditDialog();
                      },
                      icon: Icon(
                        Icons.edit,
                        size: 35,
                      ))
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: Icon(
                Icons.person_outline,
                size: 35,
              ),
              title: Text(
                sharedPreferences!.getString("name")!,
                style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: headingColor),
              ),
            ),
            Container(
              height: 2,
              color: Colors.black,
            ),
            ListTile(
              leading: Icon(
                Icons.person_outline,
                size: 35,
              ),
              title: Text(
                "${sharedPreferences!.getString("DOB")!.replaceAll("-", "/")}",
                style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: headingColor),
              ),
            ),
            Container(
              height: 2,
              color: Colors.black,
            ),
            ListTile(
              leading: Icon(
                Icons.person_outline,
                size: 35,
              ),
              title: Text(
                "${sharedPreferences!.getString("class")!}th",
                style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: headingColor),
              ),
            ),
            Container(
              height: 2,
              color: Colors.black,
            ),
            ListTile(
              leading: Icon(
                Icons.person_outline,
                size: 35,
              ),
              title: Text(
                "+91 ${sharedPreferences!.getString("phoneNumber")!}",
                style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: headingColor),
              ),
            ),
            Container(
              height: 2,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}

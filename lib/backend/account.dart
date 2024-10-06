import 'package:akshaya_ai/Screens/detail_screen.dart';
import 'package:akshaya_ai/Screens/home_screen.dart';
import 'package:akshaya_ai/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void Login(String email, String password) {
  FirebaseAuth.instance
      .signInWithEmailAndPassword(email: email, password: password)
      .then((cred) => {
        
      });
}

void Register(
    String name, String email, String password, BuildContext context) {
  try {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((cred) => {
              FirebaseFirestore.instance
                  .collection("users")
                  .doc(cred.user!.uid)
                  .set({
                "uid": cred.user!.uid,
                "status": "registering", // details are not filled,
                "email": cred.user!.email,
                "name": name,
              }),
              sharedPreferences!.setString("uid", cred.user!.uid),
              sharedPreferences!.setString("name", name),
              sharedPreferences!.setString("email", email),
              
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => DetailScreen(uid: cred.user!.uid)))
            });
  } catch (e) {
    showSnackBar(context, e.toString());
  }
}

void completeDetail(String phoneNumber, String dateOfBirth, String grade,
    String uid, BuildContext context) {
  try {
    FirebaseFirestore.instance.collection("users").doc(uid).update({
      "DOB": dateOfBirth,
      "class": grade,
      "status": "done",
      "phoneNumber": phoneNumber
    });
    sharedPreferences!.setString("phoneNumber", phoneNumber);
    sharedPreferences!.setString("DOB", dateOfBirth);
    sharedPreferences!.setString("class", grade);
    Navigator.push(context, MaterialPageRoute(builder: (c) => HomeScreen()));
  } catch (e) {
    showSnackBar(context, e.toString());
  }
}

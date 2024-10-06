import 'package:akshaya_ai/Screens/detail_screen.dart';
import 'package:akshaya_ai/Screens/home_screen.dart';
import 'package:akshaya_ai/backend/account.dart';
import 'package:akshaya_ai/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isLogin = true;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Positioned(
                top: -20,
                child: Image.asset("assets/login_image.png"),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.25,
                left: MediaQuery.of(context).size.width * 0.05,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    color: semiBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // TabBar Button system
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Stack(
                            children: isLogin
                                ? [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 85.0),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape: const StadiumBorder(),
                                              backgroundColor: textColor),
                                          onPressed: () => {
                                                setState(() {
                                                  isLogin = false;
                                                })
                                              },
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "  Sign Up",
                                              style: GoogleFonts.montserrat(
                                                fontSize: 20,
                                                color: primary,
                                              ),
                                            ),
                                          )),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: const StadiumBorder(),
                                          backgroundColor: primary),
                                      onPressed: () => {
                                        setState(() {
                                          isLogin = true;
                                        })
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Log in",
                                          style: GoogleFonts.montserrat(
                                            fontSize: 20,
                                            color: textColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]
                                : [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: const StadiumBorder(),
                                          backgroundColor: textColor),
                                      onPressed: () => {
                                        setState(() {
                                          isLogin = true;
                                        })
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Log in    ",
                                          style: GoogleFonts.montserrat(
                                            fontSize: 20,
                                            color: primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 95 - .0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: const StadiumBorder(),
                                            backgroundColor: primary),
                                        onPressed: () => {
                                          setState(() {
                                            isLogin = false;
                                          })
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            "Sign Up",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 20,
                                              color: textColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 30),
                            child: Column(
                              children: [
                                !isLogin
                                    ? SignInTile(
                                        text: "Enter Name",
                                        path: "assets/avatar.png",
                                        controller: nameController,
                                      )
                                    : Container(),
                                SizedBox(height: 20),
                                SignInTile(
                                  text: "Enter Email",
                                  path: "assets/Union.png",
                                  controller: emailController,
                                ),
                                SizedBox(height: 20),
                                SignInTile(
                                  text: "Enter Password",
                                  path: "assets/lock.png",
                                  controller: passwordController,
                                  isPassword: true,
                                  isObscure: true,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: primary),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Text("SUBMIT",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 21,
                                            color: textColor,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  onPressed: () {
                                    if (isLogin &&
                                        emailController.text
                                            .trim()
                                            .isNotEmpty &&
                                        passwordController.text
                                            .trim()
                                            .isNotEmpty) {
                                      try {
                                        FirebaseAuth.instance
                                            .signInWithEmailAndPassword(
                                                email: emailController.text,
                                                password:
                                                    passwordController.text)
                                            .then((cred) {
                                          FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(cred.user!.uid)
                                              .get()
                                              .then((value) {
                                            if (value.data()!["status"] ==
                                                "registering") {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetailScreen(
                                                            uid: cred.user!.uid,
                                                          )));
                                            } else {
                                              sharedPreferences!.setString("uid", cred.user!.uid);
                                              sharedPreferences!.setString("name", value.data()!["name"]);
                                              sharedPreferences!.setString("email", value.data()!["email"]);
                                              sharedPreferences!.setString("phoneNumber", value.data()!["phoneNumber"]);
                                              sharedPreferences!.setString("DOB", value.data()!["DOB"]);
                                              sharedPreferences!.setString("class", value.data()!["class"]);
                                              Navigator.pushReplacement(
                                                  context,MaterialPageRoute(builder: (c) => HomeScreen()));
                                            }
                                          });
                                        });
                                      } catch (e) {
                                        showSnackBar(context, e.toString());
                                      }
                                    } else if (!isLogin &&
                                        emailController.text
                                            .trim()
                                            .isNotEmpty &&
                                        passwordController.text
                                            .trim()
                                            .isNotEmpty &&
                                        nameController.text.trim().isNotEmpty) {
                                      // for register

                                      Register(
                                          nameController.text,
                                          emailController.text,
                                          passwordController.text,
                                          context);
                                    } else {
                                      showSnackBar(
                                          context, "Pls fill required detail");
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SignInTile extends StatefulWidget {
  String text;
  String path;
  TextEditingController controller;
  bool isObscure;
  bool isPassword;
  SignInTile({
    super.key,
    required this.text,
    required this.path,
    required this.controller,
    this.isObscure = false,
    this.isPassword = false,
  });

  @override
  State<SignInTile> createState() => _SignInTileState();
}

class _SignInTileState extends State<SignInTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              widget.text,
              style: TextStyle(fontSize: 18, color: primary),
            ),
            SizedBox(
              width: 20,
            ),
            Image.asset(widget.path),
          ],
        ),
        TextField(
          obscureText: widget.isObscure,
          style: TextStyle(
            color: primary,
          ),
          decoration: InputDecoration(
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        widget.isObscure = !widget.isObscure;
                      });
                    },
                    icon: widget.isObscure
                        ? FaIcon(
                            FontAwesomeIcons.eye,
                            color: primary,
                          )
                        : FaIcon(
                            FontAwesomeIcons.eyeSlash,
                            color: primary,
                          ))
                : SizedBox(
                    width: 0,
                  ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: primary,
              ),
            ),
          ),
          controller: widget.controller,
        )
      ],
    );
  }
}

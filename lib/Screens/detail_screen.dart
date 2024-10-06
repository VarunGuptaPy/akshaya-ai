import 'package:akshaya_ai/backend/account.dart';
import 'package:akshaya_ai/globals.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailScreen extends StatefulWidget {
  String uid;
  DetailScreen({super.key, required this.uid});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  DateTime? selectedDate;
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
    "12"
  ];
  String formattedDate = "";
  TextEditingController phoneNumberController = TextEditingController();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(), // Set initial date
      firstDate: DateTime(2000), // Set earliest date that can be selected
      lastDate: DateTime(2101), // Set latest date that can be selected
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        formattedDate =
            "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}";
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset("assets/top_screen_graphic.png"),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8 > 375
                  ? 375
                  : MediaQuery.of(context).size.width * 0.8,
              child: Material(
                elevation: 15,
                borderRadius: BorderRadius.circular(30),
                shadowColor: Colors.grey,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Details",
                          style: GoogleFonts.montserrat(
                              fontSize: 40, fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Enter DOB",
                        textAlign: TextAlign.start,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          color: primary,
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            _selectDate(context);
                          },
                          child: Text(
                            selectedDate == null
                                ? 'No date selected!'
                                : formattedDate,
                            style: TextStyle(color: textColor, fontSize: 15),
                          )),
                      SizedBox(height: 20),
                      Text(
                        "Select Class",
                        textAlign: TextAlign.start,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          color: primary,
                        ),
                      ),
                      DropdownButton<String>(
                        value: currentClass, // Currently selected item
                        hint: Text('Select your class'), // Placeholder text
                        icon:
                            Icon(Icons.arrow_downward), // Icon on the dropdown
                        iconSize: 24,
                        elevation: 16, // Elevation of the dropdown menu
                        style: TextStyle(
                            color: Colors
                                .deepPurple), // Text style of the selected item
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent, // Underline color
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            currentClass =
                                newValue!; // Update the selected item
                          });
                        },
                        items: classes
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Enter Your Phone Number",
                        textAlign: TextAlign.start,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          color: primary,
                        ),
                      ),
                      TextField(
                        style: TextStyle(
                          color: primary,
                        ),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: primary,
                            ),
                          ),
                        ),
                        controller: phoneNumberController,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 10, backgroundColor: primary),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text("SUBMIT",
                                style: GoogleFonts.montserrat(
                                    fontSize: 21,
                                    color: textColor,
                                    fontWeight: FontWeight.w600)),
                          ),
                          onPressed: () {
                            if (formattedDate != "" &&
                                selectedDate != "" &&
                                phoneNumberController.text.trim().length ==
                                    10) {
                              completeDetail(
                                  phoneNumberController.text.trim(),
                                  formattedDate,
                                  currentClass,
                                  widget.uid,
                                  context);
                            } else {
                              showSnackBar(
                                  context, "Please fill all details correctly");
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

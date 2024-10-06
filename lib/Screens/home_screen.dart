import 'package:akshaya_ai/Screens/feature_screen.dart';
import 'package:akshaya_ai/Screens/Folder/file_screen.dart';
import 'package:akshaya_ai/Screens/profile_screen.dart';
import 'package:akshaya_ai/Screens/wait_screen.dart';
import 'package:akshaya_ai/globals.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class CustomFabLocation extends FloatingActionButtonLocation {
  num? percentageOfScreenAsDist;

  CustomFabLocation({
    required this.percentageOfScreenAsDist,
  });
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Custom logic to place the FAB at a specific location
    final double fabWidth = scaffoldGeometry.floatingActionButtonSize.width;
    final double fabHeight = scaffoldGeometry.floatingActionButtonSize.height;
    // Example: Place the FAB 25% from the start (left) of the screen
    final double x =
        scaffoldGeometry.scaffoldSize.width * percentageOfScreenAsDist! -
            fabWidth / 2;
    final double y = scaffoldGeometry.scaffoldSize.height - fabHeight - 15;
    return Offset(x, y);
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  num fabDistance = 0.1;
  int currentScreen = 0;
  List<Widget> ScreenList = [FeatureScreen(), ProfileScreen(), FileScreen()];
  Widget child = Icon(
    Icons.home,
    color: textColor,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        height: 80,
        width: 80,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: secondary,
            onPressed: () {},
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(100.0), // Adjust the value as needed
            ),
            child: child,
          ),
        ),
      ),
      floatingActionButtonLocation:
          CustomFabLocation(percentageOfScreenAsDist: fabDistance),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 80,
        color: Colors.white,
        notchMargin: 10,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(100),
              color: Colors.white,
              child: IconButton(
                icon: Icon(
                  Icons.home,
                  color: secondary,
                ),
                onPressed: () {
                  setState(() {
                    fabDistance = 0.10;
                    currentScreen = 0;
                    child = Icon(
                      Icons.home,
                      color: textColor,
                    );
                  });
                },
              ),
            ),
            Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(100),
              color: Colors.white,
              child: IconButton(
                icon: Icon(
                  Icons.person_2_outlined,
                  color: secondary,
                ),
                onPressed: () {
                  setState(() {
                    fabDistance = 0.50;
                    currentScreen = 1;
                    child = Icon(
                      Icons.person_2_outlined,
                      color: textColor,
                    );
                  });
                },
              ),
            ),
            Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(100),
              color: Colors.white,
              child: IconButton(
                icon: Image.asset(
                  "assets/file_unfocus.png",
                  height: 15,
                ),
                onPressed: () {
                  setState(() {
                    fabDistance = 0.90;
                    currentScreen = 2;
                    child = Image.asset(
                      "assets/file_focus.png",
                      height: 15,
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
      body: ScreenList[currentScreen],
    );
  }
}

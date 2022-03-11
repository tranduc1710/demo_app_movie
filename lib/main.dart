import 'package:demo_app_movie/src/home/home_screen.dart';
import 'package:flutter/material.dart';

import 'base/base.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flower Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xffa70b0b),
        backgroundColor: Colors.white,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xffa70b0b),
        ),
        checkboxTheme: CheckboxThemeData(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Color(0xffa70b0b),
          elevation: 13,
          showUnselectedLabels: false,
          selectedIconTheme: IconThemeData(
            color: Color(0xffa70b0b),
          ),
        ),
      ),
      initialRoute: "/",
      getPages: [
        GetPage(name: "/", page: () => HomeScreen()),
      ],
    );
  }
}

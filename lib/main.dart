import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/login_screen.dart';
import 'package:flutter_application_1/view/view_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/components/nav_bar.dart';
import 'package:flutter_application_1/components/calendar_page.dart';
import 'package:flutter_application_1/components/human_resources.dart';
import 'package:flutter_application_1/components/recruit_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "HR UI",
      theme: ThemeData(
        fontFamily: GoogleFonts.montserrat().fontFamily,
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamus_implementasi/pages/translate_screen.dart'; // Import halaman utama

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primaryColor: Colors.purple,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.green,
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      home: TranslateScreen(), // Halaman awal
    );
  }
}

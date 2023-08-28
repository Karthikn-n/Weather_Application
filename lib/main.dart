import 'package:flutter/material.dart';
import 'package:weather_app/weather_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:  ThemeData.dark(useMaterial3: true).copyWith(
        appBarTheme: const AppBarTheme(color: Color.fromRGBO(50, 78, 82, 0.322))
      ),
      home: const WeatherScreen(),
    );
  }
}

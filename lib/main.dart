import 'package:flutter/material.dart';

import 'screens/all_medicine_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MedGuide Bangla',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const HomePage(),
      routes: {'/all': (context) => const AllMedicineScreen()},
    );
  }
}

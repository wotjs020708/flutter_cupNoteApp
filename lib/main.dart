import 'package:flutter/material.dart';
import 'package:flutter_coffee_note/screens/home_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'coffee note',
      theme: ThemeData(primarySwatch: Colors.brown),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

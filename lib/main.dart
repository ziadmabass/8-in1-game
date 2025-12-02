import 'package:flutter/material.dart';

import 'home_view_body.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Games App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      home: GameSelectionScreen(),
    );
  }
}

class GameSelectionScreen extends StatelessWidget {
  const GameSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Choose a Game')),
      body: HomeViewBody(),
    );
  }
}

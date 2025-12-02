import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class ColorReactionScreen extends StatefulWidget {
  const ColorReactionScreen({super.key});

  @override
  _ColorReactionScreenState createState() => _ColorReactionScreenState();
}

class _ColorReactionScreenState extends State<ColorReactionScreen> {
  final List<Color> baseColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
  ];

  int score = 0;
  String message = 'Find the different shade!';
  int difficultyLevel = 10; // smaller means harder
  int currentButtons = 6; // will change to 9 after score reaches 10

  late Color baseColor;
  late int oddIndex;
  late List<Color> colorOptions;
  bool canTap = false;

  @override
  void initState() {
    super.initState();
    _startNewRound();
  }

  void _startNewRound() {
    setState(() {
      canTap = false;
      message = 'Get ready...';
    });

    Timer(Duration(milliseconds: 800), () {
      _generateColorOptions();
      setState(() {
        canTap = true;
        message = 'Tap the different color!';
      });
    });
  }

  void _generateColorOptions() {
    currentButtons = score >= 10 ? 9 : 6;
    baseColor = baseColors[Random().nextInt(baseColors.length)];
    oddIndex = Random().nextInt(currentButtons);

    final hslBase = HSLColor.fromColor(baseColor);
    final hslOdd = hslBase.withLightness(
      (hslBase.lightness + (difficultyLevel / 100)).clamp(0.0, 1.0),
    );

    colorOptions = List.generate(currentButtons, (i) {
      return i == oddIndex ? hslOdd.toColor() : baseColor;
    });
  }

  void _handleTap(int index) {
    if (!canTap) return;

    setState(() {
      if (index == oddIndex) {
        score++;
        difficultyLevel =
            (difficultyLevel > 2) ? difficultyLevel - 1 : difficultyLevel;
        message = 'Correct!';
      } else {
        score = (score > 0) ? score - 1 : 0;
        difficultyLevel =
            (difficultyLevel < 15) ? difficultyLevel + 1 : difficultyLevel;
        message = 'Wrong one!';
      }
    });

    Future.delayed(Duration(seconds: 1), _startNewRound);
  }

  Widget _buildColorButton(Color color, int index) {
    return GestureDetector(
      onTap: () => _handleTap(index),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Color Reaction Game'),
        centerTitle: true,
        backgroundColor: Colors.grey[100],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message,
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Center(
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: List.generate(currentButtons, (index) {
                    final color =
                        (colorOptions.length == currentButtons)
                            ? colorOptions[index]
                            : Colors.grey[300]!;
                    return _buildColorButton(color, index);
                  }),
                ),
              ),
              SizedBox(height: 40),
              Text(
                'Score: $score',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Difficulty: ${20 - difficultyLevel}'),
            ],
          ),
        ),
      ),
    );
  }
}

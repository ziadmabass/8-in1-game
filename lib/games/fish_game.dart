// ignore_for_file: deprecated_member_use, library_private_types_in_public_api

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FishGame extends StatefulWidget {
  const FishGame({super.key});

  @override
  _FishGameState createState() => _FishGameState();
}

class _FishGameState extends State<FishGame> {
  Offset fishPosition = const Offset(100, 100);
  List<Offset> ballPositions = [];
  List<Offset> newBallPositions = [];
  double fishSize = 60;
  double ballSize = 60;
  int score = 0;
  int lives = 3;
  int remainingTime = 60;
  bool isGameOver = false;

  late Timer _timer;
  late double screenWidth;
  late double screenHeight;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initGame();
      _startTimer();
    });
  }

  void _initGame() {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    setState(() {
      fishPosition = Offset(screenWidth / 2, screenHeight / 2);
      ballPositions = List.generate(
        10,
        (index) => Offset(
          Random().nextDouble() * (screenWidth - ballSize),
          Random().nextDouble() * (screenHeight - ballSize),
        ),
      );
      newBallPositions = List.generate(
        5,
        (index) => Offset(
          Random().nextDouble() * (screenWidth - ballSize),
          Random().nextDouble() * (screenHeight - ballSize),
        ),
      );
      score = 0;
      lives = 3;
      remainingTime = 60;
      isGameOver = false;
    });
  }

  void _restartGame() {
    _timer.cancel();
    _initGame();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isGameOver) {
        if (remainingTime <= 0) {
          _endGame('Time\'s up! Your final score is $score.');
        } else {
          setState(() {
            remainingTime--;
          });
        }
      }
    });
  }

  void _endGame(String message) {
    _timer.cancel();
    setState(() {
      isGameOver = true;
    });

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Game Over'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _restartGame();
                },
                child: const Text('Restart'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/water.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: GestureDetector(
            onPanUpdate:
                isGameOver
                    ? null
                    : (details) {
                      setState(() {
                        fishPosition = Offset(
                          fishPosition.dx + details.delta.dx,
                          fishPosition.dy + details.delta.dy,
                        );

                        // Eat balls
                        ballPositions.removeWhere((ball) {
                          bool isEaten =
                              (fishPosition - ball).distance <
                              (fishSize + ballSize) / 2;
                          if (isEaten) score++;
                          return isEaten;
                        });

                        // Hit bombs
                        newBallPositions.removeWhere((ball) {
                          bool isHit =
                              (fishPosition - ball).distance <
                              (fishSize + ballSize) / 2;
                          if (isHit) {
                            lives--;
                            if (lives <= 0) {
                              _endGame(
                                'You lost all your lives. Final score: $score.',
                              );
                            }
                          }
                          return isHit;
                        });

                        // Check win condition
                        if (ballPositions.isEmpty) {
                          _endGame(
                            'You ate all the balls! Final score: $score.',
                          );
                        }
                      });
                    },
            child: Stack(
              children: [
                // Fish
                Positioned(
                  left: fishPosition.dx,
                  top: fishPosition.dy,
                  child: Container(
                    width: fishSize,
                    height: fishSize,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/fish.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                // Balls
                ...ballPositions.map(
                  (ball) => Positioned(
                    left: ball.dx,
                    top: ball.dy,
                    child: Container(
                      width: ballSize,
                      height: ballSize,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage("assets/images/lolo.png"),
                          fit: BoxFit.fill,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.yellow.withOpacity(0.7),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bombs
                ...newBallPositions.map(
                  (ball) => Positioned(
                    left: ball.dx,
                    top: ball.dy,
                    child: Container(
                      width: ballSize,
                      height: ballSize,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage("assets/images/boom.png"),
                          fit: BoxFit.fill,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.redAccent.withOpacity(0.7),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // HUD
                Positioned(
                  top: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Score: $score',
                          style: GoogleFonts.pressStart2p(
                            textStyle: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          'Lives: $lives',
                          style: GoogleFonts.pressStart2p(
                            textStyle: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          'Time: $remainingTime',
                          style: GoogleFonts.pressStart2p(
                            textStyle: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

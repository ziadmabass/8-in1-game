import 'package:flutter/material.dart';

import 'fish_game_home.dart';
import 'games/color_game.dart';
import 'games/connect_four_game.dart';
import 'games/guess_number.dart';
import 'games/rock_paper_scissor.dart';
import 'games/sudoku_game.dart';
import 'games/word_game.dart';
import 'games/x_o_game.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 0.75,
      children: [
        GameCard(
          image: 'assets/images/guess_number.jpg',
          title: 'Guess the Number',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GuessNumberGame()),
            );
          },
        ),
        GameCard(
          image: 'assets/images/tic_tac_toe.jpg',
          title: 'Tic Tac Toe',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PlayerNamesScreen()),
            );
          },
        ),
        GameCard(
          image: 'assets/images/rock_paper_scissors.jpg',
          title: 'Rock Paper Scissors',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RockPaperScissorsGame()),
            );
          },
        ),
        GameCard(
          image: 'assets/images/color_game.jpg',
          title: 'Color Game',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ColorReactionScreen()),
            );
          },
        ),
        GameCard(
          image: 'assets/images/fish_game.jpg',
          title: 'Fish Game',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FishGameHome()),
            );
          },
        ),
        GameCard(
          image: 'assets/images/word_game.jpg',
          title: 'Word Game',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WordScrambleScreen()),
            );
          },
        ),
        GameCard(
          image: 'assets/images/sudoku.png',
          title: 'Sudoku Game',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SudokuGame()),
            );
          },
        ),
        GameCard(
          image: 'assets/images/Connect_Four.png',
          title: 'Connect 4',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PlayerInputScreen()),
            );
          },
        ),
      ],
    );
  }
}

class GameCard extends StatelessWidget {
  final String image;
  final String title;
  final VoidCallback onTap;

  const GameCard({
    super.key,
    required this.image,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(image, fit: BoxFit.cover),
              Container(
                color: Colors.black.withOpacity(0.4),
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

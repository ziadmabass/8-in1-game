import 'dart:math';

import 'package:flutter/material.dart';

class WordScrambleScreen extends StatefulWidget {
  const WordScrambleScreen({super.key});

  @override
  _WordScrambleScreenState createState() => _WordScrambleScreenState();
}

class _WordScrambleScreenState extends State<WordScrambleScreen> {
  final List<String> _words = [
    'flutter',
    'widget',
    'state',
    'context',
    'dart',
    'future',
    'async',
    'build',
    'layout',
    'screen',
    'column',
    'row',
    'stack',
    'button',
    'image',
    'network',
    'text',
    'listview',
    'scroll',
    'alignment',
    'padding',
    'margin',
    'planet',
    'oxygen',
    'banana',
    'puzzle',
    'journey',
    'future',
    'elephant',
    'diamond',
    'keyboard',
    'weather',
    'holiday',
    'fantasy',
    'science',
    'galaxy',
    'picture',
    'egg',
    'man',
    'cheese',
  ];

  late String _originalWord;
  late List<String> _scrambledLetters;
  late List<String?> _userLetters;
  int _score = 0;
  final List<int> _placedIndexes = [];

  @override
  void initState() {
    super.initState();
    _loadNewWord();
  }

  void _loadNewWord() {
    _originalWord = _words[Random().nextInt(_words.length)];
    _scrambledLetters = _originalWord.split('')..shuffle();
    _userLetters = List.filled(_originalWord.length, null);
    _placedIndexes.clear();
    setState(() {});
  }

  void _checkIfCompleted() {
    if (!_userLetters.contains(null)) {
      final result = _userLetters.join();
      if (result == _originalWord) {
        _score++;
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: Text('Correct!'),
                content: Text('You solved it!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _loadNewWord();
                    },
                    child: Text('Next Word'),
                  ),
                ],
              ),
        );
      } else {
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: Text('Wrong!'),
                content: Text('Try again.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
        );
      }
    }
  }

  void _undoLast() {
    if (_placedIndexes.isNotEmpty) {
      int lastIndex = _placedIndexes.removeLast();
      String? removedLetter = _userLetters[lastIndex];
      if (removedLetter != null) {
        _scrambledLetters.add(removedLetter);
        _userLetters[lastIndex] = null;
        setState(() {});
      }
    }
  }

  Widget _buildLetterTile(String letter, double size, {bool dragging = false}) {
    return Container(
      width: size.clamp(40.0, 70.0),
      height: size.clamp(40.0, 70.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color:
            dragging ? Colors.deepPurple.withOpacity(0.8) : Colors.deepPurple,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(letter, style: TextStyle(fontSize: 24, color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Word Scramble', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Score: $_score',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Drag the letters to form the correct word:',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Drag Targets
            LayoutBuilder(
              builder: (context, constraints) {
                double boxSize =
                    constraints.maxWidth / (_originalWord.length + 1);
                return Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(_originalWord.length, (index) {
                    return DragTarget<String>(
                      onAccept: (receivedLetter) {
                        if (_userLetters[index] == null) {
                          setState(() {
                            _userLetters[index] = receivedLetter;
                            _scrambledLetters.remove(receivedLetter);
                            _placedIndexes.add(index);
                            _checkIfCompleted();
                          });
                        }
                      },
                      builder: (context, candidateData, rejectedData) {
                        return Container(
                          width: boxSize.clamp(40.0, 70.0),
                          height: boxSize.clamp(40.0, 70.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color:
                                _userLetters[index] != null
                                    ? Colors.deepPurple
                                    : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _userLetters[index] ?? '',
                            style: TextStyle(fontSize: 22, color: Colors.white),
                          ),
                        );
                      },
                    );
                  }),
                );
              },
            ),

            SizedBox(height: 20),

            // Draggable letters
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children:
                  _scrambledLetters.map((letter) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        double tileSize = screenW / 8;
                        return Draggable<String>(
                          data: letter,
                          feedback: _buildLetterTile(
                            letter,
                            tileSize,
                            dragging: true,
                          ),
                          childWhenDragging: Opacity(
                            opacity: 0.3,
                            child: _buildLetterTile(letter, tileSize),
                          ),
                          child: _buildLetterTile(letter, tileSize),
                        );
                      },
                    );
                  }).toList(),
            ),

            SizedBox(height: 30),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _undoLast,
                  icon: Icon(Icons.undo),
                  label: Text('Undo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _loadNewWord,
                  icon: Icon(Icons.skip_next),
                  label: Text('Skip'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(XOAPP());
}

class XOAPP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: XOGame(),
    );
  }
}

class XOGame extends StatefulWidget {
  @override
  _XOGameState createState() => _XOGameState();
}

class _XOGameState extends State<XOGame> {
  List<List<String>> board = List.generate(3, (_) => List.filled(3, ''));
  Map<String, Color> playerColors = {'X': Colors.blue, 'O': Colors.red};
  String currentPlayer = 'X';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('X/O'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Current Player: $currentPlayer',
            style: TextStyle(fontSize: 20, color: playerColors[currentPlayer]),
          ),
          SizedBox(height: 20),
          Column(
            children: List.generate(3, (row) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (col) {
                  return GestureDetector(
                    onTap: () {
                      if (board[row][col].isEmpty) {
                        setState(() {
                          board[row][col] = currentPlayer;
                          if (checkForWinner(row, col)) {
                            showWinnerDialog(currentPlayer);
                            resetGame();
                          } else if (isBoardFull()) {
                            showDrawDialog();
                            resetGame();
                          } else {
                            currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
                          }
                        });
                      }
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          board[row][col],
                          style: TextStyle(
                            fontSize: 24,
                            color: playerColors[board[row][col]],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              );
            }),
          ),
        ],
      ),
    );
  }

  bool checkForWinner(int row, int col) {
    if (board[row][0] == currentPlayer &&
        board[row][1] == currentPlayer &&
        board[row][2] == currentPlayer) {
      return true;
    }
    if (board[0][col] == currentPlayer &&
        board[1][col] == currentPlayer &&
        board[2][col] == currentPlayer) {
      return true;
    }
    if ((board[0][0] == currentPlayer &&
            board[1][1] == currentPlayer &&
            board[2][2] == currentPlayer) ||
        (board[0][2] == currentPlayer &&
            board[1][1] == currentPlayer &&
            board[2][0] == currentPlayer)) {
      return true;
    }
    return false;
  }

  bool isBoardFull() {
    for (var row in board) {
      if (row.contains('')) {
        return false;
      }
    }
    return true;
  }

  void showWinnerDialog(String winner) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Winner!'),
          content: Text(
            'Player $winner is the winner!',
            style: TextStyle(color: playerColors[winner]),
          ),
          actions: [
            TextButton(
              onPressed: () {
Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showDrawDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Draw!'),
          content: Text(
            'The game is a draw!',
            style: TextStyle(color: Colors.orange),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    setState(() {
      board = List.generate(3, (_) => List.filled(3, ''));
      currentPlayer = 'X';
    });
  }
}
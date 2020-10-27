import 'package:flutter/material.dart';
import 'package:tictactoe/controllers/game_controller.dart';
import 'package:tictactoe/core/constants.dart';
import 'package:tictactoe/enums/player_type.dart';
import 'package:tictactoe/enums/winner_type.dart';
import 'package:tictactoe/widgets/custom_dialog.dart';
import 'package:share/share.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final _controller = GameController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: Text(GAME_TITLE),
      centerTitle: true,
    );
  }

  _buildBody() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildBoard(),
          _buildScoreboard1(),
          _buildScoreboard2(),
          _buildVerticalSpace(),
          _buildCurrentPlayerTurnText(),
          _buildVerticalSpace(),
          _buildPlayerMode(),
          _buildResetButton(),
          _buildVerticalSpace(),
          _buildShareButton(),
        ],
      ),
    );
  }

  _buildCurrentPlayerTurnText() {
    return Container(
      child: Center(
        child: Text(
          "Turn of player: " + _controller.currentPlayerTurn(),
          style: TextStyle(
            fontSize: 25.0,
          ),
        ),
      ),
    );
  }

  _buildScoreboard1() {
    return Container(
      child: Center(
        child: Text(
          "Score of player X: " + _controller.scoreboard1(),
          style: TextStyle(
            fontSize: 25.0,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }

  _buildScoreboard2() {
    return Container(
      child: Center(
        child: Text(
          "Score of player O: " + _controller.scoreboard2(),
          style: TextStyle(
            fontSize: 25.0,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  _buildVerticalSpace({double height = 10.0}) {
    return SizedBox(height: height);
  }

  _buildShareButton() {
    return RaisedButton(
      padding: const EdgeInsets.all(20),
      child: Text('SHARE'),
      onPressed: _share,
    );
  }

  _buildResetButton() {
    return RaisedButton(
      padding: const EdgeInsets.all(20),
      child: Text(RESET_BUTTON_LABEL),
      onPressed: _onResetGame,
    );
  }

  _buildBoard() {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: BOARD_SIZE,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: _buildTile,
      ),
    );
  }

  Widget _buildTile(context, index) {
    return GestureDetector(
      onTap: () => _onMarkTile(index),
      child: Container(
        color: _controller.tiles[index].color,
        child: Center(
          child: Image.asset(
            _controller.tiles[index].image,
          ),
        ),
      ),
    );
  }

  _onResetGame() {
    setState(() {
      _controller.reset();
    });
  }

  _share() {
    Share.share('Check the app Tic Tac Toe!');
  }

  _onMarkTile(index) {
    if (!_controller.tiles[index].enable) return;

    setState(() {
      _controller.markBoardTileByIndex(index);
    });

    _checkWinner();
  }

  _checkWinner() {
    var winner = _controller.checkWinner();
    if (winner == WinnerType.none) {
      if (!_controller.hasMoves) {
        _showTiedDialog();
      } else if (_controller.isSinglePlayer &&
          _controller.currentPlayer == PlayerType.player2) {
        final index = _controller.automaticMove();
        _onMarkTile(index);
      }
    } else {
      String symbol =
          winner == WinnerType.player1 ? PLAYER1_SYMBOL : PLAYER2_SYMBOL;
      _showWinnerDialog(symbol);
    }
  }

  _showWinnerDialog(String symbol) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialog(
          title: WIN_TITLE.replaceAll('[SYMBOL]', symbol),
          message: DIALOG_MESSAGE,
          onPressed: _onResetGame,
        );
      },
    );
  }

  _showTiedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialog(
          title: TIED_TITLE,
          message: DIALOG_MESSAGE,
          onPressed: _onResetGame,
        );
      },
    );
  }

  _buildPlayerMode() {
    return SwitchListTile(
      title: Text(_controller.isSinglePlayer ? 'Single Player' : 'Two Players'),
      secondary: Icon(_controller.isSinglePlayer ? Icons.person : Icons.group),
      value: _controller.isSinglePlayer,
      onChanged: (value) {
        setState(() {
          _controller.isSinglePlayer = value;
        });
      },
    );
  }
}

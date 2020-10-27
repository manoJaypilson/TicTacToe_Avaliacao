import 'dart:math';
import 'package:tictactoe/core/constants.dart';
import 'package:tictactoe/core/winner_rules.dart';
import 'package:tictactoe/enums/player_type.dart';
import 'package:tictactoe/enums/winner_type.dart';
import 'package:tictactoe/models/board_tile.dart';

class GameController {
  List<BoardTile> tiles = [];
  List<int> movesPlayer1 = [];
  List<int> movesPlayer2 = [];
  PlayerType currentPlayer;
  bool isSinglePlayer;
  var winPlayer1 = 0;
  String textWinPlayer1;
  var winPlayer2 = 0;
  String textWinPlayer2;

  bool get hasMoves =>
      (movesPlayer1.length + movesPlayer2.length) != BOARD_SIZE;

  GameController() {
    _initialize();
  }

  String currentPlayerTurn() {
    if (currentPlayer == PlayerType.player1) {
      return PLAYER1_SYMBOL;
    }
    return PLAYER2_SYMBOL;
  }

  String scoreboard1() {
    textWinPlayer1 = winPlayer1.toString();
    return textWinPlayer1;
  }

  String scoreboard2() {
    textWinPlayer2 = winPlayer2.toString();
    return textWinPlayer2;
  }

  void _initialize() {
    movesPlayer1.clear();
    movesPlayer2.clear();
    currentPlayer = PlayerType.player1;
    isSinglePlayer = false;
    tiles =
        List<BoardTile>.generate(BOARD_SIZE, (index) => BoardTile(index + 1));
  }

  void reset() {
    _initialize();
  }

  void markBoardTileByIndex(index) {
    final tile = tiles[index];
    if (currentPlayer == PlayerType.player1) {
      _markBoardTileWithPlayer1(tile);
    } else {
      _markBoardTileWithPlayer2(tile);
    }

    tile.enable = false;
  }

  void _markBoardTileWithPlayer1(BoardTile tile) {
    tile.symbol = PLAYER1_SYMBOL;
    tile.color = PLAYER1_COLOR;
    tile.image = PATH1;
    movesPlayer1.add(tile.id);
    currentPlayer = PlayerType.player2;
  }

  void _markBoardTileWithPlayer2(BoardTile tile) {
    tile.symbol = PLAYER2_SYMBOL;
    tile.color = PLAYER2_COLOR;
    tile.image = PATH2;
    movesPlayer2.add(tile.id);
    currentPlayer = PlayerType.player1;
  }

  bool _checkPlayerWinner(List<int> moves) {
    return winnerRules.any((rule) =>
        moves.contains(rule[0]) &&
        moves.contains(rule[1]) &&
        moves.contains(rule[2]));
  }

  WinnerType checkWinner() {
    if (_checkPlayerWinner(movesPlayer1)) {
      winPlayer1 += 1;
      return WinnerType.player1;
    }
    if (_checkPlayerWinner(movesPlayer2)) {
      winPlayer2 += 1;
      return WinnerType.player2;
    }
    return WinnerType.none;
  }

  int automaticMove() {
    var list = new List.generate(9, (i) => i + 1);
    list.removeWhere((element) => movesPlayer1.contains(element));
    list.removeWhere((element) => movesPlayer2.contains(element));

    var random = new Random();
    var index = random.nextInt(list.length - 1);
    return tiles.indexWhere((tile) => tile.id == list[index]);
  }
}

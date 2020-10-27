import 'package:flutter/material.dart';

class BoardTile {
  final int id;

  String symbol;
  Color color;
  bool enable;
  String image;

  BoardTile(
    this.id, {
    this.symbol = '',
    this.color = Colors.black26,
    this.enable = true,
    this.image = 'assets/images/background.png',
  });
}

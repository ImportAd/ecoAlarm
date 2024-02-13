import 'package:ecoalarm/game/tiled_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TileInfo extends TiledGame {
  TileInfo({
    required this.center,
    required this.row,
    required this.col,
  });

  final Offset center;
  final int row;
  final int col;
}

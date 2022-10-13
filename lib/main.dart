import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

void main() async {
  final goldrush = GoldRush();

  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setPortrait();

  runApp(
    GameWidget<GoldRush>(game: goldrush),
  );
}

class GoldRush with Game {

  static const int squareSpeed = 250;
  static final squarePaint = BasicPalette.green.paint();
  static const  squareWidth = 100.0;
  static const squareHeight = 100.0;

  late Rect squarePos;

  int squareDirection = 1;
  late double screenWidth, screenHeight, centerX, centerY;

  @override
  Future<void> onLoad() async {
    // TODO: implement render
  }

  @override
  void render(Canvas canvas) {
    // TODO: implement render
  }

  @override
  void update(double dt) {
    // TODO: implement update
  }

}

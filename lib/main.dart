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
    // initialize game and load game resources
    super.onLoad();

    // Get the width and height of out canvas
    screenWidth = MediaQueryData.fromWindow(window).size.width;
    screenHeight = MediaQueryData.fromWindow(window).size.height;

    // Calculate the center of the screen, allowing for the adjustment
    // for the square size
    centerX = (screenWidth / 2) - (squareWidth / 2);
    centerY = (screenHeight / 2) - (squareHeight / 2);

    // Set the initial position of the green square at the center of the screen
    // with a size of 100 width and height
    squarePos = Rect.fromLTWH(centerX, centerY, squareWidth, squareHeight);
  }

  @override
  void render(Canvas canvas) {
    // Function for control what is drawn on the screen

    canvas.drawRect(squarePos, squarePaint); // draw the green screen
  }

  @override
  void update(double dt) {
    // This function to update the game state since the time elapsed since
    // the last update

    // Update the x position of the square bases on the speed and direction
    // and the time elapsed
    squarePos = squarePos.translate(squareSpeed * squareDirection * dt, 0);

    // If the square reaches side of the screen reverse the direction the
    // square is travelling in
    if (squareDirection == 1 && squarePos.right > screenWidth) {
      squareDirection = -1;
    } else if (squareDirection == -1 && squarePos.left < 0) {
      squareDirection = 1;
    }
  }

}

import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class Player extends PositionComponent {
  static const int squareSpeed = 250; // The speed that our square will animate
  static final squarePaint = BasicPalette.green.paint();
  static const  squareWidth = 100.0;
  static const squareHeight = 100.0;

  late Rect squarePos;

  // The direction our square is travelling in, 1 for left to right, -1 for
  // right to left
  int squareDirection = 1;
  late double screenWidth, screenHeight, centerX, centerY;


  @override
  void update(double dt) {
    super.update(dt);

    // Update the x position of the square based on the speed and direction
    // and the time elapsed
    squarePos = squarePos.translate(squareSpeed * squareDirection * dt, 0);

    if (squareDirection == 1 && squarePos.right > screenWidth) {
      squareDirection = -1;
    } else if (squareDirection == -1 && squarePos.left < 0) {
      squareDirection = 1;
    }
  }

  @override
  void render(Canvas canvas) {}
}

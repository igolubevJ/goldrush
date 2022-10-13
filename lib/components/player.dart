import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class Player extends PositionComponent {
  static const int squareSpeed = 250; // The speed that our square will animate

  // The direction our square is travelling in, 1 for left to right, -1 for
  // right to left
  int squareDirection = 1;


  @override
  void update(double dt) {
    super.update(dt);

    // Update the x position of the square based on the speed and direction
    // and the time elapsed
    position.x += squareSpeed * squareDirection * dt;
  }

  @override
  void render(Canvas canvas) {}
}

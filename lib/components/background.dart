import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Background extends PositionComponent {
  static final backgroundPaint = BasicPalette.white.paint();

  late double screenWidth, screenHeight;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    screenWidth = MediaQueryData.fromWindow(window).size.width;
    screenHeight = MediaQueryData.fromWindow(window).size.height;

    position = Vector2(0, 0);
    size = Vector2(screenWidth, screenHeight);
  }
}

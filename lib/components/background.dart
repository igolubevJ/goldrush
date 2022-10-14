import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Background extends PositionComponent {
  static final backgroundPaint = BasicPalette.white.paint();

  late double screenWidth, screenHeight;
}

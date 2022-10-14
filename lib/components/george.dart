import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class George extends SpriteAnimationComponent {
  late double screenWidth, screenHeight, centerX, centerY;
  late double georgeSizeWidth = 48.0;
  late double georgeSizeHeight = 48.0;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    screenWidth = MediaQueryData.fromWindow(window).size.width;
    screenHeight = MediaQueryData.fromWindow(window).size.height;

    centerX = (screenWidth / 2) - (georgeSizeWidth / 2);
    centerY = (screenHeight / 2) - (georgeSizeHeight / 2);

    var spriteImages = await Flame.images.load('george.png');

    final spriteSheet = SpriteSheet(
      image: spriteImages,
      srcSize: Vector2(georgeSizeWidth, georgeSizeHeight),
    );

    // sprite = spriteSheet.getSprite(0, 0);

    position = Vector2(centerX, centerY);
    size = Vector2(georgeSizeWidth, georgeSizeHeight);
  }
}

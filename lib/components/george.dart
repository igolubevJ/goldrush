import 'dart:math';
import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

extension CreateAnimationByColumn on SpriteSheet {
  SpriteAnimation createAnimationByColumn({
    required int column,
    required double stepTime,
    bool loop = true,
    int from = 0,
    int? to,
  }) {
    to ??= columns;

    final spriteList = List<int>.generate(to - from, (i) => from + i)
        .map((e) => getSprite(e, column))
        .toList();

    return SpriteAnimation.spriteList(
      spriteList,
      stepTime: stepTime,
      loop: loop,
    );
  }
}

class George extends SpriteAnimationComponent with HasHitboxes, Collidable {
  static const int down = 0, left = 1, up = 2, right = 3;

  late double screenWidth, screenHeight, centerX, centerY;
  late double georgeSizeWidth = 48.0;
  late double georgeSizeHeight = 48.0;

  late SpriteAnimation georgeDownAnimation,
      georgeLeftAnimation,
      georgeRightAnimation,
      georgeUpAnimation;

  double elapsedTime = 0.0;
  double georgeSpeed = 40.0;
  int currentDirection = down;

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

    position = Vector2(centerX, centerY);
    size = Vector2(georgeSizeWidth, georgeSizeHeight);

    georgeDownAnimation =
        spriteSheet.createAnimationByColumn(column: 0, stepTime: 0.2);

    georgeLeftAnimation =
        spriteSheet.createAnimationByColumn(column: 1, stepTime: 0.2);

    georgeUpAnimation =
        spriteSheet.createAnimationByColumn(column: 2, stepTime: 0.2);

    georgeRightAnimation =
        spriteSheet.createAnimationByColumn(column: 3, stepTime: 0.2);

    changeDirection();
    addHitbox(HitboxRectangle());
  }

  void changeDirection() {
    Random random = Random();
    int newDirection = random.nextInt(4);

    switch (newDirection) {
      case down:
        animation = georgeDownAnimation;
        break;
      case left:
        animation = georgeLeftAnimation;
        break;
      case up:
        animation = georgeUpAnimation;
        break;
      case right:
        animation = georgeRightAnimation;
        break;
    }

    currentDirection = newDirection;
  }

  @override
  void onCollision(Set<Vector2> points, Collidable other) {
    if (other is ScreenCollidable) {
      switch(currentDirection) {
        case down:
          currentDirection = up;
          animation = georgeUpAnimation;
          break;
        case left:
          currentDirection = right;
          animation = georgeRightAnimation;
          break;
        case up:
          currentDirection = down;
          animation = georgeUpAnimation;
          break;
        case right:
          currentDirection = left;
          animation = georgeLeftAnimation;
          break;
      }

      elapsedTime = 0.0;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    elapsedTime += dt;
    if (elapsedTime > 3.0) {
      changeDirection();
      elapsedTime = 0;
    }

    switch (currentDirection) {
      case down:
        position.y += georgeSpeed * dt;
        break;
      case left:
        position.x -= georgeSpeed * dt;
        break;
      case up:
        position.y -= georgeSpeed * dt;
        break;
      case right:
        position.x += georgeSpeed * dt;
        break;
    }
  }
}

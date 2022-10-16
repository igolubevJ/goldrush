import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';
import 'package:goldrush/utils/math_utils.dart';

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

class Character extends SpriteAnimationComponent with HasHitboxes, Collidable {
  static const int down = 0, left = 1, up = 2, right = 3;

  Character(
      {required Vector2 position, required Vector2 size, required this.speed}) {
    this.position = position;
    this.size = size;
  }

  late Vector2 originalPosition;

  late SpriteAnimation downAnimation,
      leftAnimation,
      rightAnimation,
      upAnimation;

  late double speed;
  double elapsedTime = 0.0;
  int currentDirection = down;

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);

    Rect gameScreenBounds = getGameScreenBounds(canvasSize);
    position = Vector2(
      originalPosition.x + gameScreenBounds.left,
      originalPosition.y + gameScreenBounds.top,
    );
  }
}

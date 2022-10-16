import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:goldrush/utils/math_utils.dart';

class Water extends PositionComponent with HasHitboxes, Collidable {
  Water({
    required Vector2 position,
    required Vector2 size,
    required this.id,
  }) : super(position: position, size: size) {
    originalPosition = position;
  }

  late Vector2 originalPosition;

  int id;

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);

    Rect gameScreenBounds = getGameScreenBounds(canvasSize);
    position = Vector2(
      originalPosition.x + gameScreenBounds.left,
      originalPosition.y + gameScreenBounds.top,
    );
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    collidableType = CollidableType.passive;
    addHitbox(HitboxRectangle());
  }
}

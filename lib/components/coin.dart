import 'package:flame/components.dart';

class Coin extends SpriteAnimationComponent with HasHitboxes, Collidable {
  Coin({
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);
}

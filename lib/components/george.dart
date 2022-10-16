import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:goldrush/components/character.dart';
import 'package:goldrush/components/coin.dart';
import 'package:goldrush/components/hud/hud.dart';
import 'package:goldrush/components/skeleton.dart';
import 'package:goldrush/components/water.dart';
import 'package:goldrush/components/zombie.dart';
import 'package:goldrush/utils/math_utils.dart';

class George extends Character with KeyboardHandler {
  George({
    required this.hud,
    required Vector2 position,
    required Vector2 size,
    required double speed,
  }) : super(position: position, size: size, speed: speed) {
    originalPosition = position;
  }

  final HudComponent hud;
  late double walkingSpeed, runningSpeed;

  late Vector2 targetLocation;
  bool movingToTouchedLocation = false;

  int collisionDirection = Character.down;
  bool hasCollided = false;

  bool keyLeftPressed = false,
      keyRightPressed = false,
      keyUpPressed = false,
      keyDownPressed = false,
      keyRunningPressed = false;

  void moveToLocation(TapUpInfo info) {
    targetLocation = info.eventPosition.game;
    movingToTouchedLocation = true;
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event.data.keyLabel.toLowerCase().contains('a')) {
      keyLeftPressed = (event is RawKeyDownEvent);
    }

    if (event.data.keyLabel.toLowerCase().contains('d')) {
      keyRightPressed = (event is RawKeyDownEvent);
    }

    if (event.data.keyLabel.toLowerCase().contains('w')) {
      keyUpPressed = (event is RawKeyDownEvent);
    }

    if (event.data.keyLabel.toLowerCase().contains('s')) {
      keyDownPressed = (event is RawKeyDownEvent);
    }

    if (event.data.keyLabel.toLowerCase().contains('r')) {
      keyRunningPressed = (event is RawKeyDownEvent);
    }

    return true;
  }

  @override
  void onCollision(Set<Vector2> points, Collidable other) {
    super.onCollision(points, other);

    if (other is Zombie || other is Skeleton) {
      other.removeFromParent();
      hud.scoreText.setScore(10);
    }

    if (other is Coin) {
      other.removeFromParent();
      hud.scoreText.setScore(20);
    }

    if (other is Water) {
      if (!hasCollided) {
        if (movingToTouchedLocation) {
          movingToTouchedLocation = false;
        } else {
          hasCollided = true;
          collisionDirection = currentDirection;
        }
      }
    }
  }

  @override
  void onCollisionEnd(Collidable other) {
    hasCollided = false;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    walkingSpeed = speed;
    runningSpeed = speed * 2;

    var spriteImages = await Flame.images.load('george.png');

    final spriteSheet = SpriteSheet(
      image: spriteImages,
      srcSize: Vector2(width, height),
    );

    downAnimation =
        spriteSheet.createAnimationByColumn(column: 0, stepTime: 0.2);

    leftAnimation =
        spriteSheet.createAnimationByColumn(column: 1, stepTime: 0.2);

    upAnimation = spriteSheet.createAnimationByColumn(column: 2, stepTime: 0.2);

    rightAnimation =
        spriteSheet.createAnimationByColumn(column: 3, stepTime: 0.2);

    animation = downAnimation;
    playing = false;

    anchor = Anchor.center;

    addHitbox(HitboxRectangle(relation: Vector2(0.7, 0.7))
      ..relativeOffset = Vector2(0.0, 0.1));
  }

  void stopAnimations() {
    animation?.currentIndex = 0;
    playing = false;

    keyLeftPressed = false;
    keyUpPressed = false;
    keyRightPressed = false;
    keyDownPressed = false;
  }

  @override
  void update(double dt) {
    super.update(dt);

    speed = (hud.runButton.buttonPressed || keyRunningPressed)
        ? runningSpeed
        : walkingSpeed;

    final bool isMovingByKeys =
        keyLeftPressed || keyRightPressed || keyUpPressed || keyDownPressed;

    if (!hud.joystick.delta.isZero()) {
      // position.add(hud.joystick.relativeDelta * speed * dt);
      movePlayer(dt);
      playing = true;

      switch (hud.joystick.direction) {
        case JoystickDirection.up:
        case JoystickDirection.upRight:
        case JoystickDirection.upLeft:
          animation = upAnimation;
          currentDirection = Character.up;
          break;
        case JoystickDirection.down:
        case JoystickDirection.downRight:
        case JoystickDirection.downLeft:
          animation = downAnimation;
          currentDirection = Character.down;
          break;
        case JoystickDirection.left:
          animation = leftAnimation;
          currentDirection = Character.left;
          break;
        case JoystickDirection.right:
          animation = rightAnimation;
          currentDirection = Character.right;
          break;
        case JoystickDirection.idle:
          animation = null;
          break;
      }
    } else if (isMovingByKeys) {
      movePlayer(dt);
      playing = true;
      movingToTouchedLocation = false;

      if (keyUpPressed && (keyRightPressed || keyLeftPressed)) {
        animation = upAnimation;
        currentDirection = Character.up;
      } else if (keyDownPressed && (keyLeftPressed || keyDownPressed)) {
        animation = downAnimation;
        currentDirection = Character.down;
      } else if (keyLeftPressed) {
        animation = leftAnimation;
        currentDirection = Character.left;
      } else if (keyRightPressed) {
        animation = rightAnimation;
        currentDirection = Character.right;
      } else if (keyUpPressed) {
        animation = upAnimation;
        currentDirection = Character.up;
      } else if (keyDownPressed) {
        animation = downAnimation;
        currentDirection = Character.down;
      } else {
        animation = null;
      }
    } else {
      if (movingToTouchedLocation) {
        // position += (targetLocation - position).normalized() * (speed * dt);
        movePlayer(dt);

        double threshold = 1.0;

        var difference = targetLocation - position;
        if (difference.x.abs() < threshold && difference.y.abs() < threshold) {
          stopAnimations();
          movingToTouchedLocation = false;
          return;
        }

        playing = true;

        var angle = getAngel(position, targetLocation);
        if ((angle > 315 && angle < 360) || (angle > 0 && angle < 45)) {
          // Moving right
          animation = rightAnimation;
          currentDirection = Character.right;
        } else if (angle > 45 && angle < 135) {
          // Moving down
          animation = downAnimation;
          currentDirection = Character.down;
        } else if (angle > 135 && angle < 225) {
          // Moving left
          animation = leftAnimation;
          currentDirection = Character.left;
        } else if (angle > 255 && angle < 315) {
          // Moving up
          animation = upAnimation;
          currentDirection = Character.up;
        }
      } else {
        if (playing) {
          stopAnimations();
        }
      }
    }
  }

  void movePlayer(double delta) {
    if (!(hasCollided && collisionDirection == currentDirection)) {
      if (movingToTouchedLocation) {
        position.add(
          (targetLocation - position).normalized() * (speed * delta),
        );
      } else {
        switch (currentDirection) {
          case Character.left:
            position.add(Vector2(delta * -speed, 0));
            break;
          case Character.right:
            position.add(Vector2(delta * -speed, 0));
            break;
          case Character.up:
            position.add(Vector2(0, delta * -speed));
            break;
          case Character.down:
            position.add(Vector2(0, delta * speed));
            break;
        }
      }
    }
  }
}

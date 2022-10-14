import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:goldrush/components/background.dart';
import 'package:goldrush/components/coin.dart';
import 'package:goldrush/components/george.dart';
import 'package:goldrush/components/hud/hud.dart';
import 'package:goldrush/components/skeleton.dart';
import 'package:goldrush/components/water.dart';
import 'package:goldrush/components/zombie.dart';

void main() async {
  // Create an instance of the game
  final goldRush = GoldRush();

  // Setup Flutter widgets and start the game in full screen portrait orientation
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setPortrait();

  // Run the app, passing the games widget here
  runApp(GameWidget(game: goldRush));
}

class GoldRush extends FlameGame
    with HasCollidables, HasDraggables, HasTappables {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    // debugMode = true;

    HudComponent hud = HudComponent();
    George george = George(
      hud: hud,
      position: Vector2(200, 400),
      size: Vector2(48.0, 48.0),
      speed: 40.0,
    );

    add(Background(george));
    final tiledMap = await TiledComponent.load('tiles.tmx', Vector2.all(32));

    add(tiledMap);
    add(george);

    final enemies = tiledMap.tileMap.getObjectGroupFromLayer('Enemies');

    enemies.objects.asMap().forEach((index, position) {
      if (index % 2 == 0) {
        add(
          Skeleton(
            position: Vector2(position.x, position.y),
            size: Vector2(32.0, 64.0),
            speed: 60.0,
          ),
        );
      } else {
        add(
          Zombie(
            position: Vector2(position.x, position.y),
            size: Vector2(32.0, 64.0),
            speed: 20.0,
          ),
        );
      }
    });

    Random random = Random(DateTime.now().millisecondsSinceEpoch);
    for (int i = 0; i < 50; i++) {
      int randomX = random.nextInt(48) + 1;
      int randomY = random.nextInt(48) + 1;

      double posCoinX = (randomX * 32) + 5;
      double posCoinY = (randomY * 32) + 5;

      add(Coin(
        position: Vector2(posCoinX, posCoinY),
        size: Vector2(20, 20),
      ));
    }

    final water = tiledMap.tileMap.getObjectGroupFromLayer('Water');
    water.objects.forEach((rect) {
      add(Water(
        position: Vector2(rect.x, rect.y),
        size: Vector2(rect.width, rect.height),
        id: rect.id,
      ));
    });

    add(hud);

    camera.speed = 1;
    camera.followComponent(
      george,
      worldBounds: const Rect.fromLTWH(0, 0, 1600, 1600),
    );
  }
}

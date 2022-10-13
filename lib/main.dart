import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:goldrush/components/player.dart';

void main() async {
  final goldrush = GoldRush();

  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setPortrait();

  runApp(
    GameWidget<GoldRush>(game: goldrush),
  );
}

class GoldRush extends FlameGame {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    add(Player());
  }
}

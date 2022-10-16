import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/cupertino.dart';

class ScoreText extends HudMarginComponent {
  ScoreText({Vector2? position}) : super(position: position);

  int score = 0;
  String scoreText = "Score: ";

  late TextPaint _reqularPaint;
  late TextComponent scoreTextComponent;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    TextStyle textStyle = TextStyle(
      color: BasicPalette.blue.color,
      fontSize: 30.0,
    );
    _reqularPaint = TextPaint(style: textStyle);

    scoreTextComponent = TextComponent(
      text: scoreText + score.toString(),
      textRenderer: _reqularPaint,
    );
    add(TextComponent());
  }

  setScore(int score) {
    this.score += score;
    scoreTextComponent.text = scoreText + this.score.toString();
  }
}

import 'package:flame/input.dart';
import 'package:flame/components.dart';
import 'package:goldrush/components/george.dart';

class Background extends PositionComponent with Tappable {
  Background(this.george);

  final George george;

  @override
  bool onTapUp(TapUpInfo info) {
    george.moveToLocation(info);
    return true;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    position = Vector2(0, 0);
    size = Vector2(1600, 1600);
  }
}

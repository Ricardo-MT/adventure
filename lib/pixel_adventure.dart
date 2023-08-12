import 'dart:async';
import 'dart:ui';

import 'package:adventure/levels/level.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class PixelAdventure extends FlameGame {
  late final CameraComponent cam;
  final world = Level();

  @override
  Color backgroundColor() => const Color(0xFF211F30);

  @override
  FutureOr<void> onLoad() {
    cam = CameraComponent.withFixedResolution(
        width: 640, height: 360, world: world);
    cam.viewfinder.anchor = Anchor.topLeft;
    addAll([cam, world]);
    return super.onLoad();
  }
}

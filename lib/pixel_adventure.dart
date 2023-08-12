import 'dart:async';
import 'dart:ui';

import 'package:adventure/levels/level.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class PixelAdventure extends FlameGame {
  late final CameraComponent cam;
  late final Level world;

  @override
  Color backgroundColor() => const Color(0xFF211F30);

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    world = Level(levelName: 'Level-1');
    cam = CameraComponent.withFixedResolution(
        width: 640, height: 360, world: world);
    cam.viewfinder.anchor = Anchor.topLeft;
    addAll([cam, world]);

    return super.onLoad();
  }
}

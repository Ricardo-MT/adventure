import 'dart:async';

import 'package:adventure/actors/player.dart';
import 'package:adventure/controller/joystick.dart';
import 'package:adventure/levels/level.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class PixelAdventure extends FlameGame with HasKeyboardHandlerComponents {
  late final CameraComponent cam;
  late final Level world;
  late JoystickComponent joystick;
  late bool showJoystick;
  late Player player;

  @override
  Color backgroundColor() => const Color(0xFF211F30);

  @override
  FutureOr<void> onLoad() async {
    showJoystick = false;
    await images.loadAllImages();
    player = Player();
    world = Level(levelName: 'Level-1', player: player);
    cam = CameraComponent.withFixedResolution(
        width: 640, height: 360, world: world);
    cam.viewfinder.anchor = Anchor.topLeft;
    addAll([cam, world]);
    if (showJoystick) {
      _addJoystick();
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoystick) {
      _updateJoystick();
    }
    super.update(dt);
  }

  void _addJoystick() {
    joystick = JoystickComponent(
        margin: const EdgeInsets.only(bottom: 32, left: 32),
        knob: SpriteComponent(sprite: Sprite(images.fromCache("HUD/Knob.png"))),
        background: SpriteComponent(
            sprite: Sprite(images.fromCache("HUD/Joystick.png"))));
    add(joystick);
  }

  void _updateJoystick() {
    final joystickVector = joystick.direction;
    player.horizontalMovement = joystickVector.x;
    // player.verticalMovement = joystickVector.y;
  }
}

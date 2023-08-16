import 'dart:async';

import 'package:adventure/actors/player.dart';
import 'package:adventure/controller/joystick.dart';
import 'package:adventure/levels/level.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  CameraComponent? cam;
  Level? level;
  Player? player;
  late final List<String> worlds;
  late int levelIndex;
  late JoystickComponent joystick;
  late bool showJoystick;

  @override
  Color backgroundColor() => const Color(0xFF211F30);

  @override
  FutureOr<void> onLoad() async {
    showJoystick = false;
    levelIndex = -1;
    await images.loadAllImages();
    worlds = [
      'Level-1',
      'Level-2',
    ];
    if (showJoystick) {
      _addJoystick();
    }
    nextLevel();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoystick) {
      _updateJoystick();
    }
    super.update(dt);
  }

  void nextLevel() async {
    levelIndex++;
    if (levelIndex == worlds.length) return;
    if (player != null) {
      player?.removeFromParent();
    }
    if (level != null) {
      level?.removeFromParent();
    }
    if (cam != null) {
      cam?.removeFromParent();
    }
    await Future.delayed(const Duration(milliseconds: 1000));
    player = Player();
    level = Level(levelName: worlds[levelIndex], player: player!);
    cam = CameraComponent.withFixedResolution(
        width: 640, height: 360, world: level);

    cam!.viewfinder.anchor = Anchor.topLeft;
    addAll([cam!, level!]);
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
    final joystickVector = joystick.direction.vector;
    player?.horizontalMovement = joystickVector.x;
    // player.verticalMovement = joystickVector.y;
  }
}

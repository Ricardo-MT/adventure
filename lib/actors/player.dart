import 'dart:async';

import 'package:adventure/actors/player_utils.dart';
import 'package:adventure/pixel_adventure.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, KeyboardHandler {
  Player({
    this.character = PlayerCharacter.maskDude,
    this.direction = PlayerDirection.none,
    this.moveSpeed = 100,
    Vector2? velocity,
    position,
  }) : super(position: position) {
    this.velocity = velocity ?? Vector2.zero();
  }

  final PlayerCharacter character;

  late PlayerDirection direction;
  late double moveSpeed;
  late Vector2 velocity;

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpAnimation;
  late final SpriteAnimation doubleJumpAnimation;
  late final SpriteAnimation wallJumpAnimation;
  late final SpriteAnimation fallAnimation;
  late final SpriteAnimation hitAnimation;
  final double stepTime = 0.05;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD);

    if (isLeftKeyPressed == isRightKeyPressed) {
      direction = PlayerDirection.none;
    } else {
      direction =
          isLeftKeyPressed ? PlayerDirection.left : PlayerDirection.right;
    }
    return super.onKeyEvent(event, keysPressed);
  }

  void _updatePlayerMovement(double dt) {
    var dx = 0.0;
    var dy = 0.0;
    dx += moveSpeed * direction.delta;
    if (dx == 0) {
      current = PlayerStates.idle;
    } else {
      current = PlayerStates.running;
      if (dx > 0 == isFlippedHorizontally) {
        flipHorizontallyAroundCenter();
      }
    }
    velocity = Vector2(dx, dy);
    position += velocity * dt;
  }

  void _loadAllAnimations() {
    idleAnimation = _initiateAnimations(state: 'Idle', amount: 11);
    runningAnimation = _initiateAnimations(state: 'Run', amount: 12);
    jumpAnimation = _initiateAnimations(state: 'Jump', amount: 1);
    doubleJumpAnimation = _initiateAnimations(state: 'Double Jump', amount: 6);
    wallJumpAnimation = _initiateAnimations(state: 'Wall Jump', amount: 5);
    fallAnimation = _initiateAnimations(state: "Fall", amount: 1);
    hitAnimation = _initiateAnimations(state: 'Hit', amount: 7);

    animations = {
      PlayerStates.idle: idleAnimation,
      PlayerStates.running: runningAnimation,
      PlayerStates.jump: jumpAnimation,
      PlayerStates.doubleJump: doubleJumpAnimation,
      PlayerStates.wallJump: wallJumpAnimation,
      PlayerStates.fall: fallAnimation,
      PlayerStates.hit: hitAnimation,
    };
    current = PlayerStates.idle;
  }

  SpriteAnimation _initiateAnimations(
          {required String state, required int amount}) =>
      SpriteAnimation.fromFrameData(
          game.images.fromCache(
              "Main Characters/${character.name}/$state (32x32).png"),
          SpriteAnimationData.sequenced(
            amount: amount,
            stepTime: stepTime,
            textureSize: Vector2.all(32),
          ));
}

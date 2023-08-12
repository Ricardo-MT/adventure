import 'dart:async';

import 'package:adventure/pixel_adventure.dart';
import 'package:flame/components.dart';

enum PlayerCharacter { maskDude, ninjaFrog, pinkMan }

extension PlayerCharacterX on PlayerCharacter {
  String get name {
    switch (this) {
      case PlayerCharacter.maskDude:
        return "Mask Dude";
      case PlayerCharacter.ninjaFrog:
        return "Ninja Frog";
      case PlayerCharacter.pinkMan:
        return "Pink Man";
    }
  }
}

enum PlayerStates { idle, running, jump, doubleJump, wallJump, fall, hit }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure> {
  Player({position, required this.character}) : super(position: position);

  final PlayerCharacter character;

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

import 'dart:async';

import 'package:adventure/actors/player.dart';
import 'package:adventure/actors/player_hitbox.dart';
import 'package:adventure/pixel_adventure.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

const double stepTime = 0.05;

enum CheckpointState { idle, raising, waving }

extension CheckpointStateAssetName on CheckpointState {
  String get assetName {
    switch (this) {
      case CheckpointState.idle:
        return "Idle";
      case CheckpointState.raising:
        return "Raising";
      case CheckpointState.waving:
        return "Waving";
    }
  }
}

class Checkpoint extends SpriteAnimationGroupComponent<CheckpointState>
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  Checkpoint({
    super.position,
    super.size,
    super.anchor = Anchor.topLeft,
  }) {
    hitbox = CustomHitbox(x: 20, y: 18, width: 7, height: 46);
  }
  late final CustomHitbox hitbox;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation raisingAnimation;
  late final SpriteAnimation waivingAnimation;

  void collideWithPlayer(Player player) {
    if (current == CheckpointState.waving) return;
    current = CheckpointState.raising;
    player.setHasWon();
  }

  @override
  FutureOr<void> onLoad() {
    debugMode = false;
    _loadAllAnimations();
    add(RectangleHitbox(
      position: Vector2(hitbox.x, hitbox.y),
      size: Vector2(hitbox.width, hitbox.height),
      collisionType: CollisionType.passive,
    ));
    return super.onLoad();
  }

  void _loadAllAnimations() {
    idleAnimation =
        _initiateAnimations(state: CheckpointState.idle.assetName, amount: 1);
    raisingAnimation = _initiateAnimations(
        state: CheckpointState.raising.assetName, amount: 26)
      ..loop = false;
    waivingAnimation = _initiateAnimations(
        state: CheckpointState.waving.assetName, amount: 10);
    animations = {
      CheckpointState.idle: idleAnimation,
      CheckpointState.raising: raisingAnimation,
      CheckpointState.waving: waivingAnimation,
    };
    current = CheckpointState.idle;
    animationTickers?[CheckpointState.raising]?.onComplete = () {
      current = CheckpointState.waving;
    };
  }

  SpriteAnimation _initiateAnimations(
          {required String state, required int amount}) =>
      SpriteAnimation.fromFrameData(
          game.images.fromCache(
              "Items/Checkpoints/Checkpoint/Checkpoint (Flag $state) (64x64).png"),
          SpriteAnimationData.sequenced(
            amount: amount,
            stepTime: stepTime,
            textureSize: Vector2.all(64),
          ));
}

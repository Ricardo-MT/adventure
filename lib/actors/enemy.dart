import 'dart:async';

import 'package:adventure/actors/player_hitbox.dart';
import 'package:adventure/pixel_adventure.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

enum TrapState { on, off }

const trapAsset = "Saw";

class Trap extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  Trap({
    required super.position,
    super.size,
    this.offNeg = 0,
    this.offPos = 0,
    this.isHorizontal = true,
  }) {
    stepTime = 0.04;
    hitbox = CustomHitbox(x: 0, y: 0, width: 38, height: 38);
    movement = 50;
    direction = 1;
    if (isHorizontal) {
      rangeNeg = position.x - 16 * offNeg;
      rangePos = position.x + 16 * offPos;
    } else {
      rangeNeg = position.y - 16 * offNeg;
      rangePos = position.y + 16 * offPos;
    }
  }
  late final SpriteAnimation onAnimation;
  late final SpriteAnimation offAnimation;
  late final double stepTime;
  late double movement;
  late double direction;
  late double rangeNeg;
  late double rangePos;
  double offPos;
  double offNeg;
  late bool isHorizontal;

  late final CustomHitbox hitbox;

  @override
  FutureOr<void> onLoad() {
    priority = -1;
    debugMode = false;
    _loadAllAnimations();
    add(CircleHitbox(
      position: Vector2(hitbox.x, hitbox.y),
      radius: width / 2,
      collisionType: CollisionType.passive,
    ));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (isHorizontal) {
      position.x += movement * direction * dt;
      if (position.x >= rangePos || position.x <= rangeNeg) {
        direction *= -1;
      }
    } else {
      position.y += movement * direction * dt;
      if (position.y >= rangePos || position.y <= rangeNeg) {
        direction *= -1;
      }
    }
    super.update(dt);
  }

  void _loadAllAnimations() {
    onAnimation = _initiateAnimations(state: 'On (38x38)', amount: 8);
    offAnimation = _initiateAnimations(state: 'Off', amount: 1)..loop = false;
    animations = {
      TrapState.on: onAnimation,
      TrapState.off: offAnimation,
    };
    current = TrapState.on;
    animationTickers?.forEach((key, value) {
      value.onComplete = removeFromParent;
    });
  }

  SpriteAnimation _initiateAnimations(
          {required String state, required int amount}) =>
      SpriteAnimation.fromFrameData(
          game.images.fromCache("Traps/$trapAsset/$state.png"),
          SpriteAnimationData.sequenced(
            amount: amount,
            stepTime: stepTime,
            textureSize: Vector2.all(38),
          ));
}

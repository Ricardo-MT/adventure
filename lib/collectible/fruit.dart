import 'dart:async';
import 'dart:math';

import 'package:adventure/actors/player.dart';
import 'package:adventure/actors/player_hitbox.dart';
import 'package:adventure/pixel_adventure.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

final _random = Random();
const minU = 0.04;
const maxU = 0.06;

enum CollectibleFruitState { idle, collected }

class CollectibleFruit extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, CollisionCallbacks {
  CollectibleFruit({
    super.position,
    super.size,
    required this.fruitAsset,
    super.anchor = Anchor.topLeft,
    double? updateRate,
  }) {
    stepTime = updateRate ?? (minU + _random.nextDouble() * (maxU - minU));
    hitbox = FruitHitbox(x: 10, y: 10, width: 14, height: 12);
  }
  String fruitAsset;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation collectedAnimation;
  late SpriteAnimationTicker ticker;
  late final double stepTime;

  late final FruitHitbox hitbox;

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

  void collideWithPlayer(Player player) {
    current = CollectibleFruitState.collected;
  }

  void _loadAllAnimations() {
    idleAnimation = _initiateAnimations(state: fruitAsset, amount: 17);
    collectedAnimation = _initiateAnimations(state: 'Collected', amount: 6)
      ..loop = false;
    animations = {
      CollectibleFruitState.idle: idleAnimation,
      CollectibleFruitState.collected: collectedAnimation,
    };
    current = CollectibleFruitState.idle;
    animationTickers?.forEach((key, value) {
      value.onComplete = removeFromParent;
    });
  }

  SpriteAnimation _initiateAnimations(
          {required String state, required int amount}) =>
      SpriteAnimation.fromFrameData(
          game.images.fromCache("Items/Fruits/$state.png"),
          SpriteAnimationData.sequenced(
            amount: amount,
            stepTime: stepTime,
            textureSize: Vector2.all(32),
          ));
}

import 'dart:async';

import 'package:adventure/actors/enemy.dart';
import 'package:adventure/actors/player_hitbox.dart';
import 'package:adventure/actors/player_utils.dart';
import 'package:adventure/collectible/fruit.dart';
import 'package:adventure/components/collision_block.dart';
import 'package:adventure/controller/keyboard.dart';
import 'package:adventure/pixel_adventure.dart';
import 'package:adventure/utils/collision/check_collition.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

class Player extends SpriteAnimationGroupComponent<PlayerStates>
    with HasGameRef<PixelAdventure>, KeyboardHandler, CollisionCallbacks {
  Player({
    this.character = PlayerCharacter.maskDude,
    this.moveSpeed = 100,
    Vector2? respawnPosition,
    Vector2? position,
    Vector2? velocity,
    List<CollisionBlock>? collisionBlocks,
  }) : super(
          position: position,
          anchor: Anchor.topLeft,
        ) {
    this.velocity = velocity ?? Vector2.zero();
    this.respawnPosition = respawnPosition ?? Vector2.zero();
    this.collisionBlocks = collisionBlocks ?? [];
    hasJumpPressed = false;
    hasJumped = false;
    isOnGround = false;
    hitbox = PlayerHitbox(x: 10, y: 4, width: 14, height: 28);
  }

  final PlayerCharacter character;

  late double horizontalMovement;
  late double moveSpeed;
  late Vector2 respawnPosition;
  late Vector2 velocity;
  final double _gravity = 9.8;
  final double _jumpForce = 235;
  final double _terminalVelocity = 350;
  late List<CollisionBlock> collisionBlocks;
  late bool hasJumpPressed;
  late bool hasJumped;
  late bool isOnGround;
  late PlayerHitbox hitbox;

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpAnimation;
  late final SpriteAnimation doubleJumpAnimation;
  late final SpriteAnimation wallJumpAnimation;
  late final SpriteAnimation fallAnimation;
  late final SpriteAnimation hitAnimation;
  late final SpriteAnimation appearAnimation;
  late final SpriteAnimation dissapearAnimation;
  final double stepTime = 0.05;

  @override
  FutureOr<void> onLoad() {
    debugMode = false;
    horizontalMovement = 0;
    _loadAllAnimations();
    add(RectangleHitbox(
        position: Vector2(hitbox.x, hitbox.y),
        size: Vector2(hitbox.width, hitbox.height)));
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is CollectibleFruit) {
      other.collideWithPlayer(this);
    }
    if (other is Trap) {
      collideWithTrap();
    }
    super.onCollision(intersectionPoints, other);
  }

  void collideWithTrap() {
    if (current?.isFrozen ?? true) return;
    current = PlayerStates.hit;
    velocity.x = 0;
    horizontalMovement = 0;
  }

  Future<void> _recoverFromHit() async {
    current = PlayerStates.dissapearing;
    position -= (Vector2.all(32) + Vector2(-(scale.x * 16) + 16, 0));
    scale.x = 1;
    _resetAnimation(PlayerStates.hit);
  }

  void _onDesappearCallback() async {
    current = PlayerStates.appearing;
    position = respawnPosition - Vector2.all(32);
    _resetAnimation(PlayerStates.dissapearing);
  }

  void _onAppearCallback() async {
    current = PlayerStates.idle;
    position = respawnPosition;
    _resetAnimation(PlayerStates.appearing);
  }

  void _resetAnimation(PlayerStates key) {
    animationTickers?[key]?.reset();
  }

  @override
  void update(double dt) {
    _updatePlayerState(dt);
    _updatePlayerMovement(dt);
    _checkHorizontalCollisions();
    _applyGravity(dt);
    _checkVerticalCollisions();
    super.update(dt);
  }

  void _updatePlayerMovement(double dt) {
    if (current?.isFrozen ?? true) return;
    if (hasJumpPressed && !hasJumped && isOnGround) {
      _playerJump(dt);
    }
    var dx = moveSpeed * horizontalMovement;
    velocity.x = dx;
    position.x += velocity.x * dt;
  }

  void _playerJump(double dt) {
    velocity.y = -_jumpForce;
    y += velocity.y * dt;
    hasJumped = true;
  }

  void _checkHorizontalCollisions() {
    if (current?.isFrozen ?? true) return;
    for (var block in collisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            x = block.x - hitbox.width - hitbox.x;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            x = block.x + block.width + hitbox.width + hitbox.x;
          }
          return;
        }
      }
    }
  }

  void _applyGravity(double dt) {
    if (current?.isFrozen ?? true) return;
    var newVelocityY =
        (velocity.y + _gravity).clamp(-_jumpForce, _terminalVelocity);
    velocity.y = newVelocityY;
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollisions() {
    for (var block in collisionBlocks) {
      if (block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            y = block.y - hitbox.height - hitbox.y;
            isOnGround = true;
          }
          return;
        }
      } else {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            y = block.y - hitbox.height - hitbox.y;
            isOnGround = true;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            y = block.y + block.height - hitbox.y;
          }
          return;
        }
      }
    }
    isOnGround = false;
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (current?.isFrozen ?? true) return true;
    var direction = getDirectionFromKeyboardInput(keysPressed);
    horizontalMovement = direction.x;
    hasJumpPressed = keysPressed.contains(LogicalKeyboardKey.space);
    if (event is RawKeyUpEvent && !hasJumpPressed) {
      hasJumped = false;
    }
    return super.onKeyEvent(event, keysPressed);
  }

  void _updatePlayerState(double dt) {
    if (current?.isFrozen ?? true) return;
    if (velocity.x != 0 && velocity.x > 0 == isFlippedHorizontally) {
      flipHorizontallyAroundCenter();
    }
    if (velocity.isZero()) {
      current = PlayerStates.idle;
      return;
    }
    if (velocity.y > 0) {
      current = PlayerStates.fall;
      return;
    }
    if (velocity.y < 0) {
      current = PlayerStates.jump;
      return;
    }
    current = PlayerStates.running;
  }

  void _loadAllAnimations() {
    idleAnimation = _initiateAnimations(state: 'Idle', amount: 11);
    runningAnimation = _initiateAnimations(state: 'Run', amount: 12);
    jumpAnimation = _initiateAnimations(state: 'Jump', amount: 1);
    doubleJumpAnimation = _initiateAnimations(state: 'Double Jump', amount: 6);
    wallJumpAnimation = _initiateAnimations(state: 'Wall Jump', amount: 5);
    fallAnimation = _initiateAnimations(state: "Fall", amount: 1);
    hitAnimation = _initiateAnimations(state: 'Hit', amount: 7)..loop = false;
    appearAnimation = _initiateSpecialAnimations(
      state: "Appearing",
    );
    dissapearAnimation = _initiateSpecialAnimations(
      state: "Desappearing",
    );

    animations = {
      PlayerStates.idle: idleAnimation,
      PlayerStates.running: runningAnimation,
      PlayerStates.jump: jumpAnimation,
      PlayerStates.doubleJump: doubleJumpAnimation,
      PlayerStates.wallJump: wallJumpAnimation,
      PlayerStates.fall: fallAnimation,
      PlayerStates.hit: hitAnimation,
      PlayerStates.appearing: appearAnimation,
      PlayerStates.dissapearing: dissapearAnimation,
    };
    current = PlayerStates.idle;
    animationTickers?.forEach((key, value) {
      if (key == PlayerStates.hit) {
        value.onComplete = _recoverFromHit;
      }
      if (key == PlayerStates.appearing) {
        value.onComplete = _onAppearCallback;
      }
      if (key == PlayerStates.dissapearing) {
        value.onComplete = _onDesappearCallback;
      }
    });
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
  SpriteAnimation _initiateSpecialAnimations({
    required String state,
  }) =>
      SpriteAnimation.fromFrameData(
          game.images.fromCache("Main Characters/$state (96x96).png"),
          SpriteAnimationData.sequenced(
            amount: 7,
            stepTime: stepTime,
            textureSize: Vector2.all(96),
            loop: false,
          ));
}

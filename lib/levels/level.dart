import 'dart:async';

import 'package:adventure/actors/enemy.dart';
import 'package:adventure/actors/player.dart';
import 'package:adventure/background/background_tile.dart';
import 'package:adventure/collectible/checkpoint.dart';
import 'package:adventure/collectible/fruit.dart';
import 'package:adventure/components/collision_block.dart';
import 'package:adventure/pixel_adventure.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World with HasGameRef<PixelAdventure> {
  Level({
    required this.levelName,
    required this.player,
  }) {
    collisionBlocks = [];
    collectibleObjects = [];
  }
  late String levelName;
  late TiledComponent level;
  late Player player;
  late List<CollisionBlock> collisionBlocks;
  late List<CollectibleFruit> collectibleObjects;

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));
    add(level);
    _initiateBackgroundScrolling(level);
    _addSpawninPoints(level);
    _addCollisionObjects(level);
    _addCollectibleObjects(level);
    _addTraps(level);
    _addCheckpoints(level);
    return super.onLoad();
  }

  void _initiateBackgroundScrolling(TiledComponent<FlameGame> world) {
    final backLayer = world.tileMap.getLayer<TileLayer>('Background');
    if (backLayer != null) {
      var color = backLayer.properties.getValue("BackgroundColor");
      const tileSize = 64.0;
      final tileCountX = (game.size.x / tileSize).floor();
      final tileCountY = (game.size.y / tileSize).floor();
      var tiles = <BackgroundTile>[];
      for (var x = 0; x <= tileCountX; x++) {
        for (var y = -1; y <= tileCountY; y++) {
          tiles.add(BackgroundTile(
            backgroundColorAsset: color,
            position: Vector2(x * tileSize, y * tileSize),
            size: Vector2.all(64.4),
          ));
        }
      }
      addAll(tiles);
    }
  }

  void _addSpawninPoints(TiledComponent<FlameGame> world) {
    final spawPoints = world.tileMap.getLayer<ObjectGroup>('Spawnpoints');
    if (spawPoints != null) {
      for (var point in (spawPoints.objects)) {
        switch (point.class_) {
          case 'Player':
            player.position = Vector2(point.x, point.y);
            player.respawnPosition = Vector2(point.x, point.y);
            add(player);
            break;
          default:
        }
      }
    }
  }

  void _addCollisionObjects(TiledComponent<FlameGame> world) {
    final collisionPoints = world.tileMap.getLayer<ObjectGroup>('Collisions');
    collisionBlocks = [];
    if (collisionPoints != null) {
      for (var point in (collisionPoints.objects)) {
        final platform = CollisionBlock(
          isPlatform: point.class_ == "Platform",
          position: Vector2(point.x, point.y),
          size: Vector2(point.width, point.height),
        );
        collisionBlocks.add(platform);
        add(platform);
      }
    }
    player.collisionBlocks = collisionBlocks;
  }

  void _addCollectibleObjects(TiledComponent<FlameGame> world) {
    final collectiblePoints =
        world.tileMap.getLayer<ObjectGroup>('Collectibles');
    if (collectiblePoints != null) {
      for (var point in (collectiblePoints.objects)) {
        switch (point.class_) {
          case "Fruit":
            final fruit = CollectibleFruit(
              position: Vector2(point.x, point.y),
              fruitAsset: point.name,
            );
            collectibleObjects.add(fruit);
            add(fruit);
            break;
          default:
        }
      }
    }
  }

  void _addTraps(TiledComponent<FlameGame> world) {
    final trapPoints = world.tileMap.getLayer<ObjectGroup>('Enemies');
    if (trapPoints != null) {
      for (var point in (trapPoints.objects)) {
        if (point.class_ == "Saw") {
          final offNeg =
              point.properties.getProperty<Property<double>>("offNeg")?.value;
          final offPos =
              point.properties.getProperty<Property<double>>("offPos")?.value;
          final isHorizontal =
              point.properties.getProperty<Property<bool>>("horizontal")?.value;
          final trap = Trap(
            position: Vector2(point.x, point.y),
            size: Vector2(point.width, point.height),
            offNeg: offNeg ?? 0,
            offPos: offPos ?? 0,
            isHorizontal: isHorizontal ?? false,
          );
          add(trap);
        }
      }
    }
  }

  void _addCheckpoints(TiledComponent<FlameGame> world) {
    final checkpoints = world.tileMap.getLayer<ObjectGroup>('Checkpoints');
    if (checkpoints != null) {
      for (var point in (checkpoints.objects)) {
        final checkpoint = Checkpoint(
          position: Vector2(point.x, point.y),
          size: Vector2(point.width, point.height),
        );
        add(checkpoint);
      }
    }
  }
}

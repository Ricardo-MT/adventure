import 'dart:async';

import 'package:adventure/actors/player.dart';
import 'package:adventure/background/background_tile.dart';
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
  }
  late String levelName;
  late TiledComponent level;
  late Player player;
  late List<CollisionBlock> collisionBlocks;

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));
    add(level);
    _initiateBackgroundScrolling(level);
    _addSpawninPoints(level);
    _addCollisionObjects(level);
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
}

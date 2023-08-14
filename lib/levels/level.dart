import 'dart:async';

import 'package:adventure/actors/player.dart';
import 'package:adventure/components/collision_block.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World {
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
    final spawPoints = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');
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
    final collisionPoints = level.tileMap.getLayer<ObjectGroup>('Collisions');
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
    return super.onLoad();
  }
}

import 'dart:async';

import 'package:adventure/actors/player.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World {
  Level({
    required this.levelName,
    required this.player,
  });
  late String levelName;
  late TiledComponent level;
  late Player player;
  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));
    add(level);
    final spawPoints = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');
    for (var point in (spawPoints!.objects)) {
      switch (point.class_) {
        case 'Player':
          player.position = Vector2(point.x, point.y);
          add(player);
          break;
        default:
      }
    }
    return super.onLoad();
  }
}

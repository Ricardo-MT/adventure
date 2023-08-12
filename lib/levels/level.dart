import 'dart:async';

import 'package:adventure/actors/player.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World {
  Level({
    required this.levelName,
  });
  late String levelName;
  late TiledComponent level;
  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));
    add(level);
    final spawPoints = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');
    for (var point in (spawPoints!.objects)) {
      switch (point.class_) {
        case 'Player':
          final player = Player(
            character: PlayerCharacter.maskDude,
            position: Vector2(point.x, point.y),
          );
          add(player);
          break;
        default:
      }
    }
    return super.onLoad();
  }
}

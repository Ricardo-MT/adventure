import 'dart:async';

import 'package:adventure/pixel_adventure.dart';
import 'package:flame/components.dart';

enum BackgroundTiles {
  blue,
  brown,
  gray,
  green,
  pink,
  purple,
  yellow;

  @override
  String toString() => assetName;
}

extension BackgroundAssetName on BackgroundTiles {
  String get assetName {
    switch (this) {
      case BackgroundTiles.blue:
        return "Blue";
      case BackgroundTiles.brown:
        return "Brown";
      case BackgroundTiles.gray:
        return "Gray";
      case BackgroundTiles.green:
        return "Green";
      case BackgroundTiles.pink:
        return "Pink";
      case BackgroundTiles.purple:
        return "Purple";
      case BackgroundTiles.yellow:
        return "Yellow";
    }
  }
}

class BackgroundTile extends SpriteComponent with HasGameRef<PixelAdventure> {
  BackgroundTile({
    super.position,
    super.size,
    this.backgroundColorAsset = 'Gray',
    this.scrollSpeed = 0.4,
  });
  final String backgroundColorAsset;
  final double scrollSpeed;

  @override
  FutureOr<void> onLoad() {
    priority = -1;
    if (size.isZero()) {
      size = Vector2.all(64.4);
    }
    sprite =
        Sprite(game.images.fromCache('Background/$backgroundColorAsset.png'));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.y += scrollSpeed;
    const tileSize = 64.0;
    final scrollHeight = (game.size.y / tileSize).floor();
    if (position.y > scrollHeight * tileSize) {
      position.y = -tileSize;
    }
    super.update(dt);
  }
}

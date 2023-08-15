import 'package:adventure/actors/player.dart';
import 'package:adventure/components/collision_block.dart';
import 'package:flame/components.dart';

bool checkCollision(Player player, CollisionBlock block) {
  final playerWidth = player.hitbox.width;
  final playerHeight = player.hitbox.height;
  final playerX = player.x +
      player.hitbox.x -
      (player.scale.x < 0 ? (playerWidth + 2 * player.hitbox.x) : 0);
  final playerY = player.hitbox.y + player.y;
  final blockX = block.x;
  final blockY = block.y;
  final blockWidth = block.width;
  final blockHeight = block.height;

  return (playerY < blockY + blockHeight &&
      playerY + playerHeight > blockY &&
      playerX < blockX + blockWidth &&
      playerX + playerWidth > blockX);
}

bool hasCollidedHorizontally(PositionComponent a, PositionComponent b) {
  var aCenter = a.center;
  var bCenter = b.center;

  var collidedDy = a.size.y / 2 + b.size.y / 2;
  var collidedDx = a.size.x / 2 + b.size.x / 2;
  var distance = _getDistance(aCenter, bCenter);
  if (distance.y > collidedDy) {
    return false;
  }
  // return (a.position.x < (b.position + b.size).x &&
  //     (a.position + a.size).x > b.position.x);
  return (distance.x < collidedDx);
}

Vector2 getCollisionVector(PositionComponent a, PositionComponent b) {
  var aCenter = a.center;
  var bCenter = b.center;

  var collidedDy = (a.height + b.height) / 2;
  var collidedDx = (a.width + b.width) / 2;
  var distance = _getDistance(aCenter, bCenter);
  var isFarInY = distance.y > collidedDy;
  var isFarInX = distance.x > collidedDx;
  if (isFarInY || isFarInX) {
    return Vector2.zero();
  }
  var dx = 0.0;
  var dy = 0.0;
  if (distance.y <= collidedDy) {
    if (a.topLeftPosition.x >= b.topLeftPosition.x + b.width) {
      dx = 1;
    } else {
      if (a.topLeftPosition.x + a.width <= b.topLeftPosition.x + 10) {
        dx = -1;
      }
    }
  }

  if (dx == 0) {
    if (a.topLeftPosition.y + 10 >= b.topLeftPosition.y + b.height) {
      dy = 1;
    } else if (a.topLeftPosition.y + a.height <= b.topLeftPosition.y + 10) {
      dy = -1;
    }
  }
  return Vector2(dx, dy);
}

// Always positive values
Vector2 _getDistance(Vector2 a, Vector2 b) =>
    Vector2((a.x - b.x).abs(), (a.y - b.y).abs());

Vector2 positionalProduct(List<Vector2> points) {
  var px = 1.0;
  var py = 1.0;
  for (var point in points) {
    px *= point.x;
    py *= point.y;
  }
  return Vector2(px, py);
}

import 'package:flame/components.dart';
import 'package:flutter/services.dart';

enum KeyboardDirection {
  idle,
  up,
  upRight,
  right,
  downRight,
  down,
  downLeft,
  left,
  upLeft,
}

extension KeyboardStateDeltaVector on KeyboardDirection {
  Vector2 get vector {
    switch (this) {
      case KeyboardDirection.idle:
        return Vector2.zero();
      case KeyboardDirection.up:
        return Vector2(0, -1);
      case KeyboardDirection.upRight:
        return Vector2(1, -1);
      case KeyboardDirection.right:
        return Vector2(1, 0);
      case KeyboardDirection.downRight:
        return Vector2(1, 1);
      case KeyboardDirection.down:
        return Vector2(0, 1);
      case KeyboardDirection.downLeft:
        return Vector2(-1, 1);
      case KeyboardDirection.left:
        return Vector2(-1, 0);
      case KeyboardDirection.upLeft:
        return Vector2(-1, -1);
    }
  }

  double get x => vector.x;

  double get y => vector.y;
}

class KeyboardDirectionManager {
  KeyboardDirectionManager() {
    _deltas = {};
    _directions = {};
    for (var value in KeyboardDirection.values) {
      _deltas[value] = value.vector;
      _directions[value.vector] = value;
    }
  }
  late Map<KeyboardDirection, Vector2> _deltas;
  late Map<Vector2, KeyboardDirection> _directions;

  Vector2? getDelta(KeyboardDirection direction) => _deltas[direction];

  KeyboardDirection? getDirection(Vector2 vector) => _directions[vector];
}

final _manager = KeyboardDirectionManager();

KeyboardDirection getDirectionFromKeyboardInput(
    Set<LogicalKeyboardKey> keysPressed) {
  var dP = [
    keysPressed.contains(LogicalKeyboardKey.keyA)
        ? KeyboardDirection.left.vector
        : Vector2.zero(),
    keysPressed.contains(LogicalKeyboardKey.keyD)
        ? KeyboardDirection.right.vector
        : Vector2.zero(),
    keysPressed.contains(LogicalKeyboardKey.keyW)
        ? KeyboardDirection.up.vector
        : Vector2.zero(),
    keysPressed.contains(LogicalKeyboardKey.keyS)
        ? KeyboardDirection.down.vector
        : Vector2.zero(),
  ].reduce((value, element) => value + element);
  return _manager.getDirection(dP) ?? KeyboardDirection.idle;
}

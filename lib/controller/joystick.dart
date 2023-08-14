import 'package:flame/components.dart';

extension JoystickStateDeltaVector on JoystickDirection {
  Vector2 get vector {
    switch (this) {
      case JoystickDirection.idle:
        return Vector2.zero();
      case JoystickDirection.up:
        return Vector2(0, -1);
      case JoystickDirection.upRight:
        return Vector2(1, -1);
      case JoystickDirection.right:
        return Vector2(1, 0);
      case JoystickDirection.downRight:
        return Vector2(1, 1);
      case JoystickDirection.down:
        return Vector2(0, 1);
      case JoystickDirection.downLeft:
        return Vector2(-1, 1);
      case JoystickDirection.left:
        return Vector2(-1, 0);
      case JoystickDirection.upLeft:
        return Vector2(-1, -1);
    }
  }

  double get x => vector.x;

  double get y => vector.y;
}

import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent {
  CollisionBlock({
    Vector2? position,
    Vector2? size,
    this.isPlatform = false,
  }) : super(position: position, size: size);
  final bool isPlatform;
  @override
  bool get debugMode => false;
}

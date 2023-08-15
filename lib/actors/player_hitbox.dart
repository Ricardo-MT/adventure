class CustomHitbox {
  CustomHitbox({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });
  late double x;
  late double y;
  late double width;
  late double height;
}

class PlayerHitbox extends CustomHitbox {
  PlayerHitbox({
    required super.x,
    required super.y,
    required super.width,
    required super.height,
  });
}

class FruitHitbox extends CustomHitbox {
  FruitHitbox({
    required super.x,
    required super.y,
    required super.width,
    required super.height,
  });
}

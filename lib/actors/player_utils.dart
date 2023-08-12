enum PlayerCharacter { maskDude, ninjaFrog, pinkMan }

extension PlayerCharacterName on PlayerCharacter {
  String get name {
    switch (this) {
      case PlayerCharacter.maskDude:
        return "Mask Dude";
      case PlayerCharacter.ninjaFrog:
        return "Ninja Frog";
      case PlayerCharacter.pinkMan:
        return "Pink Man";
    }
  }
}

enum PlayerStates { idle, running, jump, doubleJump, wallJump, fall, hit }

enum PlayerDirection { left, right, none }

extension PlayerDirectionDelta on PlayerDirection {
  double get delta {
    switch (this) {
      case PlayerDirection.left:
        return -1;
      case PlayerDirection.right:
        return 1;
      case PlayerDirection.none:
        return 0;
    }
  }
}

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

enum PlayerStates {
  idle,
  running,
  jump,
  doubleJump,
  wallJump,
  fall,
  hit,
  appearing,
  dissapearing,
}

extension PlayerStatesX on PlayerStates {
  bool get isFrozen => [
        PlayerStates.appearing,
        PlayerStates.dissapearing,
        PlayerStates.hit
      ].contains(this);
}

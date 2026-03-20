{ config, inputs, lib, userName, ... }:
lib.mkIf config.laptop.features.applications.enable {
  nix-homebrew = {
    enable = true;
    autoMigrate = true;
    user = userName;
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
    };
    mutableTaps = false;
  };

  homebrew = {
    enable = true;
    taps = builtins.attrNames config.nix-homebrew.taps;
    casks = [
      "hammerspoon"
    ];
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
  };
}

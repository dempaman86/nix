{ lib, laptop, ... }:
lib.mkIf laptop.features.hammerspoon.enable {
  home.file.".hammerspoon" = {
    source = ../../hammerspoon;
    recursive = true;
  };
}

{ ... }:
{
  imports = [
    ./packages.nix
    ./applications.nix
    ./repos.nix
    ./hammerspoon.nix
    ./tmux.nix
    ./shell.nix
    ./ghostty.nix
    ./external-repos.nix
  ];

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}

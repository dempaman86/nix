{ pkgs, repoRoot ? null, self, ... }:
{
  nix.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    firefox
    git
    ghostty-bin
    jq
    nixfmt
    signal-desktop
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  environment.variables = {
    LAPTOP_REPO = if repoRoot != null then repoRoot else "${self}";
  };

  system.configurationRevision = self.rev or self.dirtyRev or null;
}

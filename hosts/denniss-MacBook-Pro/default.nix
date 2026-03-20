{ config, inputs, lib, repoRoot, self, userName, hostName, ... }:
let
  localModule = "/Users/dennis/.config/laptop/local.nix";
in
{
  imports =
    [
      ../../modules/laptop/options.nix
      ../../modules/darwin/base.nix
      ../../modules/darwin/defaults.nix
    ]
    ++ lib.optionals (builtins.pathExists localModule) [ localModule ];

  laptop.features = {
    dock.enable = true;
    packages.enable = true;
    applications.enable = true;
    hammerspoon.enable = true;
    repos.enable = true;
  };

  laptop.paths.projectsRoot = "/Users/dennis/Documents/Projects";

  laptop.repos = [
    {
      name = "nvim";
      url = "https://github.com/dempaman86/nvim.git";
      path = "/Users/dennis/Documents/Projects/nvim";
      ensurePresent = true;
      linkTarget = ".config/nvim";
    }
    {
      name = "neowiki";
      url = "https://github.com/dempaman86/neowiki.git";
      path = "/Users/dennis/Documents/Projects/neowiki";
      ensurePresent = true;
      linkTarget = null;
    }
  ];

  networking.hostName = hostName;

  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.${userName} = {
    home = "/Users/${userName}";
  };

  home-manager = {
    backupFileExtension = "before-home-manager";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs self hostName userName repoRoot;
      laptop = config.laptop;
    };
    users.${userName} = import ../../modules/home/default.nix;
  };

  system.primaryUser = userName;
  system.stateVersion = 6;
}

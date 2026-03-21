{ config, inputs, lib, repoRoot, self, userName, homeDir, projectsRoot, hostName, ... }:
let
  localModule = "${homeDir}/.config/laptop/local.nix";
in
{
  imports =
    [
      ../../modules/laptop/options.nix
      ../../modules/darwin/base.nix
      ../../modules/darwin/defaults.nix
      ../../modules/darwin/firefox.nix
      ../../modules/darwin/homebrew.nix
    ]
    ++ lib.optionals (builtins.pathExists localModule) [ localModule ];

  laptop.features = {
    dock.enable = true;
    packages.enable = true;
    applications.enable = true;
    firefox.enable = true;
    hammerspoon.enable = true;
    repos.enable = true;
  };

  laptop.paths.projectsRoot = projectsRoot;

  laptop.repos = [
    {
      name = "nvim";
      url = "https://github.com/dempaman86/nvim.git";
      path = "${projectsRoot}/nvim";
      ensurePresent = true;
      linkTarget = ".config/nvim";
    }
    {
      name = "neowiki";
      url = "https://github.com/dempaman86/neowiki.git";
      path = "${projectsRoot}/neowiki";
      ensurePresent = true;
      linkTarget = null;
    }
  ];

  networking.hostName = hostName;

  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.${userName} = {
    home = homeDir;
  };

  home-manager = {
    backupFileExtension = "before-home-manager";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs self hostName userName homeDir projectsRoot repoRoot;
      laptop = config.laptop;
    };
    users.${userName} = import ../../modules/home/default.nix;
  };

  system.primaryUser = userName;
  system.stateVersion = 6;
}

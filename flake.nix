{
  description = "Declarative Apple Silicon laptop setup with nix-darwin and Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, home-manager, ... }:
    let
      envFirst =
        names: fallback:
        let
          values = builtins.filter (value: value != "") (map builtins.getEnv names);
        in
        if values != [ ] then builtins.head values else fallback;

      system = "aarch64-darwin";
      configName = "macos";
      legacyConfigName = "denniss-MacBook-Pro";
      userName = envFirst [ "LAPTOP_USER" "SUDO_USER" "USER" ] "dennis";
      homeDir = envFirst [ "LAPTOP_HOME" ] "/Users/${userName}";
      projectsRoot = "${homeDir}/Documents/Projects";
      repoRoot = "${projectsRoot}/nix";
      hostName = envFirst [ "LAPTOP_HOSTNAME" "HOSTNAME" ] legacyConfigName;
      pkgs = import nixpkgs { inherit system; };
      darwinConfig = nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = {
          inherit inputs self hostName userName homeDir projectsRoot repoRoot;
        };
        modules = [
          nix-homebrew.darwinModules.nix-homebrew
          ./hosts/denniss-MacBook-Pro/default.nix
          home-manager.darwinModules.home-manager
        ];
      };
    in
    {
      formatter.${system} = pkgs.nixfmt;

      darwinConfigurations.${configName} = darwinConfig;
      darwinConfigurations.${legacyConfigName} = darwinConfig;

      checks.${system}.darwin-system = darwinConfig.system;
    };
}

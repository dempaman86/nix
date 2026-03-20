{
  description = "Declarative Apple Silicon laptop setup with nix-darwin and Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, ... }:
    let
      envOr =
        name: fallback:
        let
          value = builtins.getEnv name;
        in
        if value != "" then value else fallback;

      system = "aarch64-darwin";
      configName = "macos";
      legacyConfigName = "denniss-MacBook-Pro";
      userName = envOr "USER" "dennis";
      homeDir = envOr "HOME" "/Users/${userName}";
      projectsRoot = "${homeDir}/Documents/Projects";
      repoRoot = "${projectsRoot}/nix";
      hostName = envOr "HOSTNAME" legacyConfigName;
      pkgs = import nixpkgs { inherit system; };
      darwinConfig = nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = {
          inherit inputs self hostName userName homeDir projectsRoot repoRoot;
        };
        modules = [
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

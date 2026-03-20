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
      system = "aarch64-darwin";
      hostName = "denniss-MacBook-Pro";
      userName = "dennis";
      repoRoot = "/Users/dennis/Documents/Projects/nix";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      formatter.${system} = pkgs.nixfmt;

      darwinConfigurations.${hostName} = nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = {
          inherit inputs self hostName userName repoRoot;
        };
        modules = [
          ./hosts/${hostName}/default.nix
          home-manager.darwinModules.home-manager
        ];
      };

      checks.${system}.darwin-system = self.darwinConfigurations.${hostName}.system;
    };
}

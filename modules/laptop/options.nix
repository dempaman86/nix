{ lib, ... }:
{
  options.laptop = {
    features = {
      dock.enable = lib.mkEnableOption "manage macOS Dock defaults";
      packages.enable = lib.mkEnableOption "manage user packages via Home Manager";
      applications.enable = lib.mkEnableOption "link Home Manager apps into ~/Applications";
      firefox.enable = lib.mkEnableOption "manage Firefox policies and profiles via Home Manager";
      hammerspoon.enable = lib.mkEnableOption "manage ~/.hammerspoon from the nix repo";
      repos.enable = lib.mkEnableOption "manage the repos that should exist under the projects root";
    };

    paths = {
      projectsRoot = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Absolute path to the local root that should contain cloned project repos.";
      };
    };

    repos = lib.mkOption {
      default = [ ];
      description = "Repos that should exist locally and can optionally be linked into the home directory.";
      type = lib.types.listOf (lib.types.submodule ({ ... }: {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            description = "Human-readable name for the repo entry.";
          };

          url = lib.mkOption {
            type = lib.types.str;
            description = "Clone URL for the repo.";
          };

          path = lib.mkOption {
            type = lib.types.str;
            description = "Absolute local path for the repo.";
          };

          ensurePresent = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether activation should clone the repo when it is missing.";
          };

          linkTarget = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Optional target under $HOME that should point to the repo.";
          };
        };
      }));
    };
  };
}

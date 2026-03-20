{ config, lib, laptop, pkgs, ... }:
let
  cfg = laptop;
  repos = cfg.repos;
  escape = lib.escapeShellArg;
  gitBin = lib.getExe pkgs.git;
  linkedRepos = builtins.filter (repo: repo.linkTarget != null) repos;
  linkFiles =
    builtins.listToAttrs (
      map
        (repo: {
          name = repo.linkTarget;
          value.source = config.lib.file.mkOutOfStoreSymlink repo.path;
        })
        linkedRepos
    );
  cloneCommands =
    map
      (repo:
        let
          pathArg = escape repo.path;
          urlArg = escape repo.url;
          nameArg = escape repo.name;
        in
        ''
          if [ ! -e ${pathArg} ]; then
            echo "Cloning ${nameArg} into ${pathArg}"
            ${gitBin} clone ${urlArg} ${pathArg}
          else
            echo "Keeping existing repo at ${pathArg}"
          fi
        '')
      (builtins.filter (repo: repo.ensurePresent) repos);
in
lib.mkIf cfg.features.repos.enable {
  assertions = [
    {
      assertion = cfg.paths.projectsRoot != null;
      message = "Set laptop.paths.projectsRoot when laptop.features.repos.enable is true.";
    }
  ];

  home.file = linkFiles;

  home.activation.ensureProjectsRepos = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    projects_root=${escape cfg.paths.projectsRoot}
    mkdir -p "$projects_root"
    ${lib.concatStringsSep "\n" cloneCommands}
  '';
}

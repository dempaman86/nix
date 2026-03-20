{ laptop, lib, pkgs, ... }:
lib.mkIf laptop.features.packages.enable {
  home.packages = with pkgs; [
    bash-language-server
    fd
    fzf
    go
    gopls
    kubectl
    lua-language-server
    marksman
    neovim
    pyright
    sesh
    tmux
    ripgrep
    typescript
    typescript-language-server
    wget
    vscode-langservers-extracted
    yaml-language-server
    yamllint
    zoxide
  ];
}

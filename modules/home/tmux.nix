{ lib, laptop, pkgs, ... }:
lib.mkIf laptop.features.packages.enable {
  home.file.".tmux.conf".source = ../../dotfiles/tmux/.tmux.conf;

  home.activation.ensureTmuxPluginManager = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    plugins_dir="$HOME/.tmux/plugins"
    tpm_dir="$plugins_dir/tpm"

    mkdir -p "$plugins_dir"

    if [ ! -e "$tpm_dir" ]; then
      echo "Cloning tmux TPM into $tpm_dir"
      ${lib.getExe pkgs.git} clone https://github.com/tmux-plugins/tpm "$tpm_dir"
    else
      echo "Keeping existing TPM at $tpm_dir"
    fi
  '';
}

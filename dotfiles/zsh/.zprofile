typeset -U path PATH

path=(
  "$HOME/.nix-profile/bin"
  "/etc/profiles/per-user/$USER/bin"
  "/run/current-system/sw/bin"
  "/nix/var/nix/profiles/default/bin"
  $path
)

export PATH
export EDITOR="nvim"
export VISUAL="nvim"
export K9S_EDITOR="nvim"
export KUBE_EDITOR="nvim"

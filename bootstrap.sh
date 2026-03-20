#!/usr/bin/env bash

set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "bootstrap.sh ar bara avsett for macOS."
  exit 1
fi

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if command -v nix >/dev/null 2>&1; then
  echo "Nix finns redan installerat: $(command -v nix)"
else
  echo "Installerar Nix med den officiella macOS-installern..."
  sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
fi

if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
  # Gor `nix` tillgangligt i den aktuella shellsessionen nar mojligt.
  # shellcheck disable=SC1091
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

mkdir -p "$HOME/.config/laptop"

if [[ -f "$HOME/.config/laptop/local.nix" ]]; then
  echo "Behaller befintlig lokal override: $HOME/.config/laptop/local.nix"
else
  cp "$repo_root/local/default.nix.example" "$HOME/.config/laptop/local.nix"
  echo "Skapade lokal override: $HOME/.config/laptop/local.nix"
fi

switch_flake="path:$repo_root#macos"
nix_flags=(--extra-experimental-features "nix-command flakes")

echo
echo "Nasta steg:"
echo "  cd \"$repo_root\""
echo "  sudo nix ${nix_flags[*]} run github:LnL7/nix-darwin/master#darwin-rebuild -- switch --impure --flake \"$switch_flake\""

echo
read -r -p "Kora forsta darwin-rebuild switch nu? [y/N] " run_switch

if [[ "$run_switch" =~ ^[Yy]$ ]]; then
  cd "$repo_root"
  nix "${nix_flags[@]}" run github:LnL7/nix-darwin/master#darwin-rebuild -- switch --impure --flake "$switch_flake"
else
  echo "Hoppar over switch. Kor detta senare:"
  echo "  nix ${nix_flags[*]} run github:LnL7/nix-darwin/master#darwin-rebuild -- switch --impure --flake \"$switch_flake\""
fi

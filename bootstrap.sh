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

echo
echo "Nasta steg:"
echo "  mkdir -p ~/.config/laptop"
echo "  cp \"$repo_root/local/default.nix.example\" ~/.config/laptop/local.nix"
echo "  cd \"$repo_root\""
echo '  nix run github:LnL7/nix-darwin/master#darwin-rebuild -- switch --impure --flake "path:$PWD#macos"'

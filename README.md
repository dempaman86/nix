# Nix

En deklarativ Nix-root for din maskinsetup, med macOS som forsta target och plats for senare Linux-, WSL- och container-targets.

Repo:t bor i `/Users/dennis/Documents/Projects/nix` och ar den centrala källan for hur din Mac ska vara uppsatt.

## Mal

- Nix som kontrollplan for maskinen
- Delad struktur for system, user-space och host-specifikt
- Ett centralt repo for dotfiles och macOS-setup
- Ett generellt repo-kataloglager for repos som ska finnas i `~/Documents/Projects`
- `nvim` som enda live-externa config i v1
- Maskinspecifika hemligheter och overrides i en ignorerad lokal fil

## Struktur

```text
.
|-- dotfiles/
|   `-- tmux/
|       `-- .tmux.conf
|-- flake.nix
|-- hosts/
|   `-- denniss-MacBook-Pro/
|       `-- default.nix
|-- hammerspoon/
|-- inventory/
|   `-- current-machine.md
|-- local/
|   `-- default.nix.example
|-- modules/
|   |-- darwin/
|   |   |-- base.nix
|   |   `-- defaults.nix
|   |-- home/
|   |   |-- applications.nix
|   |   |-- default.nix
|   |   |-- external-repos.nix
|   |   |-- hammerspoon.nix
|   |   |-- packages.nix
|   |   |-- repos.nix
|   |   |-- shell.nix
|   |   `-- tmux.nix
|   `-- laptop/
|       `-- options.nix
`-- flake.lock
```

## Bootstrap

1. Klona repo:t till `/Users/dennis/Documents/Projects/nix`.
2. Kor bootstrap-scriptet for att installera Nix om det saknas:

```bash
cd /Users/dennis/Documents/Projects/nix
./bootstrap.sh
```

3. Skapa den lokala override-filen utanfor repo:t:

```bash
mkdir -p ~/.config/laptop
cp local/default.nix.example ~/.config/laptop/local.nix
```

4. Justera `~/.config/laptop/local.nix` med maskinspecifika vardes eller secrets.
5. Gå till repo-roten:

```bash
cd /Users/dennis/Documents/Projects/nix
```

6. Forsta gangen, kor:

```bash
nix run github:LnL7/nix-darwin/master#darwin-rebuild -- switch \
  --flake "path:$PWD#denniss-MacBook-Pro"
```

Nar `darwin-rebuild` finns installerat blir den vanliga operator-kommandot:

```bash
darwin-rebuild switch --flake "path:$PWD#denniss-MacBook-Pro"
```

`bootstrap.sh` kor inte `darwin-rebuild` at dig. Det installerar bara Nix och skriver ut nasta kommando att kora.

## Verifiering

- `nix --extra-experimental-features "nix-command flakes" flake check "path:$PWD"`
- `darwin-rebuild build --flake "path:$PWD#denniss-MacBook-Pro"`
- `darwin-rebuild switch --flake "path:$PWD#denniss-MacBook-Pro"`

Nuvarande maskinbild finns dokumenterad i [`inventory/current-machine.md`](/Users/dennis/Documents/Projects/nix/inventory/current-machine.md).

## Repo-Katalog

Hosten deklarerar vilka repos som ska finnas under `~/Documents/Projects`.

I v1 galler:

```nix
laptop.paths.projectsRoot = "/Users/dennis/Documents/Projects";
laptop.repos = [
  {
    name = "nvim";
    url = "https://github.com/dempaman86/nvim.git";
    path = "/Users/dennis/Documents/Projects/nvim";
    ensurePresent = true;
    linkTarget = ".config/nvim";
  }
  {
    name = "neowiki";
    url = "https://github.com/dempaman86/neowiki.git";
    path = "/Users/dennis/Documents/Projects/neowiki";
    ensurePresent = true;
    linkTarget = null;
  }
];
```

Activation klonar bara om repo:t saknas. Befintliga working trees rors inte.

## Hammerspoon

Hammerspoon-konfigen bor nu i detta repo under [`hammerspoon/`](/Users/dennis/Documents/Projects/nix/hammerspoon) och installeras deklarativt till `~/.hammerspoon`. Forandringar kraver `darwin-rebuild switch`.

Om du vill halla lokala overrides utanfor repo:t kan du generera filer via `~/.config/laptop/local.nix`, till exempel:

```nix
home-manager.users.dennis.home.file.".hammerspoon/config/local.lua".text = ''
  return {
    notifications = false,
  }
'';
```

## Tmux

tmux-konfigen bor i [`dotfiles/tmux/.tmux.conf`](/Users/dennis/Documents/Projects/nix/dotfiles/tmux/.tmux.conf) och installeras till `~/.tmux.conf`.

Nix installerar i v1:

- `tmux`
- `fzf` (for `fzf-tmux`)
- `sesh`
- `fd`
- `kubectl`

TPM klonas om den saknas, men plugininstallationen foljer fortfarande ditt vanliga tmux-flode.

## Manuella undantag

Allt som kan agas rimligt av Nix bor ligga har. Nagra saker ar fortfarande undantag pa macOS:

- App Store-installationer
- TCC/privacy-behorigheter
- GUI-appar som inte fungerar bra via Nix i din miljo
- tmux-plugins utover TPM:s bootstrap

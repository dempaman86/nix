# Current Machine Baseline

Inventering tagen pa den nuvarande maskinen den 2026-03-14. Den har filen ar facit for vad som redan finns manuellt innan Nix far ta over nagot.

## System

- Host: `denniss-MacBook-Pro`
- User: `dennis`
- Platform: Apple Silicon (`arm64`)
- macOS: `15.7.4`

## Homebrew

### Formulae

- `gettext`
- `libunistring`
- `libuv`
- `lpeg`
- `luajit`
- `luv`
- `neovim`
- `tree-sitter@0.25`
- `unibilium`
- `utf8proc`

### Leaves

- `neovim`

### Casks

- `firefox`
- `ghostty`
- `hammerspoon`
- `signal`

### Bundle export

`brew bundle dump --describe --force --file=-` gav:

```ruby
# Ambitious Vim-fork focused on extensibility and agility
brew "neovim"
# Web browser
cask "firefox"
# Terminal emulator that uses platform-native UI and GPU acceleration
cask "ghostty"
# Desktop automation application
cask "hammerspoon"
# Instant messaging application focusing on security
cask "signal"
```

## Shell And Dotfiles

- `~/.zshrc`: finns inte
- `~/.zshenv`: finns inte
- `~/.zprofile`: finns och innehaller bara Homebrew shellenv
- `~/.gitconfig`: finns inte
- `~/.tmux.conf`: finns inte
- `~/.config/ghostty/config`: finns inte
- `~/.config/nvim`: finns inte
- externt `tmux`-repo finns: `/Users/dennis/Documents/Projects/tmux`
- externt `nvim`-repo finns: `/Users/dennis/Documents/Projects/nvim`

`~/.zprofile`:

```zsh
eval "$(/opt/homebrew/bin/brew shellenv zsh)"
```

## Hammerspoon

- `~/.hammerspoon` ar redan en symlink till `/Users/dennis/Documents/Projects/Hammerspoon`
- Hammerspoon-konfigen i det gamla externa repot ar den senast kanda manuella sanningen innan flytt in i `nix`-repot

## Applications Seen In /Applications

- `Codex.app`
- `Firefox.app`
- `Ghostty.app`
- `Hammerspoon.app`
- `Safari.app`
- `Signal.app`

## Dock

Nuvarande viktiga Dock-varden:

- `autohide = true`
- `orientation = left`
- `show-recents = false`
- `tilesize = 45`
- `wvous-br-corner = 14`
- persistenta appar: `Safari`, `System Settings`
- stack: `Downloads`

## SSH

- `~/.ssh/config`: finns inte
- nycklar finns: `id_ed25519`, `id_ed25519.pub`
- known hosts finns

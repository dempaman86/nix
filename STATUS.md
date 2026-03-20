# Status

Senast uppdaterad: 2026-03-20

## Sammanfattning

Detta repo ar nu källan till macOS-setupen pa `/Users/dennis/Documents/Projects/nix`.
`nvim` ligger kvar som eget live-repo i `/Users/dennis/Documents/Projects/nvim`.

Vi har precis borjat flytta Neovim LSP/lint fran Mason till Nix.

## Redan gjort

- `nix-darwin` + Home Manager ar aktiverat for `denniss-MacBook-Pro`.
- `nvim` repo klonas/sakerstalls under `~/Documents/Projects/nvim` och ar lankt till `~/.config/nvim`.
- Hammerspoon, tmux, zsh och Ghostty-config ar flyttade till detta repo.
- Ghostty installeras via `ghostty-bin` och dess config kommer fran `dotfiles/ghostty/config`.
- JetBrains Mono Nerd Font installeras via `fonts.packages`.
- Mason slutar nu auto-installera dessa verktyg i `nvim`-repot:
  - `bashls`
  - `gopls`
  - `jsonls`
  - `lua_ls`
  - `marksman`
  - `pyright`
  - `ts_ls`
  - `yamlls`
  - `yamllint`
- Dessa verktyg installeras nu via Nix i `modules/home/packages.nix`:
  - `bash-language-server`
  - `gopls`
  - `lua-language-server`
  - `marksman`
  - `pyright`
  - `vscode-langservers-extracted`
  - `yaml-language-server`
  - `yamllint`
  - `typescript`
  - `typescript-language-server`
- `bashls`, `pyright`, `jsonls`, `yamlls`, `yamllint`, `ts_ls` och `gopls` finns i PATH efter switch:
- `bashls`, `pyright`, `jsonls`, `yamlls`, `yamllint`, `ts_ls` och `gopls` finns i PATH efter switch:
  - de pekar pa `/etc/profiles/per-user/dennis/bin/...`
- `lua_ls` och `marksman` ar nu ocksa flyttade till Nix-konfigen, men inte verifierade live an.

## Viktiga filer

- Nix paketlista:
  - `modules/home/packages.nix`
- Nvim LSP:
  - `/Users/dennis/Documents/Projects/nvim/lua/plugins/lsp.lua`
- Nvim lint:
  - `/Users/dennis/Documents/Projects/nvim/lua/plugins/lint.lua`
- Nvim filetypes:
  - `/Users/dennis/Documents/Projects/nvim/lua/config/filetypes.lua`
- Nvim entrypoint:
  - `/Users/dennis/Documents/Projects/nvim/init.lua`

## Aktuellt lage i Neovim

- `test.sh` fungerar med `bashls`.
- `test.py` fungerar med `pyright`.
- `go.work` gav inte langre filetype-fel. I stallet failade `gopls` med:
  - `ENOENT ... 'go'`
- Slutsats:
  - filetype-fixarna fungerar
  - `gopls` servern finns, men Go toolchain (`go`) saknas i PATH
- `:LspInfo` visar fortfarande varningar om `gowork`, `gotmpl`, `markdown.mdx`, `neowiki`.
  - Det verkar vara en healthcheck/LspInfo-begransning.
  - `vim.filetype.match(...)` returnerar redan ratt:
    - `foo.mdx` -> `markdown.mdx`
    - `go.work` -> `gowork`
    - `template.gotmpl` -> `gotmpl`
    - `~/neowiki/test.md` -> `neowiki`
  - Tolka detta som kosmetiska varningar tills motsatsen bevisats i riktiga buffrar.

## Nasta steg

1. `go` ar nu tillagt i `modules/home/packages.nix`, men inte verifierat live an.
2. `lua-language-server` och `marksman` ar nu ocksa tillagda i `modules/home/packages.nix`.
3. Kora:
   - `cd /Users/dennis/Documents/Projects/nix`
   - `sudo darwin-rebuild switch --flake "path:$PWD#denniss-MacBook-Pro"`
4. Verifiera:
   - `command -v go`
   - `command -v lua-language-server`
   - `command -v marksman`
   - oppna `go.work` i `nvim`
   - kora `:LspInfo`
5. Om `go.work` fungerar, fortsatta lugnt med LSP via Nix ett i taget.

## Rekommenderad riktning

- Fortsatt strategi: LSP direkt via Nix, en i taget.
- Mason behalls tills vidare som UI, men ska inte auto-installera Nix-agda servers/tools.
- Nix ager binarerna, `nvim`-repot ager editor-konfigurationen.

## Ovrigt att komma ihag

- For vanliga keyboard modifier-remaps pa denna Mac fungerade inte enkel `defaults delete` ensam.
- Den enda verifierat fungerande reset-sekvensen var:

```bash
defaults -currentHost delete -g 'com.apple.keyboard.modifiermapping.1452-833-0' 2>/dev/null || true
hidutil property --set '{"UserKeyMapping":[]}'
killall cfprefsd keyboardservicesd "System Settings" 2>/dev/null || true
sudo shutdown -r now
```

- Undvik att gissa pa `Fn/Globe`-remaps pa denna Touch Bar-Mac utan ny verifiering i terminalen.

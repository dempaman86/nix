# Status

Senast uppdaterad: 2026-03-20

## Sammanfattning

Detta repo ar nu källan till macOS-setupen pa `~/Documents/Projects/nix`.
`nvim` ligger kvar som eget live-repo i `~/Documents/Projects/nvim`.

Vi har precis borjat flytta Neovim LSP/lint fran Mason till Nix.

## Redan gjort

- `nix-darwin` + Home Manager ar aktiverat for `denniss-MacBook-Pro`.
- `bootstrap.sh` finns i repo-roten och:
  - installerar Nix pa macOS om det saknas
  - skapar `~/.config/laptop/local.nix` om den saknas
  - fragar om den ska kora forsta `darwin-rebuild switch`
  - kor forsta `nix run ... darwin-rebuild` med explicita `nix-command flakes` for rena maskiner
- Flaken ar nu justerad for att lasa `USER`, `HOME` och `HOSTNAME` via `--impure`, sa samma repo kan anvandas under andra anvandarnamn an `dennis`.
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
- `nix build --no-link --impure "path:/Users/dennis/Documents/Projects/nix#darwinConfigurations.macos.system"` passerar.
- `nix build --no-link "path:/Users/dennis/Documents/Projects/nix#darwinConfigurations.denniss-MacBook-Pro.system"` passerar fortfarande som legacy-target.

## Viktiga filer

- Nix paketlista:
  - `modules/home/packages.nix`
- Flake entrypoint:
  - `flake.nix`
- Hostkonfiguration:
  - `hosts/denniss-MacBook-Pro/default.nix`
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

## Git-lage

- `nix`-repot ar committat med:
  - `2da3101 feat: move macOS laptop setup into nix repo`
  - `e5b8d90 docs: update VM handoff status`
  - arbetskopia innehaller nu opushade andringar for generisk anvandare/home-katalog och ny publik flake-target `#macos`
- `nvim`-repot ar committat med:
  - `fa7a39b chore: move language tooling from Mason to Nix`
- `tmux`-repot ar rent.
- Det gamla `Hammerspoon`-repot ar inte en aktiv source of truth langre och ar fortfarande oinitierat/ostadat.

## Nasta steg

1. Pusha `nix`- och `nvim`-repona om de ska anvandas for VM/bootstrap-test.
2. For ett riktigt rent test:
   - skapa ny macOS-anvandare eller macOS-VM
   - klona `nix`
   - om klonen ar aldre an `b1ddf47`, kora `git pull`
   - kora `./bootstrap.sh`
   - svara ja pa prompten om du vill lata scriptet kora forsta `darwin-rebuild switch`
3. Verifiera i den rena miljon:
   - repos klonas/lankas ratt under `~/Documents/Projects`
   - `command -v go`
   - `command -v lua-language-server`
   - `command -v marksman`
   - `command -v pyright`
   - `command -v bash-language-server`
   - oppna `go.work`, `test.py`, `test.sh`, `.yaml`, markdown i `nvim`
   - kora `:LspInfo`
4. Om allt fungerar, ar Mason i praktiken overflodig och kan tas bort helt ur `nvim`-repot i ett senare steg.

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

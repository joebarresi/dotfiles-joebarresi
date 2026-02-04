# Nix Configuration Migration Plan

Goal: Migrate existing dotfiles to a modular nix-darwin + home-manager setup that supports multiple machines (work laptop, personal laptop).

## Target Structure

```
nix/
├── flake.nix              # Entry point, defines all machine configs
├── hosts/
│   ├── work.nix           # Work laptop config (80a9972b1e3d)
│   └── personal.nix       # Personal laptop config
├── modules/
│   ├── darwin/            # System-level modules
│   │   ├── homebrew.nix
│   │   └── defaults.nix   # macOS settings
│   └── home/              # User-level modules
│       ├── shell.nix      # zsh, aliases, env vars
│       ├── git.nix
│       ├── vscode.nix
│       └── iterm2.nix
└── profiles/
    ├── work.nix           # Work-specific packages/settings
    └── personal.nix       # Personal-specific packages/settings
```

## Task List

### Phase 1: Migrate Current Config
- [x] Add CLI tools from Brewfile to home.nix (eza, gh, pipx, python312)
- [x] Add zsh config from dots/.zshrc
- [x] Fix zsh plugins (zsh-autocomplete - fetched from GitHub instead of broken nix package)
- [x] Add VSCode settings + extensions
- [x] Add Homebrew casks (raycast, jordanbaird-ice, google-chrome, iterm2, visual-studio-code, copilot-money; kiro for work profile)
- [x] Add non-Homebrew GUI apps (flux-app added via Homebrew)
- [x] Enable Touch ID for sudo

### Phase 2: Modularize
- [x] Create `modules/` directory structure
- [x] Extract shell config to `modules/home/shell.nix`
- [ ] Extract git config to `modules/home/git.nix`
- [ ] Extract VSCode config to `modules/home/vscode.nix`
- [ ] Extract Homebrew to `modules/darwin/homebrew.nix`
- [ ] Extract macOS defaults to `modules/darwin/defaults.nix`

### Phase 3: Multi-Machine Support
- [ ] Explain to Joe how this design will work and how he can put different modules in different places
- [ ] Create `hosts/` directory
- [ ] Create work machine config (`hosts/work.nix`)
- [ ] Create personal machine config (`hosts/personal.nix`)
- [ ] Create `profiles/work.nix` for work-specific tools (amazon taps, brazil, etc.)
- [ ] Create `profiles/personal.nix` for personal tools
- [ ] Update flake.nix to support multiple darwinConfigurations

### Phase 4: Polish
- [ ] Add bootstrap script for new machines
- [ ] Update README with setup instructions
- [ ] Test on personal laptop
- [ ] Make installed apps indexable by Spotlight

## Notes

**Work-specific items** (from Brewfile):
- Amazon Homebrew taps
- ninja-dev-sync
- Brazil-related VSCode extensions

**Shared items**:
- Most CLI tools (eza, gh, neovim, nvm, etc.)
- Most casks (ghostty, raycast, etc.)
- Shell config (zsh)

## Progress

Started: 2026-02-03
Last updated: 2026-02-03

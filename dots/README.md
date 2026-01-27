# Dotfiles

Personal configuration files for setting up a new machine.

## Contents

| File/Directory | Description |
|----------------|-------------|
| `.zshrc` | Zsh config with Oh My Zsh, Powerlevel10k theme, plugins, and aliases |
| `.config/iterm2/com.googlecode.iterm2.plist` | iTerm2 preferences (profiles, colors, fonts, keybindings) |
| `vscode/settings.json` | VS Code editor settings |
| `vscode/extensions.txt` | List of VS Code extensions |
| `install-zsh.sh` | Script to install Oh My Zsh + plugins + theme |

## Setup

### 1. Zsh + Oh My Zsh
```bash
./install-zsh.sh
cp .zshrc ~/.zshrc
```

### 2. iTerm2
```bash
cp .config/iterm2/com.googlecode.iterm2.plist ~/Library/Preferences/
```
Restart iTerm2 after copying.

### 3. VS Code
```bash
cp vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
cat vscode/extensions.txt | xargs -L 1 code --install-extension
```

## Zsh Plugins Included

- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) - Fish-like autosuggestions
- [fast-syntax-highlighting](https://github.com/zdharma-continuum/fast-syntax-highlighting) - Syntax highlighting
- [zsh-autocomplete](https://github.com/marlonrichert/zsh-autocomplete) - Real-time autocomplete
- [powerlevel10k](https://github.com/romkatv/powerlevel10k) - Prompt theme

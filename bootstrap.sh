#!/bin/bash
set -e

echo "🚀 Bootstrapping nix-darwin + home-manager..."

DOTFILES_DIR="$HOME/personal-projects/dotfiles-joebarresi"

# Install Nix
if ! command -v nix &> /dev/null; then
  echo "📦 Installing Nix..."
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
  echo "⚠️  Please restart your terminal and run this script again."
  exit 0
fi

# Clone dotfiles if not present
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "📂 Cloning dotfiles..."
  mkdir -p "$HOME/personal-projects"
  git clone https://github.com/joebarresi/dotfiles-joebarresi.git "$DOTFILES_DIR"
fi

cd "$DOTFILES_DIR/nix"

# First time: use nix run. After: use darwin-rebuild
if ! command -v darwin-rebuild &> /dev/null; then
  echo "🔨 First-time nix-darwin bootstrap..."
  nix run nix-darwin -- switch --flake .
else
  echo "🔨 Rebuilding nix-darwin config..."
  sudo darwin-rebuild switch --flake .
fi

echo "✅ Done! Open a new terminal to use your new shell."

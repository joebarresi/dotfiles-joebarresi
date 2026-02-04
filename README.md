# dotfiles-joebarresi

Nix-darwin + home-manager configuration supporting multiple machines.

## Machines

| Hostname | Profile | User |
|----------|---------|------|
| 80a9972b1e3d | amazon | jbarresi |
| Josephs-MacBook-Air | personal | josephbarresi |

## Setup

### Quick Start (New Machine)
```
curl -sL https://raw.githubusercontent.com/joebarresi/dotfiles-jbarresi/main/bootstrap.sh | bash
```

### Manual Setup

### Step 1: Install Nix
```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### Step 2: Clone this repo
```
git clone <repo-url> ~/personal-projects/dotfiles-jbarresi
```

### Step 3: Build and switch
```
sudo darwin-rebuild switch --flake ~/personal-projects/dotfiles-jbarresi/nix
```

The flake auto-detects your hostname and applies the correct config.

## Usage

After initial setup, just run:
```
rebuild-nix
```

## Structure

```
nix/
├── flake.nix           # Entry point, defines all machines
├── home.nix            # Shared home-manager config
├── hosts/
│   ├── amazon.nix      # Amazon laptop system config
│   └── personal.nix    # Personal laptop system config
├── modules/
│   ├── darwin/         # System-level modules
│   │   ├── homebrew.nix
│   │   └── defaults.nix
│   └── home/           # User-level modules
│       ├── shell.nix
│       └── vscode.nix
└── profiles/
    ├── amazon.nix      # Amazon-specific packages/aliases
    └── personal.nix    # Personal-specific packages/aliases
```

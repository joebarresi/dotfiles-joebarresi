{ pkgs, ... }: {
  # Required for nix-darwin
  system.stateVersion = 5;
  system.primaryUser = "jbarresi";
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Enable nix command and flakes
  nix.enable = false;

  # Enable zsh system-wide (required for home-manager zsh to work)
  programs.zsh.enable = true;

  # Enable Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # GUI apps via Homebrew casks (nix-darwin manages Homebrew)
  homebrew = {
    enable = true;
    casks = [
      "copilot-money"
      "flux-app"
      "google-chrome"
      "iterm2"
      "jordanbaird-ice"
      "raycast"
      "visual-studio-code"
    ];
  };
}

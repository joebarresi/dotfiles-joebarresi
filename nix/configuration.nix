{ pkgs, ... }: {
  imports = [
    ./modules/darwin/homebrew.nix
    ./modules/darwin/defaults.nix
  ];

  # Required for nix-darwin
  system.stateVersion = 5;
  system.primaryUser = "jbarresi";
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Enable nix command and flakes
  nix.enable = false;

  # Enable zsh system-wide (required for home-manager zsh to work)
  programs.zsh.enable = true;

  environment.systemPath = [ "/opt/homebrew/bin" ];

  # Enable Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;
}

{ pkgs, ... }: {
  # Required for nix-darwin
  system.stateVersion = 5;
  system.primaryUser = "jbarresi";
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Enable nix command and flakes
  nix.enable = false;

  # Enable zsh system-wide (required for home-manager zsh to work)
  programs.zsh.enable = true;

  # GUI apps via Homebrew casks (nix-darwin manages Homebrew)
  # homebrew = {
  #   enable = true;
  #   casks = [
  #     "iterm2"
  #   ];
  #   onActivation.cleanup = "zap";
  # };
}

{ pkgs, ... }: {
  imports = [
    ../modules/darwin/homebrew.nix
    ../modules/darwin/defaults.nix
    ../profiles/darwin/amazon.nix
  ];

  system.stateVersion = 5;
  system.primaryUser = "jbarresi";
  nixpkgs.hostPlatform = "aarch64-darwin";

  nix.enable = false;
  programs.zsh.enable = true;
  security.pam.services.sudo_local.touchIdAuth = true;
}

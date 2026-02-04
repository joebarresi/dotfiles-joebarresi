{ pkgs, lib, ... }: {
  home.username = "jbarresi";
  home.homeDirectory = lib.mkForce "/Users/jbarresi";
  home.stateVersion = "24.05";

  nixpkgs.config.allowUnfree = true;

  imports = [
    ./modules/home/shell.nix
    ./modules/home/vscode.nix
  ];

  home.packages = [
    pkgs.eza
    pkgs.gh
    pkgs.pipx
    pkgs.python312
  ];
}

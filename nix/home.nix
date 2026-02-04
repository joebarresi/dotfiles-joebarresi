{ username, homeProfile }: { pkgs, lib, ... }: {
  home.username = username;
  home.homeDirectory = lib.mkForce "/Users/${username}";
  home.stateVersion = "24.05";

  nixpkgs.config.allowUnfree = true;

  imports = [
    ./modules/home/shell.nix
    ./modules/home/vscode.nix
    homeProfile
  ];

  home.packages = [
    pkgs.eza
    pkgs.gh
    pkgs.pipx
    pkgs.python312
  ];
}

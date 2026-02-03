{ pkgs, ... }: {
  home.username = "jbarresi";
  home.homeDirectory = "/Users/jbarresi";
  home.stateVersion = "24.05";

  # CLI packages go here
  home.packages = [
    # pkgs.ripgrep
    # pkgs.fzf
  ];
}

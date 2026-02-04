{ ... }: {
  homebrew = {
    enable = true;
    brews = [
      "zsh-autocomplete"
    ];
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

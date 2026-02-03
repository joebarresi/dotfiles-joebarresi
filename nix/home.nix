{ pkgs, lib, ... }: {
  home.username = "jbarresi";
  home.homeDirectory = lib.mkForce "/Users/jbarresi";
  home.stateVersion = "24.05";

  home.packages = [
    pkgs.eza
    pkgs.gh
  ];

  # Powerlevel10k config file
  home.file.".p10k.zsh".source = ../dots/.p10k.zsh;

  programs.zsh = {
    enable = true;
    
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = false;

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-autocomplete";
        src = pkgs.zsh-autocomplete;
      }
    ];

    initExtraFirst = ''
      # Instant prompt (must be at top)
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
    '';

    initExtra = ''
      # Keybindings
      bindkey '\e[A' up-line-or-history
      bindkey '\eOA' up-line-or-history
      bindkey '\e[B' down-line-or-history
      bindkey '\eOB' down-line-or-history

      # NVM
      export NVM_DIR="$HOME/.nvm"
      [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
      [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

      # Load p10k config
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';

    shellAliases = {
      # testing
      general = "echo 'You are the Man'";

      # General
      nuke = "sudo rm -rf node_modules";
      rebuild = "darwin-rebuild switch --flake ~/.config/nix#80a9972b1e3d";
      
      # Git
      gits = "git status";
      gitb = "git branch";
      gitc = "git checkout";
      track = "git branch -u origin/mainline";
      amend = "git add . && git commit --amend --no-edit";
    };
  };
}

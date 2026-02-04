{ pkgs, ... }: {
  # Powerlevel10k config file
  home.file.".p10k.zsh".source = ../../../dots/.p10k.zsh;

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    extraOptions = [ "--group-directories-first" "--header" ];
  };

  programs.zsh = {
    enable = true;
    
    autosuggestion.enable = false;
    syntaxHighlighting.enable = false;
    enableCompletion = false;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
      {
        name = "fast-syntax-highlighting";
        src = pkgs.zsh-fast-syntax-highlighting;
        file = "share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh";
      }
      {
        name = "zsh-autocomplete";
        src = pkgs.fetchFromGitHub {
          owner = "marlonrichert";
          repo = "zsh-autocomplete";
          rev = "25.03.19";
          sha256 = "sha256-eb5a5WMQi8arZRZDt4aX1IV+ik6Iee3OxNMCiMnjIx4=";
        };
        file = "zsh-autocomplete.plugin.zsh";
      }
    ];

    initExtraFirst = ''
      # Instant prompt
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
    '';

    initExtra = ''
      # NVM
      export NVM_DIR="$HOME/.nvm"
      [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
      [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

      # Load p10k config
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';

    shellAliases = {
      general = "echo 'You are the Man'";
      nuke = "sudo rm -rf node_modules";
      rebuild-nix = "sudo darwin-rebuild switch --flake ~/.config/nix#80a9972b1e3d";
      gits = "git status";
      gitb = "git branch";
      gitc = "git checkout";
      track = "git branch -u origin/mainline";
      amend = "git add . && git commit --amend --no-edit";
    };
  };
}

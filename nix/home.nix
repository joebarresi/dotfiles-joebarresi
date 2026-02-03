{ pkgs, lib, ... }: {
  home.username = "jbarresi";
  home.homeDirectory = lib.mkForce "/Users/jbarresi";
  home.stateVersion = "24.05";

  nixpkgs.config.allowUnfree = true;

  home.packages = [
    pkgs.eza
    pkgs.gh
    pkgs.pipx
    pkgs.python312
  ];

  # Powerlevel10k config file
  home.file.".p10k.zsh".source = ../dots/.p10k.zsh;

  programs.eza = {
    enable = true;
    enableZshIntegration = true; # Automatically aliases 'ls' to 'eza' for Zsh
    git = true;                  # Shows git status in list view
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
  };

  programs.zsh = {
    enable = true;
    
    autosuggestion.enable = true;
    syntaxHighlighting.enable = false;
    enableCompletion = false;

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "git";
        src = pkgs.oh-my-zsh;
        file = "share/oh-my-zsh/plugins/git/git.plugin.zsh";
      }
      {
        name = "fast-syntax-highlighting";
        src = pkgs.zsh-fast-syntax-highlighting;
        file = "share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh";
      }
    ];

    initExtraFirst = ''
      # Instant prompt
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
      rebuild-nix = "sudo darwin-rebuild switch --flake ~/.config/nix#80a9972b1e3d";
      
      # Git
      gits = "git status";
      gitb = "git branch";
      gitc = "git checkout";
      track = "git branch -u origin/mainline";
      amend = "git add . && git commit --amend --no-edit";
    };
  };

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    
    profiles.default = {
      userSettings = {
        "[dockercompose]" = {
          "editor.autoIndent" = "advanced";
          "editor.defaultFormatter" = "redhat.vscode-yaml";
          "editor.insertSpaces" = true;
          "editor.tabSize" = 2;
        };
        "[github-actions-workflow]" = {
          "editor.defaultFormatter" = "redhat.vscode-yaml";
        };
        "chat.disableAIFeatures" = true;
        "diffEditor.ignoreTrimWhitespace" = false;
        "editor.accessibilitySupport" = "off";
        "editor.detectIndentation" = false;
        "editor.fontFamily" = "Comic Mono";
        "editor.inlineSuggest.fontFamily" = "ComicMono";
        "editor.tabSize" = 2;
        "files.exclude" = {
          "src/*/build" = false;
          "build" = false;
          "env" = true;
          "**/.git" = true;
          "**/.svn" = true;
          "**/.hg" = true;
          "**/.DS_Store" = true;
          "**/Thumbs.db" = true;
          "**/CVS" = true;
        };
        "files.watcherExclude" = {
          "**/build/**" = true;
          "**/.git/objects/**" = true;
          "**/.git/subtree-cache/**" = true;
          "**/.hg/store/**" = true;
          "**/node_modules/*/**" = true;
        };
        "javascript.updateImportsOnFileMove.enabled" = "always";
        "search.exclude" = {
          "env" = true;
          "src/*/build" = true;
          "build" = true;
          "**/node_modules" = true;
          "**/bower_components" = true;
          "**/*.code-search" = true;
        };
        "telemetry.enableCrashReporter" = false;
        "telemetry.enableTelemetry" = false;
        "telemetry.telemetryLevel" = "off";
        "typescript.updateImportsOnFileMove.enabled" = "always";
        "workbench.colorTheme" = "One Dark Pro";
        "workbench.commandPalette.experimental.enableNaturalLanguageSearch" = false;
        "workbench.editorAssociations" = {
          "*.html" = "default";
        };
        "workbench.settings.enableNaturalLanguageSearch" = false;
      };

      extensions = with pkgs.vscode-extensions; [
        ms-python.python
        ms-python.vscode-pylance
        ms-python.debugpy
        ms-vscode-remote.remote-ssh
        redhat.vscode-yaml
        zhuangtongfa.material-theme
        dbaeumer.vscode-eslint
      ];
    };
  };
}

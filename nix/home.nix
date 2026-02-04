{ pkgs, lib, ... }: {
  home.username = "jbarresi";
  home.homeDirectory = lib.mkForce "/Users/jbarresi";
  home.stateVersion = "24.05";

  nixpkgs.config.allowUnfree = true;

  imports = [
    ./modules/home/shell.nix
  ];

  home.packages = [
    pkgs.eza
    pkgs.gh
    pkgs.pipx
    pkgs.python312
  ];

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

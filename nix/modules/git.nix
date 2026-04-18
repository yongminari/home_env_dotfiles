{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "yongminari";
        email = "easyid21c@gmail.com";
      };
      init.defaultBranch = "main";
      core.ignorecase = true;
    };
  };

  programs.gitui = {
    enable = true;
    keyConfig = ''
      (
          move_left: Some(( code: Char('h'), modifiers: "")),
          move_right: Some(( code: Char('l'), modifiers: "")),
          move_up: Some(( code: Char('k'), modifiers: "")),
          move_down: Some(( code: Char('j'), modifiers: "")),

          stash_open: Some(( code: Char('S'), modifiers: "")),
          main_tabs_next: Some(( code: Char('l'), modifiers: "CONTROL")),
          main_tabs_prev: Some(( code: Char('h'), modifiers: "CONTROL")),

          open_help: Some(( code: Char('?'), modifiers: "")),
      )
    '';
  };

  # Delta: Syntax-highlighted git pager
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      line-numbers = true;
      side-by-side = true;
      syntax-theme = "ayu";
    };
  };

  # Lazygit Configuration
  programs.lazygit = {
    enable = true;
    settings = {
      git = {
        log = {
          showGraph = "always";
        };
      };
    };
  };
}

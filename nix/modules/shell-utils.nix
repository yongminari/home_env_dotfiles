{ config, pkgs, lib, ... }:

{
  home.shellAliases = {
    ls = "eza";
    ll = "eza -l --icons --git -a";
    lt = "eza --tree --level=2 --long --icons --git";
    cat = "bat";
    # Ghostty를 유지하면서 SSH 호환성을 챙기는 가장 현대적인 방법
    gssh = "ghostty +ssh";
    # ROS 2 & Qt Wayland compatibility fixes
    rviz2 = "env QT_QPA_PLATFORM=xcb rviz2";
    wireshark = "env QT_QPA_PLATFORM=xcb wireshark";
  };

  home.file.".config/starship-ssh.toml".source = ./starship-ssh.toml;

  # Starship 프롬프트
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    settings = lib.importTOML ./starship.toml;
  };

  # Eza (ls 보조)
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = false; 
    icons = "auto";
    git = true;
  };

  # Zoxide (cd 대체)
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    options = [ "--cmd cd" ];
  };

  # Bat (cat 대체)
  programs.bat = {
    enable = true;
    config = { theme = "OneHalfDark"; };
  };

  # FZF (Fuzzy Finder - 기본 설정으로 복구)
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  # Direnv
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    nix-direnv.enable = true;
  };

    # Yazi (Terminal File Manager)
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    shellWrapperName = "y";
  };

  # Yazi 설정을 raw text로 직접 관리 (가장 확실한 방법)
  xdg.configFile."yazi/yazi.toml".text = ''
    [manager]
    show_hidden = false
    sort_by     = "alphabetical"
    linemode    = "githead"

    [status]
    left  = [
      { name = "hovered", collect = false },
      { name = "count",   collect = false },
      { name = "githead", collect = false },
    ]
    right = [
      { name = "cursor",      collect = false },
      { name = "sort",        collect = false },
      { name = "permissions", collect = false },
    ]

    [opener]
    edit = [
      { run = '${pkgs.neovim}/bin/nvim "$@"', block = true },
    ]

    [theme]
    flavor = "ayu-dark"
  '';

  xdg.configFile."yazi/init.lua".text = ''
    require("githead"):setup()
  '';

  # githead.yazi 플러그인 설치
  xdg.configFile."yazi/plugins/githead.yazi".source = pkgs.fetchFromGitHub {
    owner = "llanosrocas";
    repo = "githead.yazi";
    rev = "main";
    sha256 = "sha256-o2EnQYOxp5bWn0eLn0sCUXcbtu6tbO9pdUdoquFCTVw=";
  };

  # Atuin (Magical Shell History)
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    flags = [ "--disable-up-arrow" ];
  };
}

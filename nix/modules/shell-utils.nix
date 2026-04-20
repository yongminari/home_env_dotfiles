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
    
    # 테마(Flavor) 설정
    settings = {
      theme = {
        flavor = "ayu-dark";
      };
    };
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

{ config, pkgs, lib, ... }:

{
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
    config = { theme = "TwoDark"; };
  };

  # FZF (Fuzzy Finder)
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;

    # 1. 성능 향상: 기본 검색 엔진을 fd로 변경 (빠르고 숨김 파일 지원, .git 제외)
    defaultCommand = "fd --type f --hidden --exclude .git";
    fileWidgetCommand = "fd --type f --hidden --exclude .git";      # Ctrl+T (파일 검색)
    changeDirWidgetCommand = "fd --type d --hidden --exclude .git"; # Alt+C (디렉토리 검색)

    # 2. 디자인: Dracula 테마 색상 및 UI 레이아웃
    defaultOptions = [
      "--height 50%"
      "--layout=reverse"
      "--border"
      "--inline-info"
      "--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9"
      "--color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9"
      "--color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6"
      "--color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4"
    ];

    # 3. 미리보기(Preview): bat(파일 내용) & eza(디렉토리 트리) 연동
    fileWidgetOptions = [
      "--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
    ];
    changeDirWidgetOptions = [
      "--preview 'eza --tree --level=2 --icons --git {} | head -200'"
    ];
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
  };

  # Atuin (Magical Shell History)
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    flags = [ "--disable-up-arrow" ]; # 방향키 위쪽은 기존 zsh-substring-search를 유지하고 싶을 때. 원치 않으면 삭제 가능하지만 우선 안전하게 추가
  };
}

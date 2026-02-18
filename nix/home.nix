{ config, pkgs, ... }:

{
  # 사용자 정보
  home.username = "yongminari";
  home.homeDirectory = "/home/yongminari";

  # Home Manager State Version
  home.stateVersion = "23.11"; 

  # [패키지 설치 목록]
  home.packages = with pkgs; [
    # 시스템 도구
    neofetch
    htop
    git
    fzf
    ripgrep
    
    # [Fonts]
    maple-mono.NF          
    nerd-fonts.ubuntu-mono 
  ];

  # [Shell] Zsh 설정
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # [Fix] initExtra -> initContent 로 변경 (최신 master 브랜치 반영)
    initContent = ''
      export PATH=$HOME/.local/bin:$PATH
      alias ll="ls -al"
      alias hms="home-manager switch --flake ~/dotfiles/#yongminari"
    '';
  };

  # Git 설정
  programs.git = {
    enable = true;
    
    # [Fix] 에러 및 경고 해결을 위한 설정 방식 변경
    # userName/userEmail 직접 사용 대신 extraConfig 사용
    extraConfig = {
      user = {
        name = "yongminari";
        email = "easyid21c@gmail.com"; # 에러 로그에 있던 이메일 반영
      };
      init = {
        defaultBranch = "master";
      };
    };
  };
  
  # Home Manager 스스로 관리하도록 설정
  programs.home-manager.enable = true;
}

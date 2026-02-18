{ config, pkgs, ... }:

{
  # 사용자 정보
  home.username = "yongminari";
  home.homeDirectory = "/home/yongminari";

  # Home Manager State Version (변경하지 말 것)
  home.stateVersion = "23.11"; 

  # [패키지 설치 목록]
  home.packages = with pkgs; [
    # 시스템 도구
    neofetch
    htop
    git
    fzf
    ripgrep
    
    # [Fonts] - 폰트 설정
    # [Fix] maple-mono는 패키지 묶음이므로 .NF를 명시해야 함
    maple-mono.NF          
    nerd-fonts.ubuntu-mono 
  ];

  # [Shell] Zsh 설정
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # [Fix] home-manager/master 버전에 따른 경고 대응 (initExtra -> initContent)
    # 만약 에러가 발생하면 다시 initExtra로 변경
    initExtra = ''
      export PATH=$HOME/.local/bin:$PATH
      # 여기에 alias 등을 추가
      alias ll="ls -al"
      alias hms="home-manager switch --flake ~/dotfiles/#yongminari"
    '';
  };

  # Git 설정
  programs.git = {
    enable = true;
    userName = "yongminari";
    userEmail = "easyid21c@gmail.com"; # 본인 이메일 입력
  };
  
  # Home Manager 스스로 관리하도록 설정
  programs.home-manager.enable = true;
}

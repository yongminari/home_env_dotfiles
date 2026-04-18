{ config, pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    # [쉘 통합 활성화] - 새 탭 작업 디렉토리 유지 등의 기능을 위해 다시 켭니다.
    enableZshIntegration = true;
    enableBashIntegration = true;

    # [Ghostty 설정] - Nix 속성 세트 방식으로 정의
    settings = {
      # SSH 접속 시 원격 서버에 terminfo를 자동으로 주입하기 위해 xterm-ghostty 사용
      term = "xterm-ghostty";
      command = "${pkgs.zsh}/bin/zsh";
      
      # [Font]
      font-family = [
        "Maple Mono NF"
        "D2Coding ligature"
      ];
      font-size = 12;

      # [Window & Visuals]
      window-width = 150;
      window-height = 60;
      window-decoration = "auto";
      background-opacity = 0.85;
      theme = "Gruvbox Dark";

      # [Cursor]
      cursor-style = "block";
      cursor-style-blink = true;

      # [Shell Integration]
      shell-integration = "detect";
      shell-integration-features = "no-cursor,ssh-terminfo";

      # [Clipboard]
      clipboard-read = "allow";
      clipboard-write = "allow";
    };
  };

  # SSH 접속 시 원격에서 들어오는 xterm-ghostty를 인식하기 위한 terminfo 설정
  home.packages = [ pkgs.ghostty.terminfo ];
  
  # 시스템 표준 경로에 terminfo 링크 생성 (SSH 세션 인식용)
  # share/terminfo 내부의 내용이 직접 ~/.terminfo에 들어가도록 설정하는 것이 더 정확할 수 있음
  home.file.".terminfo".source = "${pkgs.ghostty.terminfo}/share/terminfo";

  # 쉘 환경 변수에 terminfo 경로 추가
  home.sessionVariables = {
    TERMINFO_DIRS = "${config.home.homeDirectory}/.terminfo:/usr/share/terminfo";
  };

  # [GNOME 런처 인식 문제 해결]
  home.file.".local/share/applications/com.mitchellh.ghostty.desktop".source = 
    "${pkgs.ghostty}/share/applications/com.mitchellh.ghostty.desktop";
}

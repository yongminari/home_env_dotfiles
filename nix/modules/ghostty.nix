{ config, pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    # [쉘 통합 활성화] - 새 탭 작업 디렉토리 유지 등의 기능을 위해 다시 켭니다.
    enableZshIntegration = true;
    enableBashIntegration = true;

    # [Ghostty 설정] - Nix 속성 세트 방식으로 정의
    settings = {
      command = "${pkgs.zsh}/bin/zsh";
      # [Font]
      font-family = [
        "Maple Mono NF"
        "D2Coding ligature"
      ];
      font-size = 12;
      adjust-cell-width = "-15%";

      # [Window & Visuals]
      window-width = 150;
      window-height = 60;
      window-decoration = "auto";
      background-opacity = 0.85;
      theme = "Dracula";

      # [Compatibility]
      term = "xterm-256color";

      # [Cursor]
      cursor-style = "block";
      cursor-style-blink = true;

      # [Shell Integration]
      shell-integration = "detect";
      shell-integration-features = "no-cursor";

      # [Clipboard]
      clipboard-read = "allow";
      clipboard-write = "allow";
    };
  };

  # [GNOME 런처 인식 문제 해결]
  # Nix가 설치한 Ghostty의 .desktop 파일을 GNOME이 인식할 수 있는 표준 경로로 심볼릭 링크합니다.
  home.file.".local/share/applications/com.mitchellh.ghostty.desktop".source = 
    "${pkgs.ghostty}/share/applications/com.mitchellh.ghostty.desktop";
}

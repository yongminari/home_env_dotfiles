{ config, pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;

    # [Ghostty 설정] - Nix 속성 세트 방식으로 정의
    settings = {
      # [Font]
      font-family = "Maple Mono NF";
      font-size = 12;

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
}

{ config, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi; 
    
    terminal = "ghostty";
    
    # [Theme Override] - 'iggy' 테마를 불러오고 폰트만 우리가 원하는 것으로 덮어씁니다.
    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      # 1. 'iggy' 테마를 임포트합니다.
      "@import" = "${pkgs.rofi}/share/rofi/themes/iggy.rasi";

      # 2. 전역 설정(*)에서 폰트를 우리 취향대로 바꿉니다.
      "*" = {
        font = "Maple Mono NF, D2Coding ligature Bold 12";
      };
    };

    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      drun-display-format = "{name}";
    };
  };
}

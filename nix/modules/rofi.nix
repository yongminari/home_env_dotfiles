{ config, pkgs, inputs, ... }:

let
  rofi-themes = inputs.rofi-themes;
in
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi; 
    
    terminal = "ghostty";
    
    # [Theme Override] - 공식 테마를 불러오고 폰트만 우리가 원하는 것으로 덮어씁니다.
    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      # 1. 먼저 공식 테마 파일을 임포트합니다.
      "@import" = "~/.config/rofi/launchers/type-6/style-1.rasi";

      # 2. 전역 설정(*)에서 폰트를 우리 취향대로 바꿉니다. (이게 최종 승리합니다.)
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

  # 공식 테마 소스 연결
  home.file.".config/rofi/launchers/type-6".source = "${rofi-themes}/files/launchers/type-6";
  home.file.".config/rofi/colors".source = "${rofi-themes}/files/colors";
}

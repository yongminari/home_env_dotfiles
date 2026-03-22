{ config, pkgs, inputs, ... }:

let
  # Flake inputs에서 테마 소스를 가져옵니다. (이제 수동 해시가 필요 없습니다!)
  rofi-themes = inputs.rofi-themes;
in
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi; 
    
    # [Rofi 기본 설정]
    terminal = "ghostty";
    font = "Maple Mono NF CN 12";
    
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      display-drun = "";
      drun-display-format = "{name}";
    };
  };

  # 공식 테마 파일들을 ~/.config/rofi 에 심볼릭 링크로 연결합니다.
  home.file.".config/rofi/launchers/type-6".source = "${rofi-themes}/files/launchers/type-6";
  home.file.".config/rofi/colors".source = "${rofi-themes}/files/colors";

  # Hyprland에서 호출할 때 공식 테마를 사용하도록 전용 실행 스크립트 생성
  home.packages = [
    (pkgs.writeShellScriptBin "rofi-launcher" ''
      ${pkgs.rofi}/bin/rofi \
        -show drun \
        -theme ~/.config/rofi/launchers/type-6/style-1.rasi
    '')
  ];
}

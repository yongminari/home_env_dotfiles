{ config, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi; 
    
    terminal = "ghostty";
    
    # [Theme Override] - 'iggy' 테마를 불러오고 색상과 폰트를 오버라이드합니다.
    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      # 1. 기본 'iggy' 테마 임포트
      "@import" = "${pkgs.rofi}/share/rofi/themes/iggy.rasi";

      # 2. 전역 설정 및 텍스트 색상 (Catppuccin Mocha Text)
      "*" = {
        font = "Maple Mono NF, D2Coding ligature Bold 12";
        text-color = mkLiteral "#cdd6f4";
      };

      # 3. 메인 윈도우: 초록색 배경 이미지를 제거하고 어두운 보라빛 배경과 테두리 적용
      "window" = {
        background-color = mkLiteral "#1e1e2e"; # Mocha Base
        border-color = mkLiteral "#cba6f7";     # Mocha Mauve (보라)
        background-image = mkLiteral "none";    # 초록색 거북이 사진 제거
      };

      # 4. 입력창 및 리스트 영역: 반투명한 어두운 배경과 보라색 테두리
      "listview, inputbar, message" = {
        border-color = mkLiteral "#cba6f7";
        background-color = mkLiteral "#181825B3"; # Mocha Mantle + 70% 투명도
      };

      # 5. 선택된 항목: 보라색 강조 효과
      "element selected" = {
        border-color = mkLiteral "#cba6f7";
        background-color = mkLiteral "#cba6f733"; # 보라색 + 20% 투명도
      };
      
      # 6. 상단 버튼(모드 스위처): 그라데이션을 보라색 계열로 변경
      "button" = {
        border-color = mkLiteral "#cba6f7";
        background-image = mkLiteral "linear-gradient(to bottom, #313244, #181825)";
      };

      "button selected.normal" = {
         border-color = mkLiteral "#cba6f7";
         background-image = mkLiteral "linear-gradient(to bottom, #cba6f7, #181825)";
         text-color = mkLiteral "#1e1e2e";
      };

      # 7. 아이콘 크기 조정 (기존 6em의 80%인 4.8em으로 축소)
      "element-icon" = {
        size = mkLiteral "4.8em";
      };
    };

    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      drun-display-format = "{name}";
    };
  };
}

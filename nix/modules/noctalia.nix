{ inputs, pkgs, config, lib, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia-shell = {
    enable = true;
    
    settings = {
      bar = {
        position = "top";
        height = 36;
      };
      
      launcher = {
        view = "grid";
      };

      # 배경화면 설정 (Wallhaven 온라인 소스 사용)
      wallpaper = {
        enabled = true;
        overviewEnabled = true;
        automationEnabled = true;
        wallpaperChangeMode = "random";
        randomIntervalSec = 600; # 10분 (600초)
        
        # 오버뷰 시 블러 및 명암 효과
        overviewBlur = 0.5;
        overviewTint = 0.5;
        
        # Wallhaven 설정
        useWallhaven = true;
        wallhavenQuery = "dark";   # 어두운 배경화면 검색
        wallhavenCategories = "111"; # General, Anime, People 모두 포함
        wallhavenPurity = "100";     # SFW(Safe For Work) 이미지 전용
        wallhavenSorting = "random"; # 무작위 정렬
        
        # 전환 효과 설정
        transitionType = [
          "fade"
          "pixelate"
          "blur"
        ];
        transitionDuration = 1500;
      };

      colorSchemes.predefinedScheme = "Ayu";
    };
  };
}

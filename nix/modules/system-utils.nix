{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # [시스템 모니터링 및 정보]
    htop
    fastfetch
    lsb-release
    jq

    # [파일 및 네트워크 유틸리티]
    ripgrep
    fd
    unzip
    lolcat
    rclone
    dust               # 시각적 디스크 용량 분석
    tealdeer           # tldr (명령어 예제 사전)

    # [데스크탑/윈도우 매니저 유틸리티]
    swaybg
    hyprpaper
    networkmanagerapplet
    libnotify

    # [화면 캡처 도구]
    grim
    slurp
    swappy

    # [하드웨어 제어]
    pamixer
    brightnessctl
    pavucontrol

    # [클립보드 관리]
    xclip
    xsel
    wl-clipboard
    cliphist           # 클립보드 히스토리 관리

    # [Nix 관리]
    nix-output-monitor # nh가 빌드 로그를 시각화할 때 사용
    nix-index          # 파일이 어떤 패키지에 있는지 검색 (nix-locate)
  ];

  # wlogout 설정 (세련된 종료 메뉴)
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "loginctl lock-session";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "logout";
        action = "hyprctl dispatch exit";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
    ];
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "ayu";
      theme_background = false; # 투명 배경 사용
      vim_keys = true;
      update_ms = 500; # 업데이트 간격 (0.5초)
    };
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "${config.home.homeDirectory}/home_env_dotfiles";
  };

  # Swappy 설정 (캡처 후 즉시 편집기)
  xdg.configFile."swappy/config".text = ''
    [Default]
    save_dir=${config.home.homeDirectory}/Pictures/Screenshots
    save_filename_format=swappy-%Y%m%d-%H%M%S.png
    show_panel=false
    line_size=5
    text_size=20
    text_font=sans-serif
    paint_mode=brush
    early_exit=false
    fill_shape=false
  '';

  # 스크린샷 폴더 자동 생성
  home.activation.createScreenshotDir = config.lib.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ${config.home.homeDirectory}/Pictures/Screenshots
  '';

  # 클립보드 히스토리 감시 서비스
  services.cliphist.enable = true;
}

{ config, pkgs, ... }:

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
  ];
}

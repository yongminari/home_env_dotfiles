{ config, pkgs, lib, ... }:

{
  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
  ];

  home.packages = with pkgs; [
    # [시스템 유틸리티]
    fastfetch 
    htop 
    ripgrep 
    fd 
    unzip 
    lolcat
    lsb-release
    rclone
    swaybg
    rofi          # rofi-wayland가 통합된 최신 rofi
    hyprpaper     # Hyprland 전용 월페이퍼 도구
    networkmanagerapplet # Wi-Fi/Network 트레이 아이콘 (nm-applet)
    
    # [화면 캡처 도구]
    grim          # 화면 캡처 엔진
    slurp         # 영역 선택 도구
    swappy        # 캡처 이미지 즉석 편집기
    
    # [테마 및 아이콘]
    catppuccin-gtk     # 공식 Catppuccin GTK 테마
    catppuccin-kvantum # Qt 앱용 테마 엔진
    papirus-icon-theme # 가장 대중적이고 예쁜 아이콘 팩
    bibata-cursors     # 세련된 커서 테마 (theme.nix에서 사용됨)
    
    # [알림 센터]
    swaynotificationcenter # 현대적인 알림 엔진 및 컨트롤 센터
    libnotify              # notify-send 명령어를 위한 도구
    
    # [하드웨어 제어]
    pamixer        # 음량 조절 도구
    brightnessctl  # 화면 밝기 조절 도구
    pavucontrol    # 오디오 설정 GUI
    
    # [클립보드 관리]
    xclip 
    xsel 
    wl-clipboard 
    
    # [개발 보조 도구 (LSP/Parsers)]
    tree-sitter   # Tree-sitter CLI (Fix checkhealth error)
    nil           # Nix Language Server
    ast-grep      # ast-grep CLI
    lua51Packages.jsregexp # Luasnip dependency
    gopls         # Go LSP
    clang-tools   # clangd 등 (헤더 검색 등 에디터용)

    # [폰트 (Maple Mono, Nerd Fonts)]
    maple-mono.NF-unhinted
    d2coding
    nerd-fonts.ubuntu-mono 
    monaspace
    nerd-fonts.jetbrains-mono
    fnm
    carapace
  ];
}

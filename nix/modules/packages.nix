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
    
    # [화면 캡처 도구]
    grim          # 화면 캡처 엔진
    slurp         # 영역 선택 도구
    swappy        # 캡처 이미지 즉석 편집기
    
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
    maple-mono.NF-CN-unhinted
    maple-mono.NF
    nerd-fonts.ubuntu-mono 
    monaspace
    nerd-fonts.jetbrains-mono
    fnm
    carapace
  ];
}

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
    lazygit 
    lolcat
    lsb-release
    rclone
    swaybg
    
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

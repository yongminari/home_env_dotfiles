{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # [Git 및 버전 관리]
    gitui
    gh              # GitHub CLI
    lazydocker      # Docker TUI 관리

    # [런타임 및 환경 관리]
    fnm
    carapace

    # [개발 보조 도구 (LSP/Parsers)]
    tree-sitter
    nil
    ast-grep
    lua51Packages.jsregexp
    gopls
    clang-tools

    # [현대적 대체 도구]
    sd              # sed 대체 (find & replace)
    xh              # curl/httpie 대체
  ];
}

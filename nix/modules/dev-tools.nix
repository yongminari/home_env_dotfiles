{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # [Git 및 버전 관리]
    gitui

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
  ];
}

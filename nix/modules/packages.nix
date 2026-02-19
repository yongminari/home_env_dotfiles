{ config, pkgs, lib, isWSL, ... }:

{
  home.sessionVariables = {
    NPM_CONFIG_PREFIX = "${config.home.homeDirectory}/.npm-global";
  };
  home.sessionPath = [
    "${config.home.homeDirectory}/.npm-global/bin"
    "${config.home.homeDirectory}/.local/bin"
  ];

  home.packages = with pkgs; [
    # 유틸
    neofetch htop fzf ripgrep fd unzip
    
    # 개발 도구 (nodejs: 최신 LTS 자동)
    nodejs
    clang-tools cmake gnumake go gopls

    # 폰트
    maple-mono.NF nerd-fonts.ubuntu-mono 

  # [조건부 설치] Ghostty
  ] ++ (lib.optionals (!isWSL) [
    ghostty
  ]);

  # [Gemini CLI 자동 설치]
  home.activation.installGeminiCli = lib.hm.dag.entryAfter ["writeBoundary"] ''
    npm_global_dir="${config.home.homeDirectory}/.npm-global"
    mkdir -p "$npm_global_dir"
    export PATH="${pkgs.nodejs}/bin:$npm_global_dir/bin:$PATH"

    if ! command -v gemini &> /dev/null; then
      echo "Installing @google/gemini-cli..."
      npm install -g --prefix "$npm_global_dir" @google/gemini-cli
    fi
  '';
}

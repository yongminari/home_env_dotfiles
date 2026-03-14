{ config, pkgs, inputs, ... }:

{
  # [사용자 정보]
  home.username = "yongminari";
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/yongminari" else "/home/yongminari";
  home.stateVersion = "25.11"; 

  # [모듈 로드] 기능별 파일들을 여기서 불러옴
  imports = [
    ./modules/shell.nix
    ./modules/packages.nix
    ./modules/neovim.nix
    ./modules/zellij.nix
    ./modules/git.nix
    ./modules/ghostty.nix
    ./modules/rclone.nix
    ./modules/hyprland.nix
    ./modules/wofi.nix
  ];

  targets.genericLinux.enable = pkgs.stdenv.isLinux;
  fonts.fontconfig.enable = true;

  # Silence 'options.json' context warning by disabling manual generation
  manual.manpages.enable = false;
  manual.html.enable = false;
  manual.json.enable = false;

  programs.home-manager.enable = true;

  # [공통 쉘 에일리어스] - 모든 쉘(Bash, Zsh, Nushell)에서 공유됨
  home.shellAliases = {
    # Home Manager 관련
    hms = "home-manager switch --flake ~/home_env_dotfiles/#yongminari";
    hmsx = "home-manager switch --flake ~/home_env_dotfiles/#yongminari-x86-linux";
    hmsa = "home-manager switch --flake ~/home_env_dotfiles/#yongminari-aarch-linux";
    hmsm = "home-manager switch --flake ~/home_env_dotfiles/#yongminari-aarch-mac";

    # CLI 유틸리티 (Eza, Bat, Neovim)
    ls = "eza";
    ll = "eza -l --icons --git -a";
    lt = "eza --tree --level=2 --long --icons --git";
    cat = "bat";
    vi = "nvim";
    vim = "nvim";
    zj = "zellij";
    tocb = "wl-clipboard"; # xclip 대신 현대적인 wl-clipboard 우선
  };
}

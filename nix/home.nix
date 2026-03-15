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
    ./modules/sway.nix
    ./modules/rofi.nix
    ./modules/waybar.nix
  ];

  targets.genericLinux.enable = pkgs.stdenv.isLinux;
  fonts.fontconfig.enable = true;

  # Silence 'options.json' context warning by disabling manual generation
  manual.manpages.enable = false;
  manual.html.enable = false;
  manual.json.enable = false;

  programs.home-manager.enable = true;

  # [전역 세션 환경 변수]
  home.sessionVariables = {
    GTK_IM_MODULE = "ibus";
    QT_IM_MODULE = "ibus";
    XMODIFIERS = "@im=ibus";
    IBUS_ENABLE_SYNC_MODE = "1";
  };

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
    tocb = "wl-clipboard";

    # [Sway Shortcuts Cheat Sheet]
    sway_shortcuts = ''printf "\n  \033[1;34m🪟 Sway & Rofi Shortcuts\033[0m\n\n  \033[1;32mSuper + Enter\033[0m       Launch Ghostty\n  \033[1;32mSuper + D\033[0m           Launch Rofi (Apps)\n  \033[1;32mSuper + Q\033[0m           Kill Active Window\n  \033[1;32mSuper + F\033[0m           Toggle Fullscreen\n  \033[1;32mSuper + V\033[0m           Toggle Floating\n  \033[1;32mSuper + Escape\033[0m      Screen Lock (Swaylock)\n  \033[1;32mSuper + H/J/K/L\033[0m     Focus Navigation\n  \033[1;32mSuper + Shift + HJKL\033[0m Move Window Position\n  \033[1;32mSuper + 1~0\033[0m         Switch Workspace (1-10)\n  \033[1;32mSuper + Shift + E\033[0m   Exit Sway (Logout)\n  \033[1;32mSuper + Shift + C\033[0m   Reload Config (Apply Nix changes)\n\n" | lolcat'';
  };
}

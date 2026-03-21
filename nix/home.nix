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
    # 특정 IME 강제 설정은 제거 (GNOME/Sway 세션별로 자동 처리되도록 함)
  };

  # [Sway Shortcuts Cheat Sheet - Ultimate Edition]
  # Nushell 등의 쉘에서 ANSI 이스케이프 시퀀스(\033) 파싱 에러를 방지하기 위해 별도 스크립트로 분리
  home.packages = [
    (pkgs.writeShellScriptBin "sway-cheat" ''
      printf "\n  \033[1;34m🚀 [Launch & Basic]\033[0m\n  \033[1;32mSuper + Enter\033[0m       Launch Ghostty\n  \033[1;32mSuper + D\033[0m           Launch Rofi (Apps)\n  \033[1;32mSuper + Q\033[0m           Kill Active Window\n\n  \033[1;34m🪟 [Window Control]\033[0m\n  \033[1;32mSuper + H/J/K/L\033[0m     Move Focus\n  \033[1;32mSuper + Shift + HJKL\033[0m Move Window Position\n  \033[1;32mSuper + , / .\033[0m       Cycle Monitor Focus\n  \033[1;32mSuper + F\033[0m           Toggle Fullscreen\n  \033[1;32mSuper + V\033[0m           Toggle Floating\n\n  \033[1;34m📐 [Layout & Resize]\033[0m\n  \033[1;32mSuper + B\033[0m           Next split: Horizontal (Right)\n  \033[1;32mSuper + Shift + V\033[0m   Next split: Vertical (Down)\n  \033[1;32mSuper + E\033[0m           Toggle Layout Split (H/V)\n  \033[1;32mSuper + Alt + HJKL\033[0m  Quick Resize Window\n  \033[1;32mSuper + R\033[0m           Enter Resize Mode (Esc to Exit)\n\n  \033[1;34m🔢 [Workspaces]\033[0m\n  \033[1;32mSuper + 1~0\033[0m         Switch Workspace\n  \033[1;32mSuper + Shift + 1~0\033[0m Move Window to Workspace\n\n  \033[1;34m⚙️ [System]\033[0m\n  \033[1;32mSuper + Escape\033[0m      Lock Screen (Swaylock)\n  \033[1;32mSuper + Shift + E\033[0m   Exit Sway (Logout)\n  \033[1;32mSuper + Shift + C\033[0m   Reload Configuration\n  \033[1;32mSuper + Space\033[0m       IBus Language Toggle\n\n" | ${pkgs.lolcat}/bin/lolcat
    '')
    (pkgs.writeShellScriptBin "yazi-cheat" ''
      printf "\n  \033[1;34m📂 [Navigation]\033[0m\n  \033[1;32mh / j / k / l\033[0m       Left / Down / Up / Right\n  \033[1;32mg g / G\033[0m             Top / Bottom\n  \033[1;32mEnter / Backspace\033[0m   Enter / Leave directory\n  \033[1;32mz\033[0m                   Jump (zoxide integration)\n\n  \033[1;34m🛠️ [Operations]\033[0m\n  \033[1;32my / x / p\033[0m           Copy / Cut / Paste\n  \033[1;32md\033[0m                   Delete (Trash)\n  \033[1;32mr\033[0m                   Rename\n  \033[1;32ma\033[0m                   Create new file\n  \033[1;32m.\033[0m                   Toggle hidden files\n\n  \033[1;34m🔍 [Selection & Search]\033[0m\n  \033[1;32mv\033[0m                   Visual selection mode\n  \033[1;32mSpace\033[0m               Toggle selection\n  \033[1;32mf\033[0m                   Filter (Search) files\n  \033[1;32m/\033[0m                   Find within results\n\n  \033[1;34m🚪 [Exit]\033[0m\n  \033[1;32mq\033[0m                   Quit Yazi\n  \033[1;32mQ\033[0m                   Quit and keep current directory\n\n" | ${pkgs.lolcat}/bin/lolcat
    '')
  ];

  # [공통 쉘 에일리어스] - 모든 쉘(Bash, Zsh, Nushell)에서 공유됨
  home.shellAliases = {
    # Home Manager 관련
    hms = "home-manager switch --flake ~/home_env_dotfiles/#${config.home.username}";
    hmsx = "home-manager switch --flake ~/home_env_dotfiles/#${config.home.username}-x86-linux";
    hmsa = "home-manager switch --flake ~/home_env_dotfiles/#${config.home.username}-aarch-linux";
    hmsm = "home-manager switch --flake ~/home_env_dotfiles/#${config.home.username}-aarch-mac";

    # CLI 유틸리티 (Neovim)
    vi = "nvim";
    vim = "nvim";
    zj = "zellij";
    tocb = "wl-copy";
    ibus-setup = "env -i HOME=$HOME USER=$USER DISPLAY=$DISPLAY WAYLAND_DISPLAY=$WAYLAND_DISPLAY XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS PATH=/usr/bin:/bin XDG_DATA_DIRS=/usr/share:/usr/local/share /usr/bin/ibus-setup";

    # [Shortcuts Cheat Sheet]
    sway_shortcuts = "sway-cheat";
    yazi_shortcuts = "yazi-cheat";
  };
}

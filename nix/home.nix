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
    # ./modules/sway.nix
    ./modules/hyprland.nix
    ./modules/hyprlock.nix
    ./modules/rofi.nix
    ./modules/waybar.nix
  ];

  targets.genericLinux.enable = pkgs.stdenv.isLinux;
  fonts.fontconfig.enable = true;

  manual.manpages.enable = false;
  manual.html.enable = false;
  manual.json.enable = false;

  programs.home-manager.enable = true;

  # [Hyprland Shortcuts Cheat Sheet] - 전용 도움말 명령어 생성
  home.packages = [
    (pkgs.writeShellScriptBin "hypr-cheat" ''
      printf "\n  \033[1;35m🪄 [Hyprland Core & Launch]\033[0m\n"
      printf "  \033[1;32mSuper + Enter\033[0m       Launch Ghostty\n"
      printf "  \033[1;32mSuper + D\033[0m           Launch Rofi (Apps)\n"
      printf "  \033[1;32mSuper + Q\033[0m           Kill Active Window\n"
      printf "  \033[1;32mSuper + F\033[0m           Toggle Fullscreen\n"
      printf "  \033[1;32mSuper + V\033[0m           Toggle Floating\n\n"

      printf "  \033[1;35m🪟 [Window Control]\033[0m\n"
      printf "  \033[1;32mSuper + h/j/k/l\033[0m     Move Focus (Vim Style)\n"
      printf "  \033[1;32mSuper + Shift + hjkl\033[0m Move Window Position\n"
      printf "  \033[1;32mSuper + 1~0\033[0m         Switch Workspace\n"
      printf "  \033[1;32mSuper + Shift + 1~0\033[0m Move Window to Workspace\n\n"

      printf "  \033[1;35m📸 [Utilities & System]\033[0m\n"
      printf "  \033[1;32mPrint (PrtSc)\033[0m       Screenshot (Full)\n"
      printf "  \033[1;32mSuper + Shift + S\033[0m   Screenshot (Area + Editor)\n"
      printf "  \033[1;32mSuper + Escape\033[0m      Lock Screen (Hyprlock)\n"
      printf "  \033[1;32mSuper + Shift + E\033[0m   Exit Hyprland (Logout)\n"
      printf "  \033[1;32mSuper + R\033[0m           Enter Resize Mode\n\n"
      
      printf "  \033[1;34m💡 Tip:\033[0m Press \033[1;33mEsc\033[0m to switch IME to English mode.\n\n"
    '')
  ];

  # [공통 쉘 에일리어스]
  home.shellAliases = {
    # Home Manager 관련
    hms = "home-manager switch --flake ~/home_env_dotfiles/#${config.home.username}";
    hmsx = "home-manager switch --flake ~/home_env_dotfiles/#${config.home.username}-x86-linux";
    hmsa = "home-manager switch --flake ~/home_env_dotfiles/#${config.home.username}-aarch-linux";
    hmsm = "home-manager switch --flake ~/home_env_dotfiles/#${config.home.username}-aarch-mac";

    vi = "nvim";
    vim = "nvim";
    zj = "zellij";
    tocb = "wl-copy";

    # [Help Alias] - 새로 바뀐 도움말 명령어 연결
    hypr_shortcuts = "hypr-cheat";
  };
}

{ config, pkgs, inputs, ... }:

{
  # [사용자 정보]
  home.username = "yongminari";
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/yongminari" else "/home/yongminari";
  home.stateVersion = "25.11"; 

  # [모듈 로드] 기능별 파일들을 여기서 불러옴
  imports = [
    (if builtins.pathExists ./local.nix then ./local.nix else {})
    ./modules/shell.nix
    ./modules/packages.nix
    ./modules/neovim.nix
    ./modules/zellij.nix
    ./modules/git.nix
    ./modules/ghostty.nix
    ./modules/rclone.nix
    ./modules/hyprland.nix
    ./modules/hyprlock.nix
    ./modules/hypridle.nix
    ./modules/theme.nix
    ./modules/noctalia.nix
    ./modules/swappy.nix
  ];

  targets.genericLinux.enable = pkgs.stdenv.isLinux;
  fonts.fontconfig.enable = true;

  manual.manpages.enable = false;
  manual.html.enable = false;
  manual.json.enable = false;

  programs.home-manager.enable = true;

  # [공통 경로 설정] - 모든 쉘(Bash, Zsh, Nushell)에 적용됨
  home.sessionPath = [
    "$HOME/.nix-profile/bin"
    "$HOME/.local/bin"
    "$HOME/.local/state/nix/profiles/home-manager/profile/bin"
    "/nix/var/nix/profiles/default/bin"
    "/run/current-system/sw/bin"
  ];

  # [Hyprland Shortcuts Cheat Sheet] - 전용 도움말 명령어 생성
  home.packages = [
    (pkgs.writeShellScriptBin "hypr-cheat" ''
      printf "\n  \033[1;35m🪄 [Hyprland Core & Launch]\033[0m\n"
      printf "  \033[1;32mSuper + Enter\033[0m       Launch Ghostty\n"
      printf "  \033[1;32mSuper + Space\033[0m       Launch Noctalia (Apps)\n"
      printf "  \033[1;32mSuper + Q\033[0m           Kill Active Window\n"
      printf "  \033[1;32mSuper + F\033[0m           Toggle Fullscreen\n"
      printf "  \033[1;32mSuper + V\033[0m           Toggle Floating\n\n"

      printf "  \033[1;35m🪟 [Window Control]\033[0m\n"
      printf "  \033[1;32mSuper + h/j/k/l\033[0m     Move Focus (Vim Style)\n"
      printf "  \033[1;32mSuper + , / .\033[0m       Focus Monitor (Left/Right)\n"
      printf "  \033[1;32mSuper + Shift + hjkl\033[0m Move Window Position\n"
      printf "  \033[1;32mSuper + Shift + , / .\033[0m Move Window to Monitor\n"
      printf "  \033[1;32mSuper + 1~0\033[0m         Switch Workspace\n"
      printf "  \033[1;32mSuper + Shift + 1~0\033[0m Move Window to Workspace\n\n"

      printf "  \033[1;35m📸 [Utilities & System]\033[0m\n"
      printf "  \033[1;32mPrint (PrtSc)\033[0m       Screenshot (Full)\n"
      printf "  \033[1;32mSuper + Shift + S\033[0m   Screenshot (Area + Editor)\n"
      printf "  \033[1;32mSuper + Escape\033[0m      Lock Screen (Hyprlock)\n"
      printf "  \033[1;32mSuper + Shift + E\033[0m   Exit Hyprland (Logout)\n"
      printf "  \033[1;32mSuper + Alt + hjkl\033[0m  Quick Resize Window\n\n"
      
      printf "  \033[1;34m💡 Tip:\033[0m Press \033[1;33mEsc\033[0m to switch IME to English mode.\n\n"
    '')
    (pkgs.writeShellScriptBin "yazi-cheat" ''
      printf "\n  \033[1;34m📂 [Navigation]\033[0m\n  \033[1;32mh / j / k / l\033[0m       Left / Down / Up / Right\n  \033[1;32mg g / G\033[0m             Top / Bottom\n  \033[1;32mEnter / Backspace\033[0m   Enter / Leave directory\n  \033[1;32mz\033[0m                   Jump (zoxide integration)\n\n  \033[1;34m🛠️ [Operations]\033[0m\n  \033[1;32my / x / p\033[0m           Copy / Cut / Paste\n  \033[1;32md\033[0m                   Delete (Trash)\n  \033[1;32mr\033[0m                   Rename\n  \033[1;32ma\033[0m                   Create new file\n  \033[1;32m.\033[0m                   Toggle hidden files\n\n  \033[1;34m🔍 [Selection & Search]\033[0m\n  \033[1;32mv\033[0m                   Visual selection mode\n  \033[1;32mSpace\033[0m               Toggle selection\n  \033[1;32mf\033[0m                   Filter (Search) files\n  \033[1;32m/\033[0m                   Find within results\n\n  \033[1;34m🚪 [Exit]\033[0m\n  \033[1;32mq\033[0m                   Quit Yazi\n  \033[1;32mQ\033[0m                   Quit and keep current directory\n\n" | ${pkgs.lolcat}/bin/lolcat
    '')
  ];

  # [Gemini CLI Settings]
  home.sessionVariables = {
    GOOGLE_CLOUD_PROJECT = "gemini-cli-vertex-ai-493207";
    GOOGLE_CLOUD_LOCATION = "global"; # 서울 리전
    GOOGLE_APPLICATION_CREDENTIALS = "/home/yongminari/.config/gcloud/application_default_credentials.json";
    GOOGLE_GENAI_USE_VERTEXAI = "True";
  };

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

    yazi_shortcuts = "yazi-cheat";
    hypr_shortcuts = "hypr-cheat";
  };
}

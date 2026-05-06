{ config, pkgs, inputs, ... }:

{
  # [사용자 정보]
  home.username = "yongminari";
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/yongminari" else "/home/yongminari";
  home.stateVersion = "25.11"; 

  # [모듈 로드] 기능별 파일들을 여기서 불러옴
  imports = [
    (if builtins.pathExists ./local.nix then ./local.nix else {})
    
    # [1. core] 필수 설정 및 CLI
    ./modules/core/system-utils.nix
    ./modules/core/theme.nix
    ./modules/core/fonts.nix
    ./modules/core/shell/utils.nix
    ./modules/core/shell/welcome.nix
    ./modules/core/shell/bash.nix
    ./modules/core/shell/zsh.nix
    ./modules/core/shell/nushell.nix
    ./modules/core/shell/zellij.nix

    # [2. dev] 개발 환경
    ./modules/dev/git.nix
    ./modules/dev/dev-tools.nix
    ./modules/dev/neovim.nix

    # [3. desktop] UI 및 데스크탑 앱
    ./modules/desktop/niri
    ./modules/desktop/hyprland.nix
    ./modules/desktop/hyprlock.nix
    ./modules/desktop/hypridle.nix
    ./modules/desktop/ghostty.nix
    ./modules/desktop/gui-apps.nix
    ./modules/desktop/swappy.nix

    # [4. services] 백그라운드 서비스
    ./modules/services/noctalia.nix
    ./modules/services/rclone.nix
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

  # --- [Global Session Variables] ---
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Wayland 호환성 (Chromium/Electron 등)
    TERMINAL = "ghostty"; # 기본 터미널 설정

    # [Gemini CLI Settings]
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

    yazi_shortcuts = "yazi-cheat";
    hypr_shortcuts = "hypr-cheat";
  };
}

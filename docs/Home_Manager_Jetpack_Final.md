# Nix Home Manager Ultimate Setup (Jetpack Edition)

## 1. 개요

이 문서는 Nix Home Manager를 사용하여 리눅스 개발 환경을 구축하는 최종 가이드이다.
Native Linux(Ubuntu 등)와 WSL 환경을 하나의 통합된 코드베이스로 관리하며, Starship(Jetpack) 테마와 Zellij/Neovim 생산성 도구가 완벽하게 통합되어 있다.

**주요 기능:**
- **Core:** Nix Flakes + Home Manager (Modular Structure)
- **Shell:** Zsh (Main) + **Nushell (Experimental)** + Starship (Jetpack) + Eza + Zoxide + Bat + FZF + **Direnv** + **fnm (Node Version Manager)**
- **Editor:** Neovim (Tokyonight, LSP, Treesitter, Telescope, Neo-tree, oil.nvim, etc.)
- **Terminal:** Ghostty (GPU 가속, Nix 통합 관리)
- **Multiplexer:** Zellij (Modern Rust-based Terminal Workspace, Prefix Ctrl+g, Modern UI)
- **Auto-Install:** Gemini CLI, Tree-sitter CLI (via Nix)
- **Window Manager:** Hyprland (Wayland-native TWM, 자동 감지 모니터 설정, 3계층 단축키 전략)
- **App Launcher:** Wofi (GTK 기반 안정적인 런처, CSS 테마 지원)
- **Cloud Storage:** rclone mount (Google Drive, OneDrive)
- **GPU Acceleration:** nix-gui-run (AMD/Intel/Nvidia 자동 감지 래퍼)

## 2. 필수 사전 준비 (Manual Steps)

### 2.1 Nix 설치

설치 방식은 시스템 환경에 따라 두 가지 중 하나를 선택한다.

#### 방법 A: Determinate Systems 설치 (권장 - RedHat, Fedora, 최신 리눅스)
RedHat 계열의 SELinux 및 systemd 이슈를 해결한 현대적인 설치 방식이다. **Flakes가 기본으로 활성화**되어 있어 추가 설정이 거의 필요 없다.
```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

#### 방법 B: 공식 설치 스크립트 (Legacy - Ubuntu, WSL 등)
전통적인 멀티 유저 설치 방식이다.
```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

### 2.2 Experimental Features 활성화 (방법 B 사용 시 필수)
공식 설치 스크립트(방법 B)를 사용한 경우, Flakes 기능을 사용하기 위해 필수적으로 수행해야 한다. (방법 A는 생략 가능)
```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

### 2.3 Hyprland 세션 등록 및 자동 관리 (Native Linux 전용)
Nix로 설치한 Hyprland를 시스템 로그인 화면(GDM)에 등록하고, 이후 설정을 Nix로 자동 업데이트하기 위해 심볼릭 링크 방식을 사용한다.

1. **Home Manager 적용:**
   `hmsx` 명령어로 설정을 적용하면 `~/.local/share/wayland-sessions/hyprland-nix.desktop` 파일이 사용자 정보에 맞춰 자동 생성된다.

2. **파일 복사 (sudo 권한 필요):**
   Nix가 생성한 파일을 시스템 세션 폴더에 복사한다.
   ```bash
   sudo cp ~/.local/share/wayland-sessions/hyprland-nix.desktop /usr/share/wayland-sessions/
   ```

3. **로그아웃 후 확인:** 로그인 화면 우측 하단 톱니바퀴 아이콘에서 **Hyprland (Nix)**를 선택하여 진입한다.

### 2.4 한글 입력기 (IBus) 설정
Hyprland 환경에서 한글을 입력하기 위해 IBus를 사용한다. 최초 1회 수동 설정이 필요하다.

1. **설정 도구 실행:** `ibus-setup` 실행 후 'Korean - Hangul' 추가.
2. **단축키 설정:** 'Preferences'에서 한영 전환 키(예: Shift+Space) 등록.

## 3. 디렉토리 구조

```text
~/home_env_dotfiles
├── flake.nix             # [Entry] 통합 설정 엔트리
├── nix
│   ├── home.nix          # [Main] 모듈 로더 및 기본 설정
│   └── modules           # 기능별 세부 설정 모듈
│       ├── git.nix       # Git 사용자 설정
│       ├── neovim.nix    # Neovim 플러그인 및 설정
│       ├── packages.nix  # 시스템 패키지 & 설치 스크립트
│       ├── shell.nix     # Zsh, Nushell, Starship, Alias, Direnv
│       ├── starship.toml # Starship 테마 설정 (Jetpack)
│       ├── zellij.nix    # Zellij 옵션 및 키바인딩
│       ├── hyprland.nix  # Hyprland TWM 및 자동화 단축키
│       ├── wofi.nix      # Wofi 런처 및 테마 설정
│       └── gui-utils.nix # GPU 래퍼(nix-gui-run) 설정
└── .gitignore
```

## 4. 파일별 상세 코드 (핵심 모듈)

### 4.1 ~/home_env_dotfiles/nix/modules/hyprland.nix
Hyprland의 핵심 설정 파일이다.

```nix
{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = [ ",preferred,auto,1" ];
      "$mainMod" = "SUPER";

      exec-once = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "ibus-daemon -drx"
      ];

      env = [
        "XDG_CURRENT_DESKTOP, Hyprland"
        "XDG_SESSION_TYPE, wayland"
        "XDG_SESSION_DESKTOP, Hyprland"
        "XMODIFIERS, @im=ibus"
        "GTK_IM_MODULE, ibus"
        "QT_IM_MODULE, ibus"
        "IBUS_COMPONENT_PATH, ${config.home.homeDirectory}/.nix-profile/share/ibus/component"
        "XDG_DATA_DIRS, $HOME/.nix-profile/share:/usr/local/share:/usr/share:$XDG_DATA_DIRS"
      ];

      input = {
        kb_layout = "us";
        kb_options = "ctrl:nocaps";
        touchpad.natural_scroll = true;
      };

      bind = [
        "$mainMod, Return, exec, ghostty"
        "$mainMod, R, exec, pkill wofi || nix-gui-run wofi --show drun"
        "$mainMod, W, exec, google-chrome-stable --new-window https://slack.com https://github.com https://gmail.com"
        "$mainMod, F, fullscreen, 0"
        "$mainMod, Q, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, V, togglefloating,"
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"

        # Focus & Monitor
        "$mainMod, h, movefocus, l"
        "$mainMod, l, movefocus, r"
        "$mainMod, k, movefocus, u"
        "$mainMod, j, movefocus, d"
        "$mainMod, comma, focusmonitor, l"
        "$mainMod, period, focusmonitor, r"

        # Window Move & Resize
        "$mainMod SHIFT, h, movewindow, l"
        "$mainMod SHIFT, l, movewindow, r"
        "$mainMod ALT, h, resizeactive, -40 0"
        "$mainMod ALT, l, resizeactive, 40 0"

        # Workspaces 1-10
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      windowrule = [
        "match:title (.*Slack.*), workspace 2"
        "match:class (ghostty), workspace 1"
      ];
    };
  };

  # Declarative Hyprland Session for GDM
  home.file.\".local/share/wayland-sessions/hyprland-nix.desktop\".text = ''
    [Desktop Entry]
    Name=Hyprland (Nix)
    Exec=${config.home.homeDirectory}/.nix-profile/bin/nix-gui-run ${config.home.homeDirectory}/.nix-profile/bin/start-hyprland
    Type=Application
    DesktopNames=Hyprland
  '';
}
```

### 4.2 ~/home_env_dotfiles/nix/modules/gui-utils.nix
GPU 자동 감지 래퍼 스크립트 설정이다.

```nix
{ config, pkgs, inputs, ... }:

let
  nix-gui-run = pkgs.writeShellScriptBin "nix-gui-run" ''
    if command -v nvidia-smi &>/dev/null; then
      if command -v nixGLNvidia &>/dev/null; then
        exec nixGLNvidia "$@"
      else
        exec nixGLIntel "$@"
      fi
    else
      exec nixGLIntel "$@"
    fi
  '';
in
{
  home.packages = [ nix-gui-run ];
}
```

## 5. 설치 및 적용

```bash
# 1. 변경된 파일 Git 인식
git add .

# 2. Home Manager 적용
home-manager switch --flake .#yongminari-x86-linux -b backup
```

## 6. 트러블슈팅

- **Ghostty 실행 에러:** 직접 설치한 Ghostty와 충돌이 날 수 있으므로 `env -i` 옵션을 사용하거나 Nix 버전 Ghostty를 사용한다.
- **한글 입력:** `hypr_shortcuts`를 통해 단축키를 확인하고 `ibus-setup`을 완료한다.
- **패키지 업데이트:** `nix flake update` 후 `hmsx`를 실행한다.

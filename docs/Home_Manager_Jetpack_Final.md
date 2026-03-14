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
└── .gitignore
```

## 4. 파일별 상세 코드 (핵심 모듈)

### 4.7 ~/home_env_dotfiles/nix/modules/hyprland.nix
Hyprland TWM 설정 파일(`hyprland.conf`)을 생성한다. 엔진은 `apt`로 관리하므로 설정 관리에만 집중한다.

```nix
{ config, pkgs, ... }:

{
  xdg.configFile."hypr/hyprland.conf".text = ''
    # Monitor & Input
    monitor=,preferred,auto,1
    input {
        kb_layout = us
        kb_options = ctrl:nocaps
        touchpad { natural_scroll = true }
    }

    # Keybindings
    $mainMod = SUPER
    bind = $mainMod, Return, exec, ghostty
    bind = $mainMod, R, exec, pkill wofi || wofi --show drun
    bind = $mainMod, W, exec, google-chrome-stable --new-window https://slack.com https://github.com https://gmail.com
    bind = $mainMod, Q, killactive,
    bind = $mainMod, M, exit,
    # ... (생략 없이 실제 파일은 모든 hjkl 이동 및 워크스페이스 단축키 포함)
  '';
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

# Nix Home Manager Ultimate Setup (Jetpack Edition)

## 1. 개요

이 문서는 Nix Home Manager를 사용하여 리눅스 개발 환경을 구축하는 최종 가이드이다.
Ubuntu 24.04 환경에서 **Sway(TWM)**와 **Rofi(런처)**, **Waybar(상단 바)**를 중심으로 가장 안정적이고 표준화된 개발 환경을 구축한다.

**주요 기능:**
- **Core:** Nix Flakes + Home Manager (Modular Structure)
- **TWM Engine:** Sway (Wayland 기반, apt 설치로 안정성 확보)
- **Shell:** Zsh + Nushell + Bash (Centralized Aliases 통합 관리)
- **Editor:** Neovim (Modular Lua Setup: options, keymaps, plugins, utils)
- **Terminal:** Ghostty (Nix 통합 관리)
- **App Launcher:** Rofi (Modern Dracula Theme)
- **Multiplexer:** Zellij (Standard Module, Theme support)

## 2. 필수 사전 준비 (Manual Steps)

### 2.1 Nix 설치
```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### 2.2 TWM 엔진 설치 (Ubuntu 24.04 필수 단계)
Ubuntu 24.04에서 그래픽 드라이버 호환성과 시스템 안정성을 위해 핵심 엔진은 `apt`로 설치한다.
```bash
sudo apt update
sudo apt install sway rofi waybar xdg-desktop-portal-wlr xdg-desktop-portal-gtk swaylock swayidle
```

### 2.3 한글 입력기 (Fcitx5) 설정
안정적인 한글 입력을 위해 IBus 대신 Fcitx5를 사용한다. Ubuntu 24.04와 Nix 환경의 충돌을 방지하기 위해 시스템 패키지(`apt`)로 설치한다.

1. **기본 IBus 제거 (충돌 방지)**
   ```bash
   sudo apt purge ibus ibus-hangul
   sudo apt autoremove
   ```

2. **Fcitx5 설치**
   ```bash
   sudo apt install fcitx5 fcitx5-hangul fcitx5-config-qt fcitx5-module-lua
   ```

3. **시스템 기본 입력기 설정**
   ```bash
   im-config -n fcitx5
   ```

4. **데스크탑 자동 실행 등록 (GNOME/Wayland)**
   ```bash
   mkdir -p ~/.config/autostart
   cp /usr/share/applications/org.fcitx.Fcitx5.desktop ~/.config/autostart/
   ```

5. **한글 엔진 설정**
   - `fcitx5-config-qt` 실행 후 'Hangul' 추가.
   - 'Hangul' 설정에서 'Commit with space' 옵션 해제 (공백 버그 방지).

## 3. 디렉토리 구조

```text
~/home_env_dotfiles
├── flake.nix             # [Entry] 통합 설정 엔트리 및 시스템별 설정
├── nix
│   ├── home.nix          # [Main] 모듈 로더 및 중앙 집중형 에일리어스 관리
│   └── modules           # 기능별 세부 설정 모듈
│       ├── shell.nix     # 쉘 환경 브릿지
│       ├── neovim.nix    # Neovim 모듈 로더
│       ├── neovim/       # Neovim 기능별 Lua 설정 (Modular)
│       ├── sway.nix      # Sway TWM 및 단축키 자동화
│       ├── rofi.nix      # Rofi 런처 테마 및 스타일
│       ├── waybar.nix    # Waybar 상단 바 설정 및 스타일
│       ├── packages.nix  # 시스템 패키지 카테고리별 관리
│       └── git.nix       # Git 사용자 정보 및 표준 설정
└── .gitignore
```

## 4. 핵심 모듈 설명 (Sway & Rofi)

### 4.1 ~/home_env_dotfiles/nix/modules/sway.nix
Sway 설정 파일(`~/.config/sway/config`)을 생성한다. `apt`로 설치된 Sway 엔진이 이 설정을 읽어 구동된다.

```nix
{ config, pkgs, ... }:

{
  xdg.configFile."sway/config".text = ''
    # Variables & Keybindings
    set $mod Mod4
    set $term ghostty
    set $menu rofi -show drun

    bindsym $mod+Return exec $term
    bindsym $mod+d exec $menu
    bindsym $mod+q kill
    # ... (생략 없이 실제 파일은 모든 hjkl 이동 및 워크스페이스 단축키 포함)
    
    # Waybar 통합
    bar { swaybar_command waybar }
  '';
}
```

## 5. 설치 및 적용

```bash
# 1. 변경된 파일 Git 인식
git add .

# 2. Home Manager 적용
hmsx
```

---

**Note:** 본 설정은 Ubuntu 24.04 환경에서 시스템 엔진(`apt`)과 사용자 설정(`Nix`)의 조화를 통해 최상의 안정성을 제공하도록 최적화되었습니다.

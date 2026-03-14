# Nix Home Manager Ultimate Setup (Jetpack Edition)

## 1. 개요

이 문서는 Nix Home Manager를 사용하여 리눅스 개발 환경을 구축하는 최종 가이드이다.
Native Linux(Ubuntu 등)와 WSL 환경을 하나의 통합된 코드베이스로 관리하며, Starship(Jetpack) 테마와 Zellij/Neovim 생산성 도구가 완벽하게 통합되어 있다.

**주요 기능:**
- **Core:** Nix Flakes + Home Manager (Modular & Standardized Structure)
- **Shell:** Zsh (Main) + Nushell + Bash + Starship (Jetpack) + **Centralized Aliases**
- **Editor:** Neovim (Modular Lua Setup: options, keymaps, plugins, utils)
- **Terminal:** Ghostty (GPU 가속, Home Manager 표준 모듈 관리)
- **Multiplexer:** Zellij (Standard Module, Prefix Ctrl+g/Ctrl+a, Theme support)
- **Node.js:** fnm (Node Version Manager) 자동 구성
- **Cloud Storage:** rclone mount (Google Drive, OneDrive) 자동화
- **Window Manager:** Hyprland (Wayland-native TWM) & Wofi Launcher

## 2. 필수 사전 준비 (Manual Steps)

### 2.1 Nix 설치

시스템 환경에 따라 최적의 설치 방식을 선택한다.

#### 방법 A: Determinate Systems 설치 (권장)
```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

#### 방법 B: 공식 설치 스크립트 (Legacy)
```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

### 2.2 Flakes 활성화 (방법 B 사용 시 필수)
```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

## 3. 디렉토리 구조

```text
~/home_env_dotfiles
├── flake.nix             # [Entry] 통합 설정 엔트리 및 시스템별 설정
├── nix
│   ├── home.nix          # [Main] 모듈 로더 및 중앙 집중형 에일리어스 관리
│   └── modules           # 기능별 세부 설정 모듈
│       ├── shell.nix     # 쉘 환경 브릿지 (Zsh, Nushell, Bash)
│       ├── shell-utils.nix # 공통 CLI 도구(Starship, Eza, Zoxide 등)
│       ├── neovim.nix    # Neovim 모듈 로더 및 배포 설정
│       ├── neovim/       # Neovim 기능별 Lua 설정 (Modular)
│       │   └── lua/      # options, keymaps, plugins, utils 분리 관리
│       ├── zellij.nix    # Zellij 표준 모듈 및 커스텀 템플릿
│       ├── ghostty.nix   # Ghostty 표준 모듈 및 스타일 설정
│       ├── packages.nix  # 시스템 패키지 카테고리별 관리
│       ├── git.nix       # Git 사용자 정보 및 표준 설정
│       ├── hyprland.nix  # Hyprland TWM 및 단축키 자동화
│       └── wofi.nix      # Wofi 런처 테마 및 스타일
└── .gitignore
```

## 4. 핵심 모듈 설명 (Refactored)

### 4.1 중앙 집중형 에일리어스 (`nix/home.nix`)
모든 쉘(Zsh, Bash, Nushell)에서 공통으로 사용되는 에일리어스는 `home.shellAliases`를 통해 중앙에서 한 번만 정의한다. (`hms`, `ls`, `vi`, `zj` 등)

### 4.2 모듈형 Neovim 설정 (`nix/modules/neovim/`)
방대한 Lua 설정을 기능별로 분리하여 관리한다. `initLua`에서는 각 모듈을 `require`만 하며, 실제 파일들은 `xdg.configFile`을 통해 `~/.config/nvim/lua/` 경로에 안전하게 배포된다.

### 4.3 표준화된 도구 설정 (`git.nix`, `ghostty.nix`, `zellij.nix`)
텍스트 파일을 직접 쓰는 방식 대신 Home Manager의 공식 모듈(`programs.xxx.settings`)을 사용하여 선언적으로 관리한다.

## 5. 설치 및 적용

```bash
# 1. 변경된 파일 Git 인식 (Nix Flakes 필수 단계)
git add .

# 2. Home Manager 적용 (x86_64 Linux 기준)
hmsx
```

---

**Note:** 본 설정은 최신 Home Manager(Unstable) 표준을 따르며, 모든 모듈은 서로의 의존성을 존중하도록 설계되었습니다.

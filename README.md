# 🚀 Dotfiles (Nix Home Manager)

**yongminari**'s declarative development environment configuration managed by **Nix Home Manager**.
This setup supports both **Native Linux** and **WSL** with a single, unified configuration, ensuring a consistent and high-performance workflow.

## ✨ Features

- **⚡ Shell:** Zsh (Main) and **Nushell (Experimental)** optimized with **Starship (Jetpack Theme)**.
- **🛠️ Modern Core Utils:** Replaces legacy tools with modern Rust alternatives.
  - `ls` -> `eza` (Icons & Git status)
  - `cd` -> `zoxide` (Smarter navigation)
  - `cat` -> `bat` (Syntax highlighting)
  - `find` -> `fd` / `grep` -> `ripgrep`
  - `direnv` -> **`direnv` (Nix-direnv integrated)**
- **💻 Terminal Multiplexer:** **Zellij** (Modern Rust-based) pre-configured.
  - Auto-start on launch (except VS Code).
  - Prefix: `Ctrl + g` (Locked/Normal toggle).
  - Modern UI with Gruvbox theme and helpful status bars.
  - Seamless navigation and integration with Neovim.
- **📝 Editor:** **Neovim** (IDE-like setup).
  - Lazy loading, Telescope, Neo-tree, Treesitter, LSP (C++, Go, Node).
- **🤖 AI:** Auto-installation of `@google/gemini-cli`.
- **📦 Modular:** Clean file structure separated by function (`modules/*.nix`).

## 📂 Directory Structure

```text
~/home_env_dotfiles
├── flake.nix             # Entry point (Unified profile)
└── nix
    ├── home.nix          # Main loader
    └── modules
        ├── shell.nix     # Zsh, Starship, Aliases, Zellij autostart, Direnv
        ├── starship.toml # Jetpack theme config
        ├── neovim.nix    # Editor config
        ├── zellij.nix    # Modern Multiplexer config
        ├── packages.nix  # System packages & Installation scripts
        └── git.nix       # Git user config
```

## 🚀 Installation

### 1. Install Nix

Choose one of the following two installation methods depending on your system environment.

#### Method A: Determinate Systems Installer (Recommended - RedHat, Fedora, Modern Linux)
A modern installer that resolves SELinux and systemd issues in RedHat-based systems. **Flakes are enabled by default**.
```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

#### Method B: Official Install Script (Legacy - Ubuntu, WSL, etc.)
Traditional multi-user installation. Requires manual Flakes activation after installation.
```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

### 2. Enable Flakes (Required for Method B)
Only required if you used the official install script (Method B). (Skip if you used Method A).
```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

### 3. Clone & Setup

```bash
# Clone this repo to ~/home_env_dotfiles
git clone <YOUR_REPO_URL> ~/home_env_dotfiles
cd ~/home_env_dotfiles
```

### 4. Apply Configuration

```bash
# Apply for both Native Linux and WSL
nix run home-manager/master -- switch --flake .#yongminari -b backup
```

### 5. Node.js Setup (via fnm)

This configuration includes `fnm` for Node.js management. Install Node.js after the initial setup using the following commands.

```bash
fnm install --lts
fnm default lts-latest
```

### 5. Set Zsh as Default Shell (chsh)

Nix로 설치된 Zsh는 경로가 다르기 때문에 시스템이 기본 셸로 바로 인식하지 못할 수 있습니다. 다음 단계를 따라 전환하세요.

```bash
# 1. Nix Zsh 경로 확인
which zsh
# 보통 ~/.nix-profile/bin/zsh

# 2. 유효한 셸 목록에 추가 (Root 권한 필요)
sudo sh -c "echo $(which zsh) >> /etc/shells"

# 3. 기본 셸 변경
chsh -s $(which zsh)
```

## ⌨️ Cheat Sheet

| Command | Action | Alias |
| :--- | :--- | :--- |
| `hms` | Apply Nix configuration changes | `home-manager switch ...` |
| `ll` / `lt` | List files (Grid / Tree view) | `eza ...` |
| `zj` | Start Zellij session | - |
| `zj_shortcuts` | Show Zellij keybindings summary | - |
| `vi` / `vim` | Open Neovim | `nvim` |
| `Space + f` | Find files (Telescope) | - |
| `Space + g` | Live Grep (Telescope) | - |
| `Ctrl + n` | Toggle File Explorer | `Neotree` |
| `Ctrl + g` | Zellij Prefix (Lock/Unlock) | - |
| `Alt + h/j/k/l` | Navigate between Zellij panes | - |

## 🔄 Maintenance

### Update Packages & Configuration

Nix 및 Home Manager에 등록된 모든 패키지를 최신 버전으로 업데이트하려면 다음 명령어를 순서대로 실행하세요.

```bash
# 1. 패키지 레시피(flake.lock)를 최신 상태로 갱신
nix flake update

# 2. 업데이트된 내용 적용
hms
```

## 🗑️ Uninstallation

To completely remove the Nix environment, choose one of the following methods depending on your installation.

### If installed via Method A (Determinate Systems)
Use the dedicated uninstaller for the cleanest removal.
```bash
/nix/nix-installer uninstall
```

### If installed via Method B (Official Script) or for forced removal
Use the included uninstaller script. This script automatically handles shell restoration, service stopping, and `/nix` directory cleanup.
```bash
chmod +x uninstall-nix.sh
./uninstall-nix.sh
```

> **Note:** 스크립트 실행 후 시스템을 재부팅하거나 로그아웃 후 다시 로그인하여 환경 변수를 완전히 정리하는 것을 권장합니다.

---

**Note:** Ghostty configuration is managed, but the binary should be installed manually on Native Linux.

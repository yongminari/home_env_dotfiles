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
- **☁️ Cloud Storage:** **rclone** automated mounting.
  - Google Drive & OneDrive auto-mount via systemd.
  - Mount paths: `~/mnt/gdrive`, `~/mnt/onedrive`.
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

Since Zsh installed via Nix has a different path, the system may not recognize it as a default shell immediately. Follow these steps to switch.

```bash
# 1. Check Nix Zsh path
which zsh
# Usually ~/.nix-profile/bin/zsh

# 2. Add to valid shells list (Requires root)
sudo sh -c "echo $(which zsh) >> /etc/shells"

# 3. Change default shell
chsh -s $(which zsh)
```

### 6. Cloud Drive Setup (rclone)

Follow these steps to auto-mount Google Drive and OneDrive.

1. **Install FUSE3:** `sudo apt install fuse3 -y`
2. **Setup rclone:** Create remotes named `gdrive` and `onedrive` using the `rclone config` command.
3. **Enable Services:**
   ```bash
   systemctl --user daemon-reload
   systemctl --user enable --now rclone-mount-gdrive
   systemctl --user enable --now rclone-mount-onedrive
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

To update all packages registered in Nix and Home Manager to the latest version, run the following commands in order.

```bash
# 1. Update the package recipe (flake.lock)
nix flake update

# 2. Apply the updates
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

> **Note:** It is recommended to reboot the system or log out and log back in after running the script to fully clear environment variables.

---

**Note:** Ghostty configuration is managed, but the binary should be installed manually on Native Linux.

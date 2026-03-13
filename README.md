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
- **🪟 Window Manager:** **Hyprland** (Wayland-native TWM) with dual 4K monitor support and workspace automation.
- **🚀 App Launcher:** **Wofi** (GTK-based) for high-performance searching and utilities.
- **🤖 AI:** Auto-installation of `@google/gemini-cli`.
- **📦 Modular:** Clean file structure separated by function (`modules/*.nix`).

## 📂 Directory Structure

```text
~/home_env_dotfiles
├── flake.nix             # Entry point (Unified profile with Anyrun flake)
└── nix
    ├── home.nix          # Main loader
    └── modules
        ├── shell.nix     # Zsh, Starship, Aliases, Zellij autostart, Direnv
        ├── starship.toml # Jetpack theme config
        ├── neovim.nix    # Editor config
        ├── zellij.nix    # Modern Multiplexer config
        ├── packages.nix  # System packages & Installation scripts
        ├── git.nix       # Git user config
        ├── hyprland.nix  # Hyprland TWM configuration & Keybindings
        └── wofi.nix      # Wofi launcher & styles configuration
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

### 5. Hyprland Session Setup (Non-NixOS Systems)

If you are using Ubuntu or other non-NixOS distros, you must manually register the Hyprland session to your login manager (e.g., GDM).

1. Find the path of your Nix-installed Hyprland: `which Hyprland`
2. Create a session file: `sudo nano /usr/share/wayland-sessions/hyprland.desktop`
3. Paste the following configuration (replace `Exec` with your actual path):

```ini
[Desktop Entry]
Name=Hyprland (Nix)
Comment=An intelligent dynamic tiling Wayland compositor
Exec=/home/yongminari/.nix-profile/bin/nixGLIntel /home/yongminari/.nix-profile/bin/Hyprland
Type=Application
DesktopNames=Hyprland
```

> **Note:** Use `nixGLIntel` (or your specific GPU variant) in the `Exec` line if you experience a black screen or crashes on Ubuntu.

4. **Logout** and select **"Hyprland (Nix)"** from the gear icon menu at the login screen.

### 5. Korean Input (IBus) Setup

This configuration uses **IBus** for Korean input. A one-time setup is required after logging into Hyprland.

1. Open a terminal and run `ibus-setup`.
2. Go to the **Input Method** tab, click **Add**, search for **Korean - Hangul**, and add it.
3. Select **Korean - Hangul** and click **Preferences** to set your toggle key (e.g., `Shift+Space`).
4. Restart any open applications to apply the input method settings.

### 6. Node.js Setup (via fnm)

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

### 🪟 Hyprland & Wofi (TWM)

Keybindings available within a Hyprland session (Main Mod: `Super` / Windows key).

| Shortcut | Action |
| :--- | :--- |
| **`Super + Enter`** | Launch **Ghostty** terminal |
| **`Super + R`** | Launch **Wofi** (App launcher / Runner) |
| **`Super + W`** | **Work Automation (Pababak)** - Open Slack, GitHub, and Gmail in Chrome |
| **`Super + Q`** | Close active window (Kill) |
| **`Super + M`** | Exit Hyprland (Logout) |
| **`Super + V`** | Toggle Floating mode |
| **`Super + h/j/k/l`** | Move focus Left/Down/Up/Right (Vim-style) |
| **`Super + 1 ~ 5`** | Switch to workspace 1-5 |
| **`Super + Shift + 1 ~ 5`** | Move window to workspace 1-5 |
| **`Super + P`** / **`J`** | Toggle Pseudo mode / Split orientation |

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

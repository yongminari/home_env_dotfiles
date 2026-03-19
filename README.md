# 🚀 Dotfiles (Nix Home Manager)

**yongminari**'s declarative development environment configuration managed by **Nix Home Manager**.
This setup supports both **Native Linux** and **WSL** with a single, unified configuration, ensuring a consistent and high-performance workflow.

## ✨ Features

- **⚡ Shell:** Zsh (Main), **Nushell (Experimental)**, and Bash optimized with **Starship (Jetpack Theme)**.
- **🛠️ Modern Core Utils:** Replaces legacy tools with modern Rust alternatives.
  - `ls` -> `eza`, `cd` -> `zoxide`, `cat` -> `bat`, `find` -> `fd`, `grep` -> `ripgrep`.
  - `direnv` -> **`direnv` (Nix-direnv integrated)**.
- **💻 Terminal Multiplexer:** **Zellij** managed via standard Nix modules.
- **📝 Editor:** **Neovim** (Modern Modular Setup).
  - Fully modular Lua configuration split by function (`options`, `keymaps`, `plugins`, `utils`).
- **🪟 Window Manager:** **Sway** (Wayland-native TWM) - Reliable and standardized for Ubuntu 24.04.
- **🚀 App Launcher:** **Rofi** (Wayland-native) with modern Dracula dark theme.
- **📊 Status Bar:** **Waybar** with hardware monitors (CPU, Memory, Network).
- **📦 Modular & Standardized:** Clean file structure using the latest Home Manager patterns.

## 📂 Directory Structure

```text
~/home_env_dotfiles
├── flake.nix             # Entry point (System-specific configurations)
└── nix
    ├── home.nix          # Main loader & Centralized Shell Aliases
    └── modules
        ├── shell.nix     # Shell configuration bridge
        ├── neovim.nix    # Neovim module loader
        ├── neovim/       # Modular Lua configurations
        ├── zellij.nix    # Multiplexer config
        ├── sway.nix      # Sway TWM configuration & Keybindings
        ├── rofi.nix      # Rofi launcher & styles configuration
        ├── waybar.nix    # Status bar layout & styles
        ├── packages.nix  # Categorized system packages
        └── git.nix       # Standardized Git user config
```

## 🚀 Installation (Ubuntu 24.04)

### 1. Install Engines (via apt)
For stability and driver compatibility on Ubuntu 24.04, the core engines and input method must be installed via the system package manager.
```bash
# Core TWM Utils
sudo apt update
sudo apt install sway rofi waybar xdg-desktop-portal-wlr xdg-desktop-portal-gtk swaylock swayidle

# Korean Input Method (Fcitx5)
# Fcitx5 is recommended for the Sway environment.
sudo apt install fcitx5 fcitx5-hangul fcitx5-config-qt
mkdir -p ~/.config/autostart
cp /usr/share/applications/org.fcitx.Fcitx5.desktop ~/.config/autostart/
```

### 2. Install Nix & Clone Repo
```bash
# Install Nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Clone this repo
git clone <YOUR_REPO_URL> ~/home_env_dotfiles
cd ~/home_env_dotfiles
```

### 3. Apply Configuration
```bash
# Apply Nix Home Manager setup
hmsx
```

## 🛠️ Post-Installation (Essential)

### 1. Set Default Shell to Zsh
Since Nix doesn't modify system files like `/etc/passwd`, you must manually set Zsh as your default shell.
```bash
# 1. Register Nix Zsh to valid shells list
echo $(which zsh) | sudo tee -a /etc/shells

# 2. Change your default shell
chsh -s $(which zsh)
```
*Note: You may need to log out and log back in for the changes to take effect.*

### 2. Desktop Launcher Support (Ghostty)
If Ghostty doesn't appear in your GNOME/Sway app launcher after installation:
- The configuration already includes a symlink to `~/.local/share/applications/`.
- If it still doesn't show up, run `hmsx` again and restart your session.

### 3. Troubleshooting: Korean Input (Sway)
- **First Window Issue:** In Sway, the very first Ghostty window might not accept Korean input.
- **Solution:** Simply open a **second Ghostty window** (`Super + Enter`), and Korean input (Fcitx5) will work perfectly in all subsequent windows. (This is a known timing issue between GLFW and DBus).

## ⌨️ Cheat Sheet (Sway TWM)

| Shortcut | Action |
| :--- | :--- |
| **`Super + Enter`** | Launch **Ghostty** terminal |
| **`Super + D`** | Launch **Rofi** (App runner) |
| **`Super + Q`** | Close active window (Kill) |
| **`Super + F`** | Toggle Fullscreen |
| **`Super + V`** | Toggle Floating mode |
| **`Super + h/j/k/l`** | Move focus (Left, Down, Up, Right) |
| **`Super + Shift + h/j/k/l`** | Move window position |
| **`Super + 1 ~ 0`** | Switch to workspace 1-10 |
| **`Super + Shift + E`** | Exit Sway (Logout) |

---

**Note:** The binary engines (Sway, Rofi, Waybar) are managed by `apt` for system-level stability, while all configurations are managed declaratively via Nix Home Manager.

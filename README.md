# 🚀 Dotfiles (Nix Home Manager)

**yongminari**'s declarative development environment configuration managed by **Nix Home Manager**.
This setup supports both **Native Linux** and **WSL** with a single, unified configuration, ensuring a consistent and high-performance workflow.

## ✨ Features

- **⚡ Shell:** Zsh (Main), **Nushell (Experimental)**, and Bash optimized with **Starship (Jetpack Theme)**.
- **🛠️ Modern Core Utils:** Replaces legacy tools with modern Rust alternatives.
  - `ls` -> `eza`, `cd` -> `zoxide`, `cat` -> `bat`, `find` -> `fd`, `grep` -> `ripgrep`.
  - `direnv` -> **`direnv` (Nix-direnv integrated)**.
  - **TUI File Manager:** **`yazi`** (Fast, Wayland-native image previews).
  - **Shell History:** **`atuin`** (Magical database-driven history search).
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

# Korean Input Method (Fcitx5 for Sway)
# Fcitx5 is recommended specifically for the Sway environment.
# Note: In GNOME, IBus is used by default. If Fcitx5 starts in GNOME after installation,
# you may need to disable it in "Startup Applications".
sudo apt install fcitx5 fcitx5-hangul fcitx5-config-qt
```

### 2. Install Nix & Clone Repo
```bash
# Install Nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Clone this repo
git clone <YOUR_REPO_URL> ~/home_env_dotfiles
cd ~/home_env_dotfiles
```

### 3. Apply Configuration (First Time)
Since `home-manager` isn't installed yet, use `nix run` to apply the configuration for the first time. This will automatically pull the necessary tools and apply your setup.

```bash
# First-time application (for x86_64 Linux/WSL)
# This command will enable flakes and apply the configuration.
nix run home-manager/master -- switch --flake .#yongminari-x86-linux

# For other architectures:
# nix run home-manager/master -- switch --flake .#yongminari-aarch-linux
# nix run home-manager/master -- switch --flake .#yongminari-aarch-mac
```

*Note: If you get an error about `experimental-features`, you might need to enable flakes:*
`mkdir -p ~/.config/nix && echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf`

### 4. Use Management Aliases (After Installation)
Once the first application is successful, your shell will have the following aliases pre-configured. You can now use them for easier updates.

These aliases are automatically configured in your shell to make managing your Home Manager environment easier. They use `$(whoami)` to dynamically detect your username, so they work on any account that matches a configuration in `flake.nix`.

| Alias | Full Command | Description |
| :--- | :--- | :--- |
| **`hms`** | `home-manager switch --flake ...#$(whoami)` | Default switch (x86_64 Linux) |
| **`hmsx`** | `home-manager switch --flake ...#$(whoami)-x86-linux` | **x86_64 Linux** (WSL/Native) |
| **`hmsa`** | `home-manager switch --flake ...#$(whoami)-aarch-linux` | **AArch64 Linux** |
| **`hmsm`** | `home-manager switch --flake ...#$(whoami)-aarch-mac` | **Apple Silicon Mac** |

## ⚙️ Post-Installation (Essential)

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

### 4. Sync Shell History (Atuin)
Atuin uses its own database. To import your old shell history (e.g., from `~/.zsh_history`) after the first installation, run:
```bash
atuin import auto
```

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

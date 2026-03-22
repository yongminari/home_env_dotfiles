# 🚀 Dotfiles (Nix Home Manager + Hyprland)

**yongminari**'s declarative development environment configuration managed by **Nix Home Manager**.
This setup supports both **Native Linux** and **WSL** with a single, unified configuration, ensuring a consistent and high-performance workflow.

## ✨ Features

- **🪟 Window Manager:** **Hyprland** (Wayland-native) - Hardware-accelerated with rich animations and blur effects.
- **⚡ Shell:** Zsh (Main), **Nushell (Experimental)**, and Bash optimized with **Starship (Jetpack Theme)**.
- **🛠️ Modern Core Utils:** Replaces legacy tools with modern Rust alternatives.
  - `ls` -> `eza`, `cd` -> `zoxide`, `cat` -> `bat`, `find` -> `fd`, `grep` -> `ripgrep`.
  - `direnv` -> **`direnv` (Nix-direnv integrated)**.
  - **TUI File Manager:** **`yazi`** (Fast, Wayland-native image previews).
  - **Shell History:** **`atuin`** (Magical database-driven history search).
- **💻 Terminal Multiplexer:** **Zellij** managed via standard Nix modules.
- **📝 Editor:** **Neovim** (Modern Modular Setup).
  - Fully modular Lua configuration split by function (`options`, `keymaps`, `plugins`, `utils`).
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
        ├── hyprland.nix  # Hyprland core configuration & Keybindings
        ├── waybar.nix    # Status bar layout & styles
        ├── packages.nix  # Categorized system packages
        ├── shell.nix     # Shell configuration bridge
        ├── neovim.nix    # Neovim module loader
        ├── neovim/       # Modular Lua configurations
        ├── rofi.nix      # Rofi launcher & styles configuration
        ├── git.nix       # Standardized Git user config
        └── ...
```

## 🚀 Installation (Ubuntu 24.04)

### 1. Install Hyprland Engine (via PPA)
For driver compatibility and the latest features, Hyprland must be installed via the community PPA.
```bash
# Add the Hyprland PPA
sudo add-apt-repository ppa:cppiber/hyprland
sudo apt update

# Install Hyprland and Portals
sudo apt install hyprland xdg-desktop-portal-hyprland
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
Since `home-manager` isn't installed yet, use `nix run` to apply the configuration for the first time.
```bash
# First-time application (for x86_64 Linux/WSL)
nix run home-manager/master -- switch --flake .#yongminari-x86-linux
```

### 4. Korean Input Method (Fcitx5)
Fcitx5 is recommended for the Hyprland environment.
```bash
sudo apt install fcitx5 fcitx5-hangul fcitx5-config-qt
```

## 🛠️ Management Aliases

These aliases are automatically configured in your shell to make managing your Home Manager environment easier.

| Alias | Full Command | Description |
| :--- | :--- | :--- |
| **`hms`** | `home-manager switch --flake ...#$(whoami)` | Default switch (x86_64 Linux) |
| **`hmsx`** | `home-manager switch --flake ...#$(whoami)-x86-linux` | **x86_64 Linux** (WSL/Native) |
| **`hmsa`** | `home-manager switch --flake ...#$(whoami)-aarch-linux` | **AArch64 Linux** |
| **`hmsm`** | `home-manager switch --flake ...#$(whoami)-aarch-mac` | **Apple Silicon Mac** |

## ⚙️ Post-Installation (Essential)

### 1. Set Default Shell to Zsh
```bash
echo $(which zsh) | sudo tee -a /etc/shells
chsh -s $(which zsh)
```

### 2. Desktop Launcher Support (Ghostty)
If Ghostty doesn't appear in your app launcher:
- The configuration already includes a symlink to `~/.local/share/applications/`.
- If it still doesn't show up, run `hmsx` again and restart your session.

### 3. Troubleshooting: Hyprland Startup Issues
If Waybar or Rofi doesn't start automatically on a fresh boot:
- The current configuration uses **absolute Nix store paths** to ensure binaries are found even before the Nix profile is loaded.
- Check `nix/modules/hyprland.nix` for `exec-once` path definitions.

### 4. Sync Shell History (Atuin)
```bash
atuin import auto
```

## ⌨️ Cheat Sheet (Hyprland)

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
| **`Super + Shift + E`** | Exit Hyprland (Logout) |
| **`Super + R`** | Enter Resize Mode |

---

**Note:** The binary engine (Hyprland) is managed by `PPA` for driver stability, while all configurations are managed declaratively via Nix Home Manager.

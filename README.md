# 🚀 Dotfiles (Nix Home Manager)

**yongminari**'s declarative development environment configuration managed by **Nix Home Manager**.
This setup supports both **Native Linux** and **WSL** with a single, unified configuration, ensuring a consistent and high-performance workflow.

## ✨ Features

- **⚡ Shell:** Zsh (Main), **Nushell (Experimental)**, and Bash optimized with **Starship (Jetpack Theme)**.
- **🛠️ Modern Core Utils:** Replaces legacy tools with modern Rust alternatives.
  - `ls` -> `eza` (Icons & Git status)
  - `cd` -> `zoxide` (Smarter navigation)
  - `cat` -> `bat` (Syntax highlighting)
  - `find` -> `fd` / `grep` -> `ripgrep`
  - `direnv` -> **`direnv` (Nix-direnv integrated)**
- **💻 Terminal Multiplexer:** **Zellij** (Modern Rust-based) managed via standard Nix modules.
  - Auto-start on launch (except VS Code).
  - Prefix: `Ctrl + g` (Local) / `Ctrl + a` (Remote/Docker) toggle.
  - Modern UI with multi-theme support (Gruvbox/Catppuccin).
- **📝 Editor:** **Neovim** (Modern Modular Setup).
  - Fully modular Lua configuration split by function (`options`, `keymaps`, `plugins`, `utils`).
  - Integrated LSP (Go, Nix, C++), Treesitter, Telescope, and Obsidian.nvim.
- **☁️ Cloud Storage:** **rclone** automated mounting via systemd services.
  - Google Drive & OneDrive auto-mount via systemd.
  - Mount paths: `~/mnt/gdrive`, `~/mnt/onedrive`.
- **🪟 Window Manager:** **Hyprland** (Wayland-native TWM) with dual 4K monitor support and workspace automation.
- **🚀 App Launcher:** **Wofi** with modern translucent dark theme.
- **🤖 AI:** Auto-installation of `@google/gemini-cli`.
- **📦 Modular & Standardized:** Clean file structure using the latest Home Manager patterns and centralized shell aliases.

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
        │   └── lua/      # options.lua, keymaps.lua, plugins.lua, utils.lua
        ├── zellij.nix    # Multiplexer config with remote/local templates
        ├── ghostty.nix   # GPU-accelerated terminal config
        ├── packages.nix  # Categorized system packages
        ├── git.nix       # Standardized Git user config
        ├── hyprland.nix  # Hyprland TWM configuration & Keybindings
        └── wofi.nix      # Wofi launcher & styles configuration
```

## 🚀 Installation

### 1. Install Nix

Choose one of the following two installation methods depending on your system environment.

#### Method A: Determinate Systems Installer (Recommended)
```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

#### Method B: Official Install Script (Legacy)
```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

### 2. Enable Flakes (Required for Method B)
```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

### 3. Clone & Setup

```bash
git clone <YOUR_REPO_URL> ~/home_env_dotfiles
cd ~/home_env_dotfiles
```

### 4. Apply Configuration

```bash
# General switch (x86_64 Linux)
hmsx
```

## ⌨️ Cheat Sheet

| Command | Action | Alias |
| :--- | :--- | :--- |
| `hms` | Apply Nix configuration | `home-manager switch ...` |
| `hmsx` | Apply for x86_64 Linux | - |
| `ll` / `lt` | List files (Grid / Tree view) | `eza ...` |
| `zj` | Start Zellij session | - |
| `vi` / `vim` | Open Neovim | `nvim` |
| `Space + f` | Find files (Telescope) | - |
| `Ctrl + n` | Toggle File Explorer | `Neotree` |
| `Super + R` | Launch Wofi Runner | - |

---

**Note:** All components are managed declaratively via Nix Home Manager for maximum consistency across different environments.

# 🚀 Dotfiles (Nix Home Manager + Hyprland)

**yongminari**'s declarative development environment configuration managed by **Nix Home Manager**.
This setup supports both **Native Linux** and **WSL** with a single, unified configuration, ensuring a consistent and high-performance workflow.

## ✨ Features

- **🪟 Window Manager:** **Hyprland** (Wayland-native) - Hardware-accelerated with rich animations and blur effects.
- **⚡ Shell:** Zsh (Main), **Nushell (Experimental)**, and Bash optimized with **Starship (Jetpack Theme)**.
- **🛠️ Modern Core Utils:** Replaces legacy tools with modern Rust alternatives.
  - `ls` -> `eza`, `cd` -> `zoxide`, `cat` -> `bat`, `find` -> `fd`, `grep` → `ripgrep`, `ps` → `procs`.
  - `direnv` -> **`direnv` (Nix-direnv integrated)**.
  - **TUI File Manager:** **`yazi`** (Fast, Wayland-native image previews).
  - **Shell History:** **`atuin`** (Magical database-driven history search).
- **🚀 Advanced CLI Tools:** `gh` (GitHub), `lazydocker`, `xh` (HTTP), `sd` (sed replacement), `gping` (Visual Ping), `comma` (Run without install), `nix-tree`.
- **💻 Terminal Multiplexer:** **Zellij** managed via standard Nix modules.
- **📝 Editor:** **Neovim** (Modern Modular Setup).
  - Fully modular Lua configuration split by function (`options`, `keymaps`, `plugins`, `utils`).
  - **Enhanced:** Neovim 0.11 support, ROS/Distrobox integration, and refined LSP visuals.
- **🚀 App Launcher, Bar & Notifications:** **Noctalia Shell** - Unified Wayland-native shell for a seamless experience.
- **🔒 Security:** **Hyprlock** & **Hypridle** for automated screen locking and power management.
- **🎨 Global Theme:** Unified **Catppuccin Mocha** aesthetic across GTK, Icons, and WM.
- **📦 Modular & Standardized:** Clean file structure using the latest Home Manager patterns.

## 📂 Directory Structure

```text
~/home_env_dotfiles
├── flake.nix             # Entry point (System-specific configurations)
└── nix
    ├── home.nix          # Main loader & Centralized Shell Aliases
    └── modules
        ├── shell.nix     # Shell configuration bridge
        ├── bash.nix      # Bash configuration
        ├── zsh.nix       # Zsh configuration
        ├── nushell.nix   # Nushell (Experimental) configuration
        ├── shell-utils.nix # Shell-related Rust utilities (eza, zoxide, atuin, yazi, carapace)
        ├── neovim.nix    # Neovim module loader
        ├── neovim/       # Modular Lua configurations (Neovim 0.11+ ready)
        ├── zellij.nix    # Terminal multiplexer config
        ├── ghostty.nix   # Ghostty terminal emulator config
        ├── hyprland.nix  # Hyprland core configuration & Keybindings
        ├── hyprlock.nix  # Catppuccin themed lock screen
        ├── hypridle.nix  # Idle & Auto-lock configuration
        ├── noctalia.nix  # Noctalia Shell (Bar, Launcher, Notifications)
        ├── theme.nix     # GTK/Icon/Cursor/Kvantum theme configuration
        ├── system-utils.nix # System monitoring, capture, hardware control (nh, btop, wlogout, cliphist)
        ├── dev-tools.nix # Development tools & LSP (gh, lazydocker, sd, xh, nil, gopls)
        ├── gui-apps.nix  # GUI applications (Ghostty)
        ├── fonts.nix     # Font configurations (Maple Mono, Nerd Fonts)
        ├── git.nix       # Standardized Git user config (GitUI, Delta, Lazygit)
        ├── rclone.nix    # Rclone cloud sync config
        ├── swappy.nix    # Swappy configuration
        └── welcome.nix   # Custom welcome messages
```

## 🚀 Installation (Ubuntu 24.04)

### 1. Install Engines (via apt/PPA)
For driver compatibility and the latest features, the core engines and security tools must be installed via the system package manager or community PPA.
```bash
# Add the Hyprland PPA
sudo add-apt-repository ppa:cppiber/hyprland
sudo apt update

# Install Hyprland, Portals, and Security tools
sudo apt install hyprland xdg-desktop-portal-hyprland hyprlock hypridle
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

## 🛠️ Management Guide (with `nh`)

이 프로젝트는 더 나은 사용자 경험을 위해 **`nh` (Nix Helper)**를 사용합니다.

| Task | nh Command (Recommended) | Native Command |
| :--- | :--- | :--- |
| **Apply Config** | `nh home switch` | `home-manager switch --flake .` |
| **Update Flake** | - | `nix flake update` |
| **Clean Garbage** | `nh clean all` | `nix-collect-garbage -d` |

- `nh`는 빌드 시 `nix-output-monitor`를 통해 시각적으로 빌드 로그를 보여줍니다.
- 설정 파일에서 `programs.nh.flake` 경로가 이미 `~/home_env_dotfiles`로 지정되어 있어 편리합니다.

## 🖥️ Monitor Configuration (Machine-specific)

Since monitor layouts (order, resolution, refresh rate) vary by machine, they are managed via a local configuration file that is **not** tracked by Git.

### 1. Find your monitor info
Run the following command to see connected monitors, their names (e.g., `DP-1`, `HDMI-A-1`), and supported resolutions/refresh rates:
```bash
hyprctl monitors
```

### 2. Create/Edit Local Configs (Monitors & Workspaces)
If you need a custom layout (e.g., reversing monitor order) or fixed workspaces:
```bash
# This files are ignored by Git
nano ~/.config/hypr/monitors.conf
nano ~/.config/hypr/workspaces.conf
```

#### 💡 Fixed Workspaces (Example for Dual Monitors)
To pin specific workspaces to monitors, add the following to `~/.config/hypr/workspaces.conf`:
```text
# workspace = [ID], monitor:[NAME]
workspace = 1, monitor:DP-1
workspace = 6, monitor:HDMI-A-1
```

### 3. Examples

#### ✅ Recommended: Flexible & Safe (Auto-detect resolution)
Using `preferred` and `auto` prevents display issues when hardware specs change.
```text
# monitor=NAME, preferred, OFFSET, SCALE
monitor=DP-1, preferred, 0x0, 1
monitor=HDMI-A-1, preferred, auto, 1
```

#### ⚠️ Advanced: Manual Override (Potential for bugs)
Only use specific resolutions if you need to force a lower refresh rate or non-native resolution. **Incorrect values can cause "No Signal" or alignment bugs.**
```text
# monitor=NAME, RESOLUTION@REFRESH, OFFSET, SCALE
monitor=DP-1, 2560x1440@144, 0x0, 1
monitor=HDMI-A-1, 1920x1080@60, 2560x0, 1
```

#### 📐 Vertical Setup
```text
monitor=DP-1, preferred, 0x0, 1
monitor=HDMI-A-1, preferred, auto, 1, transform, 1 # Rotated 90 degrees
```

### 4. GPU Optimization (NVIDIA)
If your machine has an **NVIDIA GPU**, create `nix/local.nix` (ignored by Git) to enable high-performance rendering:

```nix
{ config, lib, ... }:

{
  # Enable NVIDIA specific configurations for Hyprland
  config.myHardware.nvidia.enable = true;
}
```

---

## 🛠️ Management Aliases

| Alias | Full Command | Description |
| :--- | :--- | :--- |
| **`hms`** | `home-manager switch --flake ...#$(whoami)` | Default switch (x86_64 Linux) |
| **`hmsx`** | `home-manager switch --flake ...#$(whoami)-x86-linux` | **x86_64 Linux** (WSL/Native) |
| **`hmsa`** | `home-manager switch --flake ...#$(whoami)-aarch-linux` | **AArch64 Linux** |
| **`hmsm`** | `home-manager switch --flake ...#$(whoami)-aarch-mac` | **Apple Silicon Mac** |
| **`hypr_shortcuts`** | `hypr-cheat` | Show Hyprland keybindings guide |

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
If key components don't start automatically on a fresh boot:
- The current configuration uses **absolute Nix store paths** to ensure binaries are found.
- Always run `hyprctl reload` after `hmsx` if shortcuts seem unresponsive.

### 4. Sync Shell History (Atuin)
```bash
atuin import auto
```

## ⌨️ Cheat Sheet (Hyprland)

| Shortcut | Action |
| :--- | :--- |
| **`Super + Enter`** | Launch **Ghostty** terminal |
| **`Super + Space`** | Launch **Noctalia** (App Launcher) |
| **`Super + Q`** | Close active window (Kill) |
| **`Super + F`** | Toggle Fullscreen |
| **Super + V** | Toggle Floating mode |
| **Super + N** | Toggle **Noctalia Notification Center** |
| **Super + Alt + N** | Clear all notifications |
| **Super + h/j/k/l** | Move focus (Left, Down, Up, Right) |
| **`Super + , / .`** | Focus Monitor (Left/Right) |
| **`Super + Shift + h/j/k/l`** | Move window position |
| **`Super + Shift + , / .`** | Move window to Monitor |
| **`Super + 1 ~ 0`** | Switch to workspace 1-10 |
| **Super + Shift + E** | Exit Hyprland (Logout) |
| **Super + Escape** | Lock Screen (**Hyprlock**) |
| **Super + Alt + h/j/k/l** | Resize active window |
| **Super + Wheel Up/Down** | Cycle Workspaces (Current Monitor) |
| **Super + [ / ]** | Cycle Workspaces (Current Monitor) |
| **Print Screen** | Capture Whole Screen to File |
| **Super + Shift + S** | Capture Area & Edit (**Swappy**) |
| **Super + Shift + C** | Capture Area to **Clipboard** |

> 💡 **Swappy Tip:** Inside the editor, use `Ctrl + C` (Copy) or `Ctrl + S` (Save).


---

**Note:** Binary engines are managed by `apt/PPA` for driver stability, while all detailed configurations and developer tools are managed declaratively via Nix Home Manager.

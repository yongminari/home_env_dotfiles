#!/usr/bin/env bash

# Nix & Home Manager Uninstaller Script
# This script is designed to safely remove Nix and Home Manager from a Linux system.

set -e

# --- 0. Pre-checks ---
if [[ $EUID -eq 0 ]]; then
   echo "Error: Please do not run this script as root directly. Use a normal user with sudo privileges."
   exit 1
fi

# Check for Determinate Systems uninstaller
if [ -f "/nix/nix-installer" ]; then
    echo "💡 NOTICE: Determinate Systems installer detected."
    echo "It is HIGHLY RECOMMENDED to use their official uninstaller instead:"
    echo "   /nix/nix-installer uninstall"
    echo ""
    read -p "Do you still want to proceed with this manual script? (y/N) " detsys_confirm
    if [[ $detsys_confirm != [yY] ]]; then
        echo "Aborted. Please run '/nix/nix-installer uninstall' instead."
        exit 0
    fi
fi

echo "⚠️  WARNING: This will permanently remove Nix, Home Manager, and all installed packages (Zsh, Nushell, etc.)."
echo "Any configuration managed by Nix in your home directory will be disconnected (broken symlinks)."
read -p "Are you sure you want to proceed? (y/N) " confirm
if [[ $confirm != [yY] ]]; then
    echo "Aborted."
    exit 0
fi

# --- 1. Restore Default Shell ---
CURRENT_SHELL=$(getent passwd "$USER" | cut -d: -f7)
if [[ "$CURRENT_SHELL" == *".nix-profile"* ]] || [[ "$CURRENT_SHELL" == *"/nix/store"* ]] || [[ "$CURRENT_SHELL" == *"zsh"* ]] || [[ "$CURRENT_SHELL" == *"nu"* ]]; then
    echo "🔄 Restoring default shell to /bin/bash..."
    # Try to find a safe system shell
    SAFE_SHELL="/bin/bash"
    if [ ! -f "$SAFE_SHELL" ]; then SAFE_SHELL="/usr/bin/bash"; fi
    
    sudo chsh -s "$SAFE_SHELL" "$USER"
    echo "✅ Shell changed to $SAFE_SHELL. Please restart your terminal after this script finishes."
fi

# --- 1.5 Unmount and Cleanup rclone ---
echo "☁️  Unmounting rclone drives and cleaning up..."
for drive in "gdrive" "onedrive"; do
    mnt_path="$HOME/mnt/$drive"
    if [ -d "$mnt_path" ]; then
        # Check if it is a mount point
        if grep -q "$mnt_path" /proc/mounts 2>/dev/null; then
            echo "   Unmounting $mnt_path..."
            fusermount3 -u "$mnt_path" 2>/dev/null || umount "$mnt_path" 2>/dev/null || true
        fi
        # Remove the directory
        rm -rf "$mnt_path" 2>/dev/null || true
    fi
done
# Remove rclone config and parent mnt directory
rm -rf ~/.config/rclone 2>/dev/null || true
rmdir "$HOME/mnt" 2>/dev/null || true
echo "✅ rclone mounts and configurations cleaned up."

# --- 2. Cleanup Home Manager ---
echo "🧹 Cleaning up Home Manager profiles..."
if command -v nix-env &> /dev/null; then
    nix-env --delete-generations old || true
    # Remove the main home-manager profile links
    rm -rf ~/.local/state/nix/profiles/home-manager* 2>/dev/null || true
    rm -rf ~/.local/state/home-manager 2>/dev/null || true
fi

# --- 3. Stop and Disable Nix Daemon ---
echo "🛑 Stopping Nix daemon services..."
if systemctl is-active --quiet nix-daemon.service 2>/dev/null; then
    sudo systemctl stop nix-daemon.socket nix-daemon.service
    sudo systemctl disable nix-daemon.socket nix-daemon.service
    sudo systemctl daemon-reload
fi

# --- 4. Remove Nix Users and Groups ---
echo "👤 Removing Nix build users and groups..."
# Standard Nix build users are nixbld1 through nixbld32
for i in $(seq 1 32); do
    if id "nixbld$i" &>/dev/null; then
        sudo userdel "nixbld$i"
    fi
done

if getent group nixbld &>/dev/null; then
    sudo groupdel nixbld
fi

# --- 5. Remove Nix Files and Directories ---
echo "🗑️  Deleting Nix system directories (this may take a while)..."
sudo rm -rf /nix
sudo rm -rf /etc/nix
sudo rm -rf /etc/profile.d/nix.sh
sudo rm -rf /etc/systemd/system/nix-daemon.service
sudo rm -rf /etc/systemd/system/nix-daemon.socket
sudo rm -rf /etc/tmpfiles.d/nix-daemon.conf

# --- 6. Remove User-specific Nix Files ---
echo "📂 Cleaning up user-specific Nix files..."
rm -rf ~/.nix-profile
rm -rf ~/.nix-defexpr
rm -rf ~/.nix-channels
rm -rf ~/.config/nix
rm -rf ~/.cache/nix

# Cleanup Home Manager symlinks (including Nushell)
echo "🔗 Cleaning up broken Home Manager symlinks..."
find ~/.config -maxdepth 2 -type l -lname '/nix/store/*' -delete 2>/dev/null || true
# Explicitly check for nushell config if it's a directory containing symlinks
if [ -d "$HOME/.config/nushell" ]; then
    find ~/.config/nushell -type l -lname '/nix/store/*' -delete 2>/dev/null || true
fi

# --- 7. Final Instructions ---
echo "----------------------------------------------------"
echo "✅ Uninstallation complete!"
echo "----------------------------------------------------"
echo "Manual steps remaining:"
echo "1. Remove any Nix-related lines from your ~/.bashrc, ~/.zshrc, or ~/.profile if they exist."
echo "2. Check /etc/shells and remove any Nix-provided shell paths (e.g., zsh, nu) if you added them manually."
echo "3. RESTART your computer or log out and log back in to ensure all environment variables are cleared."
echo "----------------------------------------------------"

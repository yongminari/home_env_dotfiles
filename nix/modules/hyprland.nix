{ config, pkgs, inputs, lib, ... }:

let
  # Check if nvidia is enabled in a local config
  isNvidia = config.myHardware.nvidia.enable or false;
in
{
  # We removed home.file here to prevent clobbering existing local files.
  # Please manage monitors.conf and workspaces.conf manually as you did before.

  # Hyprland Final Configuration (Optimized for Ubuntu + Nix Paths)
  xdg.configFile."hypr/hyprland.conf".text = ''
# --- Monitor ---
# Default configuration for all machines (auto detection)
monitor=,preferred,auto,1

# --- Variables ---
$mainMod = SUPER

# --- Keybindings (Direct & Reliable) ---
# Terminal & Launcher
bind = $mainMod, Return, exec, ${pkgs.ghostty}/bin/ghostty
bind = $mainMod, space, exec, ${inputs.noctalia.packages.${pkgs.system}.default}/bin/noctalia-shell ipc call launcher toggle
bind = $mainMod, n, exec, ${inputs.noctalia.packages.${pkgs.system}.default}/bin/noctalia-shell ipc call notifications toggleHistory
bind = $mainMod SHIFT, n, exec, ${inputs.noctalia.packages.${pkgs.system}.default}/bin/noctalia-shell ipc call notifications toggleHistory
bind = $mainMod ALT, n, exec, ${inputs.noctalia.packages.${pkgs.system}.default}/bin/noctalia-shell ipc call notifications clearAll
bind = $mainMod, Q, killactive
bind = $mainMod, F, fullscreen
bind = $mainMod, V, togglefloating
# Escape: Lock Screen using System Path (Hyprlock)
bind = $mainMod, Escape, exec, /usr/bin/hyprlock

# --- Resizing ---
# Quick Resize (SUPER + ALT + HJKL)
binde = $mainMod ALT, l, resizeactive, 30 0
binde = $mainMod ALT, h, resizeactive, -30 0
binde = $mainMod ALT, k, resizeactive, 0 -30
binde = $mainMod ALT, j, resizeactive, 0 30

# IME (Fcitx5) - ESC to English
bindn = , Escape, exec, /usr/bin/fcitx5-remote -c

# Focus (Vim Style)
bind = $mainMod, h, movefocus, l
bind = $mainMod, l, movefocus, r
bind = $mainMod, k, movefocus, u
bind = $mainMod, j, movefocus, d

# Monitor Focus
bind = $mainMod, comma, focusmonitor, l
bind = $mainMod, period, focusmonitor, r

# Move Window (Vim Style)
bind = $mainMod SHIFT, h, movewindow, l
bind = $mainMod SHIFT, l, movewindow, r
bind = $mainMod SHIFT, k, movewindow, u
bind = $mainMod SHIFT, j, movewindow, d

# Move Window to Monitor
bind = $mainMod SHIFT, comma, movewindow, l
bind = $mainMod SHIFT, period, movewindow, r

# Workspaces
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
bind = $mainMod, 6, workspace, 6
bind = $mainMod, 7, workspace, 7
bind = $mainMod, 8, workspace, 8
bind = $mainMod, 9, workspace, 9
bind = $mainMod, 0, workspace, 10

# Cycle through workspaces on current monitor
bind = $mainMod, mouse_down, workspace, m+1
bind = $mainMod, mouse_up, workspace, m-1
bind = $mainMod, bracketright, workspace, m+1
bind = $mainMod, bracketleft, workspace, m-1

bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8
bind = $mainMod SHIFT, 9, movetoworkspace, 9
bind = $mainMod SHIFT, 0, movetoworkspace, 10

# --- Auto Start ---
exec-once = dbus-update-activation-environment --systemd --all
exec-once = systemctl --user import-environment --all
exec-once = sh -c "sleep 1; ${inputs.noctalia.packages.${pkgs.system}.default}/bin/noctalia-shell"
exec-once = fcitx5 -dr
exec-once = nm-applet --indicator
exec-once = ${pkgs.swaybg}/bin/swaybg -m solid_color -c "#181825"
exec-once = /usr/bin/hypridle
# exec-once = ${pkgs.swaynotificationcenter}/bin/swaync

# --- Environment Variables ---
env = XCURSOR_SIZE,52
env = QT_QPA_PLATFORM,wayland
env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_TYPE,wayland
env = XDG_SESSION_DESKTOP,Hyprland
env = XMODIFIERS,@im=fcitx
env = QT_IM_MODULE,fcitx
env = GTK_IM_MODULE,fcitx
env = SDL_IM_MODULE,fcitx
env = GLFW_IM_MODULE,fcitx

# --- NVIDIA Specific (Conditional) ---
${lib.optionalString isNvidia ''
env = LIBVA_DRIVER_NAME,nvidia
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = GBM_BACKEND,nvidia-drm
env = __NV_PRIME_RENDER_OFFLOAD,1
env = __VK_LAYER_NV_optimus,NVIDIA_only
env = WLR_DRM_NO_ATOMIC,1
env = NVD_BACKEND,direct

cursor {
    no_hardware_cursors = true
}
''}

# --- Input ---
input {
    kb_layout = us
    kb_options = ctrl:nocaps
    follow_mouse = 1
    touchpad {
        natural_scroll = true
    }
    repeat_delay = 400
    repeat_rate = 40
}

# --- Visuals ---
general {
    gaps_in = 5
    gaps_out = 10
    border_size = 2
    col.active_border = rgba(cba6f7ee) rgba(89b4faee) 45deg
    col.inactive_border = rgba(585b70aa)
    layout = dwindle
}

decoration {
    rounding = 10
    blur {
        enabled = true
        size = 3
        passes = 1
    }
}

animations {
    enabled = true
    bezier = myBezier, 0.05, 0.9, 0.1, 1.05
    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

# --- Screenshot (Absolute Paths for Certainty) ---
# Print Screen: Capture whole screen
bind = , Print, exec, ${pkgs.grim}/bin/grim ~/Pictures/$(date +'%Y-%m-%d-%H%M%S_grim.png')
# Super + Shift + S: Capture area and open in Swappy (Editor)
bind = $mainMod SHIFT, s, exec, ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.swappy}/bin/swappy -f -
# Super + Shift + C: Capture area directly to CLIPBOARD (No editor)
bind = $mainMod SHIFT, c, exec, ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.wl-clipboard}/bin/wl-copy

# --- Exit ---
bind = $mainMod SHIFT, E, exec, hyprctl dispatch exit

# --- Hardware Media Keys (Volume, Brightness) ---
# binde: repeatable keybind (smoothly adjustment)
binde = , XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i 5
binde = , XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d 5
bind = , XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer -t
binde = , XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%+
binde = , XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%-

# --- Local Overrides (Highest Priority) ---
source = ~/.config/hypr/monitors.conf
source = ~/.config/hypr/workspaces.conf
  '';
}

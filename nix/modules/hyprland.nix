{ config, pkgs, ... }:

{
  # Hyprland Final Configuration (Testing timing issue with this comment)
  xdg.configFile."hypr/hyprland.conf".text = ''
# --- Monitor ---
monitor=,preferred,auto,1

# --- Variables ---
# Use SUPER (Windows Key) as the main modifier
$mainMod = SUPER

# --- Keybindings (Direct & Reliable) ---
# Terminal & Launcher
bind = $mainMod, Return, exec, ${pkgs.ghostty}/bin/ghostty
bind = $mainMod, D, exec, ${pkgs.rofi}/bin/rofi -show drun
bind = $mainMod, Q, killactive
bind = $mainMod, F, fullscreen
bind = $mainMod, V, togglefloating
bind = $mainMod, Escape, exec, swaylock -c 11111b

# IME (Fcitx5) - ESC to English
bindn = , Escape, exec, /usr/bin/fcitx5-remote -c

# Focus (Vim Style)
bind = $mainMod, h, movefocus, l
bind = $mainMod, l, movefocus, r
bind = $mainMod, k, movefocus, u
bind = $mainMod, j, movefocus, d

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
exec-once = sleep 1 && ${pkgs.waybar}/bin/waybar
exec-once = fcitx5 -dr
exec-once = swaybg -m solid_color -c "#181825"

# --- Environment Variables ---
env = XCURSOR_SIZE,24
env = QT_QPA_PLATFORM,wayland
env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_TYPE,wayland
env = XDG_SESSION_DESKTOP,Hyprland
env = XMODIFIERS,@im=fcitx
env = QT_IM_MODULE,fcitx
env = GTK_IM_MODULE,fcitx
env = SDL_IM_MODULE,fcitx
env = GLFW_IM_MODULE,fcitx

# --- Input ---
input {
    kb_layout = us
    kb_options = ctrl:nocaps
    follow_mouse = 1
    touchpad {
        natural_scroll = true
    }
}

# --- Visuals (Fancy Hyprland Style) ---
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

# --- Screenshot ---
bind = , Print, exec, grim ~/Pictures/$(date +'%Y-%m-%d-%H%M%S_grim.png')
bind = $mainMod SHIFT, s, exec, grim -g "$(slurp)" - | swappy -f -

# --- Exit ---
bind = $mainMod SHIFT, E, exec, hyprctl dispatch exit
  '';
}

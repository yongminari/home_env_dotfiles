{ config, pkgs, ... }:

{
  # Sway Configuration (~/.config/sway/config)
  xdg.configFile."sway/config".text = ''
    # --- Variables ---
    set $mod Mod4
    set $left h
    set $down j
    set $up k
    set $right l
    # Fix library conflicts for Ghostty (Nix)
    set $term env -u LD_LIBRARY_PATH ghostty
    set $menu rofi -show drun

    # --- Appearance ---
    default_border pixel 2
    gaps inner 8
    gaps outer 5
    font pango:Maple Mono NF 11

    # --- Output ---
    output * {
        background #1e1e2e solid_color
    }

    # --- Keybindings ---
    bindsym $mod+Return exec $term
    bindsym $mod+q kill
    bindsym $mod+d exec $menu
    bindsym $mod+Escape exec swaylock -c 000000
    bindsym $mod+Shift+e exec swaynag -t warning -m 'Exit Sway?' -b 'Yes' 'swaymsg exit'
    bindsym $mod+f fullscreen toggle
    bindsym $mod+v floating toggle

    # Focus
    bindsym $mod+$left focus left
    bindsym $mod+$down focus down
    bindsym $mod+$up focus up
    bindsym $mod+$right focus right

    # Move Window
    bindsym $mod+Shift+$left move left
    bindsym $mod+Shift+$down move down
    bindsym $mod+Shift+$up move up
    bindsym $mod+Shift+$right move right

    # Workspaces
    bindsym $mod+1 workspace number 1
    bindsym $mod+2 workspace number 2
    bindsym $mod+3 workspace number 3
    bindsym $mod+4 workspace number 4
    bindsym $mod+5 workspace number 5
    bindsym $mod+6 workspace number 6
    bindsym $mod+7 workspace number 7
    bindsym $mod+8 workspace number 8
    bindsym $mod+9 workspace number 9
    bindsym $mod+0 workspace number 10

    bindsym $mod+Shift+1 move container to workspace number 1
    bindsym $mod+Shift+2 move container to workspace number 2
    bindsym $mod+Shift+3 move container to workspace number 3
    bindsym $mod+Shift+4 move container to workspace number 4
    bindsym $mod+Shift+5 move container to workspace number 5
    bindsym $mod+Shift+6 move container to workspace number 6
    bindsym $mod+Shift+7 move container to workspace number 7
    bindsym $mod+Shift+8 move container to workspace number 8
    bindsym $mod+Shift+9 move container to workspace number 9
    bindsym $mod+Shift+0 move container to workspace number 10

    # Layout & Control
    bindsym $mod+Shift+b splith
    bindsym $mod+Shift+v splitv
    bindsym $mod+s layout stacking
    bindsym $mod+w layout tabbed
    bindsym $mod+e layout toggle split

    # --- Auto Start ---
    exec waybar
    
    # 1. Update Activation Environment (Wayland & IBus variables)
    exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP=sway \
         GTK_IM_MODULE=ibus QT_IM_MODULE=ibus XMODIFIERS=@im=ibus \
         SDL_IM_MODULE=ibus GLFW_IM_MODULE=ibus

    # 2. Restart IBus Daemon with Wayland support
    exec pkill ibus-daemon
    exec ibus-daemon -drxR

    # --- Input Configuration ---
    input "type:keyboard" {
        xkb_layout us
        xkb_options ctrl:nocaps
    }
    input "type:touchpad" {
        tap enabled
        natural_scroll enabled
    }
  '';
}

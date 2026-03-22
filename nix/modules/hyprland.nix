{ config, pkgs, ... }:

{
  # Hyprland Configuration (~/.config/hypr/hyprland.conf)
  xdg.configFile."hypr/hyprland.conf".text = ''
    # --- Monitor ---
    monitor=,preferred,auto,1

    # --- Variables ---
    $mainMod = SUPER
    # Use absolute paths from Nix to ensure they work even if PATH is not set
    $terminal = env XMODIFIERS=@im=fcitx GTK_IM_MODULE=fcitx QT_IM_MODULE=fcitx GLFW_IM_MODULE=fcitx SDL_IM_MODULE=fcitx LD_LIBRARY_PATH= ${pkgs.ghostty}/bin/ghostty
    $menu = ${pkgs.rofi}/bin/rofi -show drun

    # --- Auto Start ---
    # [CRITICAL] Sync ALL environment variables immediately
    exec-once = dbus-update-activation-environment --systemd --all
    exec-once = systemctl --user import-environment --all

    # Use absolute paths for waybar as well
    exec-once = sleep 1 && ${pkgs.waybar}/bin/waybar
    exec-once = fcitx5 -dr
    
    # Wallpaper
    exec-once = swaybg -m solid_color -c "#181825"

    # --- Environment Variables ---
    env = XCURSOR_SIZE,24
    env = QT_QPA_PLATFORM,wayland
    env = XDG_CURRENT_DESKTOP,Hyprland
    env = XDG_SESSION_TYPE,wayland
    env = XDG_SESSION_DESKTOP,Hyprland
    
    # [IME Settings] - Global environment variables for Fcitx5
    env = XMODIFIERS,@im=fcitx
    env = QT_IM_MODULE,fcitx
    env = GTK_IM_MODULE,fcitx
    env = SDL_IM_MODULE,fcitx
    env = GLFW_IM_MODULE,fcitx

    # NVIDIA Support (Ubuntu users often need this)
    # env = LIBVA_DRIVER_NAME,nvidia
    # env = GBM_BACKEND,nvidia-drm
    # env = __GLX_VENDOR_LIBRARY_NAME,nvidia

    # --- Input ---
    input {
        kb_layout = us
        kb_options = ctrl:nocaps
        follow_mouse = 1
        touchpad {
            natural_scroll = true
            tap-to-click = true
        }
    }

    # --- General (Appearance) ---
    general {
        gaps_in = 5
        gaps_out = 10
        border_size = 2
        col.active_border = rgba(cba6f7ee) rgba(89b4faee) 45deg
        col.inactive_border = rgba(585b70aa)
        layout = dwindle
    }

    # --- Decoration (Visual Effects) ---
    decoration {
        rounding = 10
        blur {
            enabled = true
            size = 3
            passes = 1
        }
        shadow {
            enabled = true
            range = 4
            render_power = 3
            color = rgba(1a1a1aee)
        }
    }

    # --- Animations ---
    animations {
        enabled = true
        bezier = myBezier, 0.05, 0.9, 0.1, 1.05
        animation = windows, 1, 7, myBezier
        animation = windowsOut, 1, 7, default, popin 80%
        animation = border, 1, 10, default
        animation = fade, 1, 7, default
        animation = workspaces, 1, 6, default
    }

    # --- Dwindle Layout ---
    dwindle {
        pseudotile = true
        preserve_split = true
    }

    # --- Keybindings ---
    bind = $mainMod, Return, exec, $terminal
    bind = $mainMod, Q, killactive,
    bind = $mainMod, D, exec, $menu
    bind = $mainMod, F, fullscreen,
    bind = $mainMod, V, togglefloating,
    bind = $mainMod, Escape, exec, swaylock -c 11111b
    
    # [ESC to English] Force English mode when ESC is pressed (Fcitx5)
    # Use 'bindn' (non-consuming) with absolute path to ensure it runs without blocking the key
    bindn = , Escape, exec, /usr/bin/fcitx5-remote -c

    # Focus
    bind = $mainMod, h, movefocus, l
    bind = $mainMod, l, movefocus, r
    bind = $mainMod, k, movefocus, u
    bind = $mainMod, j, movefocus, d

    # Move Window
    bind = $mainMod SHIFT, h, movewindow, l
    bind = $mainMod SHIFT, l, movewindow, r
    bind = $mainMod SHIFT, k, movewindow, u
    bind = $mainMod SHIFT, j, movewindow, d

    # Workspaces
    bind = $mainMod, 1, workspace, 1
    bind = $mainMod, 2, workspace, 2
    bind = $mainMod, 3, workspace, 3
    bind = $mainMod, 4, workspace, 4
    bind = $mainMod, 5, workspace, 5
    bind = $mainMod, 6, workspace, 6
    bind = $mainMod, 7, workspace, 7
    bind = $mainMod, 8, workspace, 8
    bind = $mainMod, 9, workspace, 10
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

    # Resize Mode (Submap)
    bind = $mainMod, R, submap, resize
    submap = resize
    binde = , l, resizeactive, 10 0
    binde = , h, resizeactive, -10 0
    binde = , k, resizeactive, 0 -10
    binde = , j, resizeactive, 0 10
    bind = , escape, submap, reset
    bind = , return, submap, reset
    submap = default

    # Logout
    bind = $mainMod SHIFT, E, exec, hyprctl dispatch exit
  '';
}

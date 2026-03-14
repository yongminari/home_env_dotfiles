{ config, pkgs, ... }:

{
  # 순수 설정 파일만 관리 (Nix로 엔진을 돌리지 않음)
  # apt로 설치된 Hyprland가 이 설정을 읽습니다.
  xdg.configFile."hypr/hyprland.conf".text = ''
    # --- Monitor ---
    monitor=,preferred,auto,1

    # --- Input ---
    input {
        kb_layout = us
        kb_options = ctrl:nocaps
        follow_mouse = 1
        touchpad {
            natural_scroll = true
        }
    }

    # --- Appearance ---
    general {
        gaps_in = 5
        gaps_out = 10
        border_size = 2
        col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
        col.inactive_border = rgba(595959aa)
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

    # --- Keybindings (Pure System Commands) ---
    $mainMod = SUPER

    bind = $mainMod, Return, exec, ghostty
    bind = $mainMod, Q, killactive,
    bind = $mainMod, M, exit,
    bind = $mainMod, V, togglefloating,
    bind = $mainMod, R, exec, pkill wofi || wofi --show drun
    bind = $mainMod, W, exec, google-chrome-stable --new-window https://slack.com https://github.com https://gmail.com
    bind = $mainMod, F, fullscreen, 0
    bind = $mainMod, S, togglespecialworkspace, magic
    bind = $mainMod SHIFT, S, movetoworkspace, special:magic

    # Focus
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

    # Mouse
    bindm = $mainMod, mouse:272, movewindow
    bindm = $mainMod, mouse:273, resizewindow

    # --- Window Rules ---
    windowrule = match:title (.*Slack.*), workspace 2
    windowrule = match:class (ghostty), workspace 1
  '';
}

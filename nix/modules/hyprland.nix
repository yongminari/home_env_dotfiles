{ config, pkgs, ... }:

{
  # Hyprland tiling window manager setup
  wayland.windowManager.hyprland = {
    enable = true;
    # System settings
    settings = {
      # 1. Monitor Setup (범용 설정: 어떤 모니터든 최적 해상도로 자동 감지)
      monitor = [
        ",preferred,auto,1"
      ];

      # 2. Auto-start & Environment Variables
      exec-once = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "ibus-daemon -drx"
      ];

      env = [
        "XDG_CURRENT_DESKTOP, Hyprland"
        "XDG_SESSION_TYPE, wayland"
        "XDG_SESSION_DESKTOP, Hyprland"
        "XMODIFIERS, @im=ibus"
        "GTK_IM_MODULE, ibus"
        "QT_IM_MODULE, ibus"
        "QT_IM_MODULES, ibus"
        "SDL_IM_MODULE, ibus"
        "GLFW_IM_MODULE, ibus"
        "IBUS_COMPONENT_PATH, ${config.home.homeDirectory}/.nix-profile/share/ibus/component"
        "XDG_DATA_DIRS, $HOME/.nix-profile/share:/usr/local/share:/usr/share:$XDG_DATA_DIRS"
      ];

      # 3. Main Modifiers & Input
      "$mainMod" = "SUPER";

      input = {
        kb_layout = "us";
        kb_options = "ctrl:nocaps"; # Map Caps Lock to Ctrl
        follow_mouse = 1;
        sensitivity = 0; 
        touchpad = {
          natural_scroll = true;
        };
      };

      # 3. Keybindings
      bind = [
        # Basic operations (Reset LD_LIBRARY_PATH to fix OpenGL issues while keeping other variables)
        "$mainMod, Return, exec, env LD_LIBRARY_PATH=\"\" ghostty"
        "$mainMod, Q, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, V, togglefloating,"
        # Use nix-gui-run for automatic GPU detection
        "$mainMod, R, exec, pkill wofi || nix-gui-run wofi --show drun"
        "$mainMod, P, pseudo," 
        "$mainMod, J, togglesplit,"

        "$mainMod, h, movefocus, l"
        "$mainMod, l, movefocus, r"
        "$mainMod, k, movefocus, u"
        "$mainMod, j, movefocus, d"

        "$mainMod, comma, focusmonitor, l"
        "$mainMod, period, focusmonitor, r"

        "$mainMod SHIFT, h, movewindow, l"
        "$mainMod SHIFT, l, movewindow, r"
        "$mainMod SHIFT, k, movewindow, u"
        "$mainMod SHIFT, j, movewindow, d"

        "$mainMod ALT, h, resizeactive, -40 0"
        "$mainMod ALT, l, resizeactive, 40 0"
        "$mainMod ALT, k, resizeactive, 0 -40"
        "$mainMod ALT, j, resizeactive, 0 40"

        "$mainMod, f, fullscreen, 0"
        "$mainMod, s, togglespecialworkspace, magic"
        "$mainMod SHIFT, s, movetoworkspace, special:magic"

        # Workspaces 1-10
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        "$mainMod, W, exec, google-chrome-stable --new-window https://slack.com https://github.com https://gmail.com"
        "$mainMod, mouse_up, workspace, e-1"
        "$mainMod, mouse_down, workspace, e+1"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      # 4. Window Rules (Unified windowrule syntax v0.53.0+)
      windowrule = [
        "match:title (.*Slack.*), workspace 2"
        "match:class (ghostty), workspace 1"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };
    };
  };

  # Generate a session file in the user's local directory
  # Using nix-gui-run for automatic GPU detection
  home.file.".local/share/wayland-sessions/hyprland-nix.desktop".text = ''
    [Desktop Entry]
    Name=Hyprland (Nix)
    Comment=An intelligent dynamic tiling Wayland compositor (Nix-managed)
    Exec=${config.home.homeDirectory}/.nix-profile/bin/nix-gui-run ${config.home.homeDirectory}/.nix-profile/bin/start-hyprland
    Type=Application
    DesktopNames=Hyprland
  '';
}

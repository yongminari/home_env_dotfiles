{ config, pkgs, ... }:

{
  # Sway Configuration (~/.config/sway/config)
  xdg.configFile."sway/config".text = ''
    # --- Variables ---
    set $mod Mod4
    # Ghostty 실행 시 IME 환경 변수를 강제로 주입하여 IBus 충돌 방지
    set $term env XMODIFIERS=@im=fcitx GTK_IM_MODULE=fcitx QT_IM_MODULE=fcitx GLFW_IM_MODULE=fcitx SDL_IM_MODULE=fcitx LD_LIBRARY_PATH= ${pkgs.ghostty}/bin/ghostty
    set $menu rofi -show drun

    # --- Catppuccin Mocha Colors ---
    set $rosewater #f5e0dc
    set $flamingo  #f2cdcd
    set $pink      #f5c2e7
    set $mauve     #cba6f7
    set $red       #f38ba8
    set $maroon    #eba0ac
    set $peach     #fab387
    set $yellow    #f9e2af
    set $green     #a6e3a1
    set $teal      #94e2d5
    set $sky       #89dceb
    set $sapphire  #74c7ec
    set $blue      #89b4fa
    set $lavender  #b4befe
    set $text      #cdd6f4
    set $subtext1  #bac2de
    set $subtext0  #a6adc8
    set $overlay2  #9399b2
    set $overlay1  #7f849c
    set $overlay0  #6c7086
    set $surface2  #585b70
    set $surface1  #45475a
    set $surface0  #313244
    set $base      #1e1e2e
    set $mantle    #181825
    set $crust     #11111b

    # --- Appearance ---
    client.focused           $mauve  $base   $text   $rosewater $mauve
    client.focused_inactive  $overlay0 $base $text   $rosewater $overlay0
    client.unfocused         $overlay0 $base $text   $rosewater $overlay0
    client.urgent            $red    $base   $text   $rosewater $red

    default_border pixel 3
    gaps inner 10
    gaps outer 5
    font pango:Maple Mono NF 11

    # --- Output ---
    output * {
        background $base solid_color
    }

    # --- Keybindings ---
    bindsym $mod+Return exec $term
    bindsym $mod+q kill
    bindsym $mod+d exec $menu
    bindsym $mod+Escape exec swaylock -c 11111b
    # [ESC to English] Force English mode when ESC is pressed (Fcitx5 Only)
    bindsym --release Escape exec /usr/bin/fcitx5-remote -c
    bindsym $mod+Shift+e exec swaynag -t warning -m 'Exit Sway?' -b 'Yes' 'swaymsg exit'
    bindsym $mod+Shift+c reload
    bindsym $mod+f fullscreen toggle
    bindsym $mod+v floating toggle

    # Focus
    bindsym $mod+h focus left
    bindsym $mod+j focus down
    bindsym $mod+k focus up
    bindsym $mod+l focus right

    # Focus Output
    bindsym $mod+comma focus output left
    bindsym $mod+period focus output right

    # Move Window
    bindsym $mod+Shift+h move left
    bindsym $mod+Shift+j move down
    bindsym $mod+Shift+k move up
    bindsym $mod+Shift+l move right

    # Move Workspace to Output
    bindsym $mod+Shift+comma move workspace to output left
    bindsym $mod+Shift+period move workspace to output right

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

    # Layout & Splitting
    bindsym $mod+b splith
    bindsym $mod+Shift+v splitv
    bindsym $mod+s layout stacking
    bindsym $mod+w layout tabbed
    bindsym $mod+e layout toggle split

    # Resizing
    bindsym $mod+Alt+h resize shrink width 10px
    bindsym $mod+Alt+j resize grow height 10px
    bindsym $mod+Alt+k resize shrink height 10px
    bindsym $mod+Alt+l resize grow width 10px

    mode "resize" {
        bindsym h resize shrink width 10px
        bindsym j resize grow height 10px
        bindsym k resize shrink height 10px
        bindsym l resize grow width 10px
        bindsym Return mode "default"
        bindsym Escape mode "default"
    }
    bindsym $mod+r mode "resize"

    # Fcitx5 Setup Alias (For manual configuration)
    set $fcitx_cmd /usr/bin/fcitx5-config-qt

    # --- Auto Start ---
    exec waybar
    exec swaybg -m solid_color -c "#181825"
    
    # [ULTIMATE FIX] Synchronize ALL environment variables
    exec dbus-update-activation-environment --systemd --all
    exec systemctl --user import-environment --all

    # [IME Settings for Sway] - Fcitx5 Only for this session
    # (Removed gsettings to prevent affecting GNOME/IBus)
    
    # Start Fcitx5 (Force replace to ensure it is the primary instance)
    exec /usr/bin/fcitx5 -dr

    # Restart portals AFTER fcitx5 starts to ensure they pick it up
    # This is critical for immediate activation without opening a GUI window
    exec systemctl --user restart xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk || true

    exec swayidle -w \
         timeout 300 'swaylock -c 11111b' \
         timeout 600 'swaymsg "output * power off"' resume 'swaymsg "output * power on"' \
         before-sleep 'swaylock -c 11111b'

    # --- Input Configuration ---
    input "type:keyboard" {
        # xkb_layout us
        xkb_options ctrl:nocaps
    }
    input "type:touchpad" {
        tap enabled
        natural_scroll enabled
    }
  '';
}

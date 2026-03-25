{ config, pkgs, inputs, ... }:

let
  # Flake input에서 공식 테마 소스를 가져옵니다.
  waybar-themes = inputs.waybar-themes;
in
{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    systemd.enable = false;
    
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 34;
        margin-top = 5;
        margin-left = 10;
        margin-right = 10;
        spacing = 4;
        
        # 모듈 구성 (Hyprland 중심)
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "cpu" "memory" "network" "pulseaudio" "battery" "tray" ];

        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          format-icons = {
            "default" = "";
            "active" = "";
            "urgent" = "";
          };
        };

        "clock" = {
          format = " {:%H:%M}";
          format-alt = " {:%Y-%m-%d}";
        };

        "cpu" = { format = " {usage}%"; };
        "memory" = { format = " {}%"; };
        "battery" = {
          format = "{icon} {capacity}%";
          format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
        };
        "network" = {
          format-wifi = " {essid}";
          format-ethernet = "󰈀 {ifname}";
          format-disconnected = "⚠";
        };
        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-icons = { default = ["" "" ""]; };
          on-click = "pavucontrol";
        };

        "tray" = {
          icon-size = 16;
          spacing = 12;
        };
      };
    };

    # [Famous Theme Integration]
    # Catppuccin 공식 테마의 Mocha 스타일을 그대로 적용합니다.
    style = ''
      /* Catppuccin Mocha 공식 색상표 임포트 */
      @import "${waybar-themes}/themes/mocha.css";

      * {
        font-family: "Maple Mono NF", "D2Coding ligature", "Symbols Nerd Font";
        font-size: 13px;
        font-weight: bold;
      }

      window#waybar {
        background-color: rgba(30, 30, 46, 0.8);
        border: 2px solid @mauve;
        border-radius: 12px;
        color: @text;
      }

      #workspaces button {
        color: @mauve;
        padding: 0 5px;
      }

      #workspaces button.active {
        color: @base;
        background-color: @mauve;
        border-radius: 8px;
      }

      #clock, #cpu, #memory, #network, #pulseaudio, #battery {
        padding: 0 10px;
        margin: 4px 2px;
        background-color: @surface0;
        border-radius: 8px;
      }

      #tray {
        margin: 4px 8px 4px 2px;
      }

      #clock { color: @yellow; }
      #cpu { color: @green; }
      #memory { color: @sky; }
      #battery { color: @peach; }
    '';
  };
}

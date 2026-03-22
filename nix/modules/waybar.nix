{ config, pkgs, ... }:

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
        
        modules-left = [ "hyprland/workspaces" "sway/workspaces" "sway/mode" ];
        modules-center = [ "clock" ];
        modules-right = [ "cpu" "memory" "network" "battery" "tray" ];

        "hyprland/workspaces" = {
          format = "{name}";
          on-click = "activate";
          all-outputs = true;
        };

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{name}";
        };

        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = " {icon} {capacity}% ";
          format-charging = " 󰂄 {capacity}% ";
          format-plugged = " 󰚥 {capacity}% ";
          format-alt = " {icon} {time} ";
          format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
        };

        "clock" = {
          format = "  {:%H:%M} ";
          format-alt = "  {:%Y-%m-%d} ";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        "cpu" = { format = "  {usage}% "; tooltip = false; };
        "memory" = { format = "  {}% "; };
        "network" = {
          format-wifi = "  {essid} ";
          format-ethernet = " 󰈀 {ifname} ";
          format-disconnected = " ⚠ Disconnected ";
        };
      };
    };

    style = ''
      * {
        font-family: "Symbols Nerd Font", "Maple Mono NF", "Font Awesome 6 Free";
        font-size: 13px;
        border: none;
        border-radius: 0;
      }
      
      window#waybar {
        background-color: rgba(30, 30, 46, 0.9);
        border: 2px solid rgba(203, 166, 247, 0.5);
        border-radius: 12px;
        color: #cdd6f4;
      }
      
      #workspaces button {
        padding: 0 10px;
        color: #6c7086;
        margin: 4px 2px;
        border-radius: 8px;
      }
      
      #workspaces button.focused {
        background-color: #313244;
        color: #cba6f7;
      }
      
      #clock, #cpu, #memory, #network, #battery, #tray {
        padding: 0 15px;
        margin: 4px 2px;
        background-color: #313244;
        border-radius: 8px;
        color: #cdd6f4;
      }

      #clock { color: #f9e2af; }
      #cpu { color: #a6e3a1; }
      #memory { color: #89b4fa; }
      #network { color: #f5c2e7; }
      #battery { color: #fab387; /* Catppuccin Peach */ }
      #battery.charging { color: #a6e3a1; /* Catppuccin Green */ }
      #battery.warning:not(.charging) { color: #fab387; }
      #battery.critical:not(.charging) { color: #f38ba8; /* Catppuccin Red */ animation: blink 0.5s steps(5) infinite; }

      @keyframes blink {
        to {
          background-color: #f38ba8;
          color: #1e1e2e;
        }
      }
    '';
  };
}

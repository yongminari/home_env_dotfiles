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
        height = 30;
        spacing = 4;
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "clock" ];
        modules-right = [ "cpu" "memory" "network" "tray" ];

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{name}";
        };

        "clock" = {
          format = " {:%Y-%m-%d %H:%M} ";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        "cpu" = {
          format = "  {usage}% ";
          tooltip = false;
        };

        "memory" = {
          format = "  {}% ";
        };

        "network" = {
          format-wifi = "  {essid} ";
          format-ethernet = " 󰈀 {ifname} ";
          format-disconnected = " ⚠ Disconnected ";
        };
      };
    };

    style = ''
      * {
        font-family: "Maple Mono NF", "Font Awesome 6 Free";
        font-size: 13px;
        border: none;
        border-radius: 0;
      }
      window#waybar {
        background-color: rgba(30, 30, 46, 0.85);
        border-bottom: 2px solid #cba6f7;
        color: #cdd6f4;
      }
      #workspaces button {
        padding: 0 5px;
        color: #cdd6f4;
      }
      #workspaces button.focused {
        color: #cba6f7;
        border-bottom: 2px solid #cba6f7;
      }
      #clock, #cpu, #memory, #network, #tray {
        padding: 0 10px;
        margin: 0 2px;
        background-color: rgba(49, 50, 68, 0.5);
        border-radius: 5px;
      }
    '';
  };
}

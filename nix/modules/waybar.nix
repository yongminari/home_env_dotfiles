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
        
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "clock" ];
        modules-right = [ "cpu" "memory" "network" "tray" ];

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{name}";
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
        font-family: "Maple Mono NF", "Font Awesome 6 Free";
        font-size: 13px;
        border: none;
        border-radius: 0;
      }
      
      window#waybar {
        background-color: rgba(30, 30, 46, 0.9); /* Catppuccin Base with opacity */
        border: 2px solid rgba(203, 166, 247, 0.5); /* Catppuccin Mauve */
        border-radius: 12px;
        color: #cdd6f4; /* Catppuccin Text */
      }
      
      #workspaces button {
        padding: 0 10px;
        color: #6c7086; /* Catppuccin Overlay0 */
        margin: 4px 2px;
        border-radius: 8px;
      }
      
      #workspaces button.focused {
        background-color: #313244; /* Catppuccin Surface0 */
        color: #cba6f7; /* Catppuccin Mauve */
      }
      
      #workspaces button:hover {
        background-color: #45475a; /* Catppuccin Surface1 */
        color: #f5c2e7; /* Catppuccin Pink */
      }

      #clock, #cpu, #memory, #network, #tray {
        padding: 0 15px;
        margin: 4px 2px;
        background-color: #313244;
        border-radius: 8px;
        color: #cdd6f4;
      }

      #clock { color: #f9e2af; /* Catppuccin Yellow */ }
      #cpu { color: #a6e3a1; /* Catppuccin Green */ }
      #memory { color: #89b4fa; /* Catppuccin Blue */ }
      #network { color: #f5c2e7; /* Catppuccin Pink */ }
    '';
  };
}

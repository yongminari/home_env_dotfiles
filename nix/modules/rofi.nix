{ config, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi; 
    
    # [Rofi 기본 설정]
    terminal = "ghostty";
    font = "Maple Mono NF 11";
    
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      display-drun = "APPS";
      display-run = "RUN";
      display-window = "WINDOW";
      drun-display-format = "{name}";
      window-format = "{w} · {c} · {t}";
    };

    # [Standard Modern Center Theme] - Standard RASI Syntax
    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        bg = mkLiteral "#1E1E2E";
        bg-alt = mkLiteral "#313244";
        fg = mkLiteral "#CDD6F4";
        accent = mkLiteral "#CBA6F7";
        urgent = mkLiteral "#F38BA8";
        
        background-color = mkLiteral "@bg";
        text-color = mkLiteral "@fg";
      };

      "window" = {
        transparency = "real";
        location = mkLiteral "center";
        anchor = mkLiteral "center";
        fullscreen = false;
        width = mkLiteral "600px";
        x-offset = mkLiteral "0px";
        y-offset = mkLiteral "0px";

        enabled = true;
        margin = mkLiteral "0px";
        padding = mkLiteral "0px";
        border = mkLiteral "2px";
        border-color = mkLiteral "@accent";
        border-radius = mkLiteral "12px";
        cursor = "default";
      };

      "mainbox" = {
        enabled = true;
        spacing = mkLiteral "0px";
        margin = mkLiteral "0px";
        padding = mkLiteral "0px";
        border = mkLiteral "0px";
        border-color = mkLiteral "@accent";
        background-color = mkLiteral "transparent";
        children = mkLiteral "[ \"inputbar\", \"listview\" ]";
      };

      "inputbar" = {
        enabled = true;
        spacing = mkLiteral "10px";
        margin = mkLiteral "0px";
        padding = mkLiteral "15px";
        border = mkLiteral "0px 0px 1px 0px";
        border-color = mkLiteral "@bg-alt";
        background-color = mkLiteral "@bg";
        text-color = mkLiteral "@fg";
        children = mkLiteral "[ \"prompt\", \"entry\" ]";
      };

      "prompt" = {
        enabled = true;
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@accent";
      };

      "entry" = {
        enabled = true;
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        cursor = "text";
        placeholder = "Search...";
        placeholder-color = mkLiteral "inherit";
      };

      "listview" = {
        enabled = true;
        columns = 1;
        lines = 8;
        cycle = true;
        dynamic = true;
        scrollbar = false;
        layout = mkLiteral "vertical";
        reverse = false;
        fixed-height = true;
        fixed-columns = true;
        
        spacing = mkLiteral "5px";
        margin = mkLiteral "0px";
        padding = mkLiteral "10px";
        border = mkLiteral "0px";
        border-color = mkLiteral "@accent";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg";
        cursor = "default";
      };

      "element" = {
        enabled = true;
        spacing = mkLiteral "10px";
        margin = mkLiteral "0px";
        padding = mkLiteral "8px";
        border = mkLiteral "0px";
        border-radius = mkLiteral "8px";
        border-color = mkLiteral "@accent";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg";
        cursor = "pointer";
      };

      "element normal.normal" = {
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };

      "element selected.normal" = {
        background-color = mkLiteral "@bg-alt";
        text-color = mkLiteral "@accent";
      };

      "element-icon" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        size = mkLiteral "32px";
        cursor = "inherit";
      };

      "element-text" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        highlight = mkLiteral "inherit";
        cursor = "inherit";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.0";
      };
    };
  };
}

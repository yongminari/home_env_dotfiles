{ config, pkgs, ... }:

{
  programs.wofi = {
    enable = true;
    settings = {
      allow_images = true;
      insensitive = true;
      prompt = "Search Apps...";
      width = "30%";
      lines = 10;
      location = "center";
      hide_scroll = true;
      mode = "drun";
    };
    
    # Modern Translucent Dark Theme
    style = ''
      window {
        margin: 0px;
        border: 2px solid #cba6f7;
        background-color: rgba(30, 30, 46, 0.9);
        border-radius: 12px;
        font-family: "Maple Mono NF";
      }
      #input {
        margin: 10px;
        border: none;
        border-radius: 8px;
        background-color: #313244;
        color: #cdd6f4;
        padding: 8px;
      }
      #inner-box {
        margin: 5px;
        background-color: transparent;
      }
      #outer-box {
        margin: 5px;
        background-color: transparent;
      }
      #text {
        margin: 5px;
        color: #cdd6f4;
      }
      #entry:selected {
        background-color: #45475a;
        border-radius: 8px;
      }
      #text:selected {
        color: #cba6f7;
      }
    '';
  };
}

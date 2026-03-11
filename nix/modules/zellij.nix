{ config, pkgs, lib, ... }:

let
  mkZellijConfig = lockKey: themeName: ''
    theme "${themeName}"
    default_layout "default"
    pane_frames true
    simplified_ui false
    mirror_session_to_terminal_title true
    mouse_mode true
    copy_on_select true
    copy_command "wl-copy"

    keybinds {
      // 1. 잠금 키 설정
      shared_except "locked" {
        ${if lockKey == "Ctrl g" then "" else "unbind \"Ctrl g\""}
        bind "${lockKey}" { SwitchToMode "Locked"; }

        // Alt 기반 이동 키
        bind "Alt h" { MoveFocusOrTab "Left"; }
        bind "Alt l" { MoveFocusOrTab "Right"; }
        bind "Alt j" { MoveFocus "Down"; }
        bind "Alt k" { MoveFocus "Up"; }
        bind "Alt =" { Resize "Increase"; }
        bind "Alt -" { Resize "Decrease"; }
        bind "Alt n" { NewPane "Right"; }
        bind "Alt i" { MoveTab "Left"; }
        bind "Alt o" { MoveTab "Right"; }
        bind "Ctrl x" { CloseFocus; SwitchToMode "Normal"; }
      }

      locked {
        ${if lockKey == "Ctrl g" then "" else "unbind \"Ctrl g\""}
        bind "${lockKey}" { SwitchToMode "Normal"; }
      }
    }

    themes {
      modern-gruvbox {
        fg 235 219 178
        bg 40 40 40
        black 29 32 33
        red 251 73 52
        green 184 187 38
        yellow 250 189 47
        blue 131 165 152
        magenta 211 134 155
        cyan 142 192 124
        white 168 153 132
        orange 254 128 25
      }
      
      remote-green {
        fg 235 219 178
        bg 40 40 40
        black 29 32 33
        red 251 73 52
        green 184 187 38
        yellow 250 189 47
        blue 131 165 152
        magenta 211 134 155
        cyan 142 192 124
        white 168 153 132
        orange 254 128 25
      }
    }
  '';
in
{
  home.packages = [ pkgs.zellij ];
  
  # 로컬 설정 (Ctrl g)
  xdg.configFile."zellij/config.kdl".text = mkZellijConfig "Ctrl g" "modern-gruvbox";
  
  # 원격/Docker 설정 (Ctrl a)
  xdg.configFile."zellij/remote.kdl".text = mkZellijConfig "Ctrl a" "remote-green";
}

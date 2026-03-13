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
  '';
in
{
  home.packages = [ pkgs.zellij ];
  
  # 로컬 설정 (Ctrl g) - 내장 gruvbox-dark 테마 사용
  xdg.configFile."zellij/config.kdl".text = mkZellijConfig "Ctrl g" "gruvbox-dark";
  
  # 원격/Docker 설정 (Ctrl a) - 내장 catppuccin-latte 테마 사용
  xdg.configFile."zellij/remote.kdl".text = mkZellijConfig "Ctrl a" "catppuccin-latte";
}

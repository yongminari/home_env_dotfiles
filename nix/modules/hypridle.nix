{ config, pkgs, ... }:

{
  # Hypridle Configuration (~/.config/hypr/hypridle.conf)
  xdg.configFile."hypr/hypridle.conf".text = ''
    general {
        lock_cmd = pidof hyprlock || /usr/bin/hyprlock       # 잠금 명령
        before_sleep_cmd = loginctl lock-session             # 절전 모드 진입 전 잠금
        after_sleep_cmd = hyprctl dispatch dpms on           # 깨어날 때 화면 켜기
    }

    # [5분 뒤 화면 끄기]
    listener {
        timeout = 300                                
        on-timeout = hyprctl dispatch dpms off
        on-resume = hyprctl dispatch dpms on
    }

    # [10분 뒤 자동 잠금]
    listener {
        timeout = 600                                
        on-timeout = loginctl lock-session
    }
  '';
}

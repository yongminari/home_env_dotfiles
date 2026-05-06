{ config, pkgs, ... }:

{
  # Hypridle Configuration (~/.config/hypr/hypridle.conf)
  xdg.configFile."hypr/hypridle.conf".text = ''
    general {
        lock_cmd = pidof hyprlock || /usr/bin/hyprlock       # 잠금 명령
        before_sleep_cmd = loginctl lock-session             # 절전 모드 진입 전 잠금
        after_sleep_cmd = hyprctl dispatch dpms on           # 깨어날 때 화면 켜기
    }

    # [9분: 화면 어둡게 하기 (경고)]
    listener {
        timeout = 540                                
        on-timeout = /usr/bin/brightnessctl set 10%
        on-resume = /usr/bin/brightnessctl set 100%
    }

    # [10분: 화면 잠금 (Lock Screen)]
    listener {
        timeout = 600                                
        on-timeout = loginctl lock-session
    }

    # [15분: 화면 끄기 (DPMS Off)]
    listener {
        timeout = 900                                
        on-timeout = hyprctl dispatch dpms off
        on-resume = hyprctl dispatch dpms on
    }
  '';
}

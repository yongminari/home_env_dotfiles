{ config, pkgs, ... }:

{
  # 1. 한글 엔진 설정 파일 (기본 옵션 보장)
  xdg.configFile."fcitx5/conf/hangul.conf" = {
    text = ''
[Hangul]
InactivateHangulModeWhenPressingEscape=True
InactivateHangulModeOnEscape=True
CommitWithSpace=False
InitialState=Hangul
    '';
    force = true;
  };

  # 2. GNOME Wayland에서도 작동하는 강력한 Lua 스크립트
  # 키 코드 대신 'Escape'라는 문자열 이름을 사용하여 충돌을 방지합니다.
  xdg.dataFile."fcitx5/lua/main.lua" = {
    text = ''
local fcitx = require("fcitx")

function on_key(key, state, is_release)
    -- 키를 뗄 때가 아닌 '누를 때'만 작동
    if is_release then return false end

    -- 키 심볼을 문자열로 변환하여 확인
    local key_str = fcitx.keySymbolToString(key)
    
    if key_str == "Escape" then
        local current = fcitx.currentIM()
        if current == "hangul" then
            -- fcitx5-remote -c와 동일한 동작 수행
            fcitx.inactivate()
            -- ESC 신호는 앱(Vim 등)으로 그대로 흘려보내야 하므로 false 반환
            return false
        end
    end
    return false
end

fcitx.watchEvent(fcitx.EventType.KeyEvent, "on_key")
    '';
    force = true;
  };
}

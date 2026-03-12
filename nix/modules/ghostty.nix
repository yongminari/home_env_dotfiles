{ config, pkgs, ... }:

{
  # Ghostty 설정 (~/.config/ghostty/config)
  xdg.configFile."ghostty/config".text = ''
    # [Font]
    font-family = "Maple Mono NF"
    font-size = 12

    # [Window & Visuals]
    window-width = 150
    window-height = 60
    window-decoration = auto
    background-opacity = 0.85
    theme = Dracula

    # [Compatibility] SSH 접속 시 서버가 xterm-ghostty를 모를 수 있으므로 표준으로 설정
    term = xterm-256color

    # [Cursor] - 사용자가 좋아하는 두꺼운 블록 커서로 고정
    cursor-style = block
    cursor-style-blink = true

    # [Shell Integration]
    # 쉘 통합 기능은 켜두되, 커서를 얇게 바꾸지 못하게 막음 (no-cursor)
    shell-integration = detect
    shell-integration-features = no-cursor

    # [Clipboard] 원격 서버(SSH)에서 클립보드 복사(OSC 52)를 허용함
    clipboard-read = allow
    clipboard-write = allow
  '';
}

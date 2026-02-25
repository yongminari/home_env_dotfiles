{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    prefix = "C-g";
    mouse = true;
    baseIndex = 1;
    escapeTime = 0;
    keyMode = "vi";
    customPaneNavigationAndResize = true;

    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.yank
      {
        plugin = tmuxPlugins.power-theme;
        extraConfig = "set -g @tmux_power_theme 'coral'";
      }
    ];
    extraConfig = ''
      # 1. Vim-Tmux Navigator Alt (Meta) Key Bindings
      # Ctrl+j 충돌 방지를 위해 Alt(M-) 키로 변경합니다.
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"
      bind-key -n 'M-h' if-shell "$is_vim" 'send-keys M-h'  'select-pane -L'
      bind-key -n 'M-j' if-shell "$is_vim" 'send-keys M-j'  'select-pane -D'
      bind-key -n 'M-k' if-shell "$is_vim" 'send-keys M-k'  'select-pane -U'
      bind-key -n 'M-l' if-shell "$is_vim" 'send-keys M-l'  'select-pane -R'

      # 기존 Ctrl 매핑 해제 (Vim-Tmux Navigator 플러그인 기본값 무시)
      unbind-key -n C-h
      unbind-key -n C-j
      unbind-key -n C-k
      unbind-key -n C-l

      # 2. Nested Tmux (Remote Session) Toggle
      # F12를 눌러 로컬 tmux 단축키를 비활성화하고 상태바를 숨깁니다.
      bind-key -T root F12 set prefix None \; set key-table off \; set status off \; if -F '#{pane_in_mode}' 'send-keys -X cancel' \; refresh-client -S
      
      # F12를 다시 눌러 로컬 tmux를 활성화하고 상태바를 다시 표시합니다.
      bind-key -T off F12 set -u prefix \; set -u key-table \; set status on \; refresh-client -S

      # 3. 터미널 클립보드 프로토콜(OSC 52) 설정
      # 원격 환경에서도 로컬 클립보드로 복사되도록 설정합니다.
      set -s set-clipboard on
      set -as terminal-features ',xterm-256color:clipboard'

      # 4. 복사 모드(vi) 키 바인딩
      bind-key -T copy-mode-vi v send-keys -X begin-selection

      # 5. 복사 명령어 (Wayland와 X11 모두 지원)
      # 로컬에서는 OS별 유틸리티를 사용하고, 원격/기본값으로는 OSC 52(set-clipboard)를 활용합니다.
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "if [ -n \"$WAYLAND_DISPLAY\" ]; then ${pkgs.wl-clipboard}/bin/wl-copy; elif [ -n \"$DISPLAY\" ]; then ${pkgs.xclip}/bin/xclip -sel clip -i; else tmux load-buffer - ; fi"
      bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "if [ -n \"$WAYLAND_DISPLAY\" ]; then ${pkgs.wl-clipboard}/bin/wl-copy; elif [ -n \"$DISPLAY\" ]; then ${pkgs.xclip}/bin/xclip -sel clip -i; else tmux load-buffer - ; fi"

      # 6. tmux-yank 플러그인 설정 (보조용)
      set -g @yank_selection 'clipboard'
      set -g @yank_selection_mouse 'clipboard'
      set -g @yank_action 'copy-pipe'
    '';
  };
}

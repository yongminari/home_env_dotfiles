{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # 1. 환경 감지 및 공통 환경 변수 (Bash와 Nushell에서도 공유할 수 있게 추후 통합 예정)
    envExtra = ''
      # Ghostty TERM fix
      if [[ "$TERM" == "xterm-ghostty" ]] && ! command -v infocmp &>/dev/null; then
        export TERM=xterm-256color
      fi

      export PATH=$HOME/.local/bin:$PATH
    '';

    # 2. 쉘 초기화 (최신 표준 initContent 사용)
    initContent = ''
      # [Environment Detection]
      function is_ssh() { [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" || -n "$SSH_CONNECTION" ]]; }
      function is_docker() { [[ -e /.dockerenv ]] || grep -q "docker" /proc/1/cgroup 2>/dev/null; }
      function is_vscode() { [[ -n "$VSCODE_IPC_HOOK_CLI" || -n "$VSCODE_PID" || "$TERM_PROGRAM" == "vscode" ]]; }

      # [Theme & Prompt Settings]
      if is_ssh || is_docker; then
        export STARSHIP_CONFIG="$HOME/.config/starship-ssh.toml"
      fi

      # [Welcome Message]
      if [[ $- == *i* ]]; then welcome-msg; fi

      # [External Tools (fnm, pyenv)]
      if command -v fnm &>/dev/null; then eval "$(fnm env --use-on-cd --shell zsh)"; fi
      if command -v pyenv &>/dev/null; then eval "$(pyenv init -)"; eval "$(pyenv virtualenv-init -)"; fi

      # [Keybindings]
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down

      # [Zellij Auto-start]
      if [[ $- == *i* ]] && [[ -z "$ZELLIJ" ]] && ! is_vscode; then
        if is_ssh || is_docker; then
          exec zellij --config "$HOME/.config/zellij/remote.kdl"
        else
          exec zellij
        fi
      fi

      # [Zellij Wrapper]
      function zellij() {
        if is_ssh || is_docker; then
          command zellij --config "$HOME/.config/zellij/remote.kdl" "$@"
        else
          command zellij "$@"
        fi
      }
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "virtualenv" "history-substring-search" ];
    };

    # (특수 에일리어스는 유지, 공통 에일리어스는 home.nix에서 로드됨)
    shellAliases = {
      hypr_shortcuts = ''printf "\n  \033[1;34m🪟 Hyprland & Wofi Shortcuts\033[0m\n\n  \033[1;32mSuper + Enter\033[0m       Launch Ghostty\n  \033[1;32mSuper + R\033[0m           Launch Wofi (Runner)\n  \033[1;32mSuper + W\033[0m           Work Automation (Slack/Git/Gmail)\n  \033[1;32mSuper + F\033[0m           Toggle Fullscreen\n  \033[1;32mSuper + hjkl\033[0m        Move Focus (Window/Monitor)\n  \033[1;32mSuper + , / .\033[0m       Cycle Monitor Focus\n  \033[1;32mSuper + Shift + hjkl\033[0m Move Window Position\n  \033[1;32mSuper + Alt + hjkl\033[0m   Resize Active Window\n  \033[1;32mSuper + S / Shift+S\033[0m  Scratchpad Toggle / Move window\n  \033[1;32mSuper + Space\033[0m       IBus Language Toggle\n  \033[1;32mSuper + Q\033[0m           Kill Active Window\n  \033[1;32mSuper + M\033[0m           Exit Hyprland (Logout)\n  \033[1;32mSuper + V\033[0m           Toggle Floating\n  \033[1;32mSuper + 1~0\033[0m         Switch Workspace (1-10)\n  \033[1;32mSuper + Shift + 1~0\033[0m Move to Workspace\n  \033[1;32mSuper + Scroll\033[0m      Switch Workspaces\n  \033[1;32mSuper + Mouse L/R\033[0m   Drag to Move / Resize Window\n\n" | lolcat'';
    };
  };
}

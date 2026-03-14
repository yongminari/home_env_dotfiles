{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    envExtra = ''
      if [[ "$TERM" == "xterm-ghostty" ]] && ! command -v infocmp &>/dev/null; then
        export TERM=xterm-256color
      elif [[ "$TERM" == "xterm-ghostty" ]] && ! infocmp xterm-ghostty &>/dev/null; then
        export TERM=xterm-256color
      fi
    '';

    initContent = lib.mkMerge [
      (lib.mkBefore ''
        # Ghostty integration
        if [[ -n "$GHOSTTY_RESOURCES_DIR" ]]; then
          if [[ -f "/usr/share/ghostty/shell-integration/zsh/ghostty-integration" ]]; then
            source "/usr/share/ghostty/shell-integration/zsh/ghostty-integration"
          elif [[ -f "$HOME/.nix-profile/share/ghostty/shell-integration/zsh/ghostty-integration" ]]; then
            source "$HOME/.nix-profile/share/ghostty/shell-integration/zsh/ghostty-integration"
          fi
        fi

        # Zellij/SSH helpers
        # if [[ "$TERM" == "zellij" ]]; then
        #   export TERM=xterm-256color
        #   export ZELLIJ_SKIP_AUTOSTART=true
        # fi
# Environment Check Functions
function is_ssh() {
  [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" || -n "$SSH_CONNECTION" ]]
}

function is_docker() {
  [[ -e /.dockerenv ]] || grep -q "docker" /proc/1/cgroup 2>/dev/null
}

# SSH or Docker specific settings
if is_ssh || is_docker; then
  # 원격지 느낌을 주기 위해 별도의 Starship 설정을 사용하거나 환경 변수를 설정할 수 있습니다.
  export STARSHIP_CONFIG="$HOME/.config/starship-ssh.toml"
fi

# [Welcome Message]
if [[ $- == *i* ]]; then
  welcome-msg
fi
'')
''
# External Tools (fnm, pyenv)
if command -v fnm &>/dev/null; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

if command -v pyenv &>/dev/null; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

export PATH=$HOME/.local/bin:$PATH

# Keybindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down

# VSCode check
function is_vscode() {
  [[ -n "$VSCODE_IPC_HOOK_CLI" || -n "$VSCODE_PID" || "$TERM_PROGRAM" == "vscode" ]]
}

# Auto-start Zellij with environment-aware config
if [[ $- == *i* ]] && [[ -z "$ZELLIJ" ]] && ! is_vscode; then
  if is_ssh || is_docker; then
    exec zellij --config "$HOME/.config/zellij/remote.kdl"
  else
    exec zellij
  fi
fi

# Wrapper function for manual execution
function zellij() {
  if is_ssh || is_docker; then
    command zellij --config "$HOME/.config/zellij/remote.kdl" "$@"
  else
    command zellij "$@"
  fi
}
''
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "virtualenv" "history-substring-search" ];
    };

    shellAliases = {
      hypr_shortcuts = ''printf "\n  \033[1;34m🪟 Hyprland & Wofi Shortcuts\033[0m\n\n  \033[1;32mSuper + Enter\033[0m       Launch Ghostty\n  \033[1;32mSuper + R\033[0m           Launch Wofi (Runner)\n  \033[1;32mSuper + W\033[0m           Work Automation (Slack/Git/Gmail)\n  \033[1;32mSuper + F\033[0m           Toggle Fullscreen\n  \033[1;32mSuper + hjkl\033[0m        Move Focus (Window/Monitor)\n  \033[1;32mSuper + , / .\033[0m       Cycle Monitor Focus\n  \033[1;32mSuper + Shift + hjkl\033[0m Move Window Position\n  \033[1;32mSuper + Alt + hjkl\033[0m   Resize Active Window\n  \033[1;32mSuper + S / Shift+S\033[0m  Scratchpad Toggle / Move window\n  \033[1;32mSuper + Space\033[0m       IBus Language Toggle\n  \033[1;32mSuper + Q\033[0m           Kill Active Window\n  \033[1;32mSuper + M\033[0m           Exit Hyprland (Logout)\n  \033[1;32mSuper + V\033[0m           Toggle Floating\n  \033[1;32mSuper + 1~0\033[0m         Switch Workspace (1-10)\n  \033[1;32mSuper + Shift + 1~0\033[0m Move to Workspace\n  \033[1;32mSuper + Scroll\033[0m      Switch Workspaces\n  \033[1;32mSuper + Mouse L/R\033[0m   Drag to Move / Resize Window\n\n" | lolcat'';
    };
  };
}

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

    initExtra = ''
      # sops-nix (Secrets management) 를 위한 SSH 키 경로 설정
      export SOPS_AGE_SSH_PRIVATE_KEY_FILE=~/.ssh/id_ed25519
    '';

    shellAliases = {
      ls = "eza";
      ll = "eza -l --icons --git -a";
      lt = "eza --tree --level=2 --long --icons --git";
      cat = "bat";
      tocb = "xclip -selection clipboard";
      hms = "home-manager switch --flake ~/home_env_dotfiles/#yongminari";
      hmsx = "home-manager switch --flake ~/home_env_dotfiles/#yongminari-x86-linux";
      hmsa = "home-manager switch --flake ~/home_env_dotfiles/#yongminari-aarch-linux";
      hmsm = "home-manager switch --flake ~/home_env_dotfiles/#yongminari-aarch-mac";
      vi = "nvim";
      vim = "nvim";
      zj = "zellij";
    };
  };
}

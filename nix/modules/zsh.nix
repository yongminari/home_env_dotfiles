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

        function is_ssh() {
          [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" || -n "$SSH_CONNECTION" ]] || \
          [[ "$(ps -o comm= -p $PPID 2>/dev/null)" == "sshd" ]]
        }

        if is_ssh; then
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

        # Auto-start Zellij
        if [[ $- == *i* ]] && [[ -z "$ZELLIJ" ]] && [[ -z "$ZELLIJ_SKIP_AUTOSTART" ]] && ! is_vscode && ! is_ssh; then
          exec zellij
        fi
      ''
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "virtualenv" "history-substring-search" ];
    };

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

{ config, pkgs, lib, ... }:

{
  programs.bash = {
    enable = true;
    
    # [Bash 초기화] - 표준 initExtra 사용
    initExtra = ''
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

      # [External Tools (fnm)]
      if command -v fnm &>/dev/null; then eval "$(fnm env --use-on-cd --shell bash)"; fi

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
  };
}

# [Environment Detection]
function is_ssh() { [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" || -n "$SSH_CONNECTION" ]]; }
function is_docker() { [[ -e /.dockerenv ]] || grep -q "docker" /proc/1/cgroup 2>/dev/null; }
function is_vscode() { [[ -n "$VSCODE_IPC_HOOK_CLI" || -n "$VSCODE_PID" || "$TERM_PROGRAM" == "vscode" ]]; }

# [Theme & Prompt Settings]
if is_ssh || is_docker; then
  export STARSHIP_CONFIG="$HOME/.config/starship-ssh.toml"
fi

# [Zellij Wrapper]
# 수동으로 zellij 실행 시 환경에 맞는 설정파일 자동 적용
function zellij() {
  if is_ssh || is_docker; then
    command zellij --config "$HOME/.config/zellij/remote.kdl" "$@"
  else
    command zellij "$@"
  fi
}

# [Zellij Auto-start]
# 대화형 쉘 시작 시 자동으로 zellij 세션 진입 (VSCode 환경 제외)
if [[ $- == *i* ]] && [[ -z "$ZELLIJ" ]] && ! is_vscode; then
  if is_ssh || is_docker; then
    exec command zellij --config "$HOME/.config/zellij/remote.kdl"
  else
    exec command zellij
  fi
fi

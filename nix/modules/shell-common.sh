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
# 1. 대화형 쉘일 것
# 2. 이미 Zellij 안이 아닐 것 ($ZELLIJ 환경변수 체크)
# 3. VSCode 터미널이 아닐 것
# 4. 부모 프로세스가 Zellij가 아닐 것 (중첩 방지 핵심)
if [[ $- == *i* ]] && [[ -z "$ZELLIJ" ]] && ! is_vscode; then
  parent_proc=$(ps -p $PPID -o comm= 2>/dev/null)
  if [[ "$parent_proc" != "zellij" ]]; then
    if is_ssh || is_docker; then
      exec command zellij --config "$HOME/.config/zellij/remote.kdl"
    else
      exec command zellij
    fi
  fi
fi

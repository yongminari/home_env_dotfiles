{ pkgs, lib, ... }:

let
  welcomeScript = pkgs.writeShellScriptBin "welcome-msg" ''
    # lolcat 이 있는지 확인 (Nix 패키지에서 가져옴)
    LOLCAT="${pkgs.lolcat}/bin/lolcat"

    function is_ssh() {
      [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" || -n "$SSH_CONNECTION" ]] || \
      [[ "$(ps -o comm= -p $PPID 2>/dev/null)" == "sshd" ]]
    }

    if [[ -n "$ZELLIJ" ]] || is_ssh; then
      printf "\e[?7l" # 줄바꿈 제한 해제 (이미지 깨짐 방지)
      
      os_name="Linux"
      if [[ -f /etc/os-release ]]; then
        os_name=$(grep PRETTY_NAME /etc/os-release | cut -d '"' -f2)
      fi

      {
        session_type=$([[ -n "$ZELLIJ" ]] && echo "Zellij" || echo "Remote SSH")
        shell_name=$(ps -p $PPID -o comm= | sed 's/^-//')
        host_name=$(uname -n)
        kernel_info=$(uname -r)
        current_date=$(date +'%Y-%m-%d %H:%M:%S')
        current_user=$(whoami)

        # 상단 테두리 (대시 60개)
        echo " ╭────────────────────────────────────────────────────────────╮"
        printf " │  ███                  %-36s │\n" "$os_name"
        printf " │ ░░░███                %-36s │\n" ""
        printf " │   ░░░███              HOST      : %-24s │\n" "$host_name"
        printf " │     ░░░███            SESSION   : %-24s │\n" "$session_type"
        printf " │      ███░             Shell     : %-24s │\n" "$shell_name"
        printf " │    ███░               Kernel    : %-24s │\n" "$kernel_info"
        printf " │  ███░      █████████  Date      : %-24s │\n" "$current_date"
        printf " │ ░░░       ░░░░░░░░░   Who       : %-24s │\n" "$current_user"
        # 하단 테두리 (대시 60개)
        echo " ╰────────────────────────────────────────────────────────────╯"
      } | $LOLCAT

      echo -e "\nWelcome back to \x1b[94mShell\x1b[0m, \x1b[1m$USER!\x1b[0m"
      printf "\e[?7h" # 다시 켜기
    fi
  '';
in
{
  home.packages = [ welcomeScript pkgs.lolcat ];
}

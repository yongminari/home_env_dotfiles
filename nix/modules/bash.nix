{ config, pkgs, lib, ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      hms = "home-manager switch --flake ~/home_env_dotfiles/#yongminari";
      hmsx = "home-manager switch --flake ~/home_env_dotfiles/#yongminari-x86-linux";
      hmsa = "home-manager switch --flake ~/home_env_dotfiles/#yongminari-aarch-linux";
      hmsm = "home-manager switch --flake ~/home_env_dotfiles/#yongminari-aarch-mac";
    };
    initExtra = ''
      # SSH 및 Docker 접속 여부 확인 함수
      function is_ssh() {
        [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" || -n "$SSH_CONNECTION" ]] || \
        [[ "$(ps -o comm= -p $PPID 2>/dev/null)" == "sshd" ]]
      }
      function is_docker() {
        [[ -f /.dockerenv ]] || grep -q "docker" /proc/1/cgroup 2>/dev/null
      }

      # SSH 또는 Docker 접속 시 Starship 전용 설정 적용 및 Zellij 원격 설정 로드
      if is_ssh || is_docker; then
        export STARSHIP_CONFIG="$HOME/.config/starship-ssh.toml"
        alias zellij="zellij --config $HOME/.config/zellij/remote.kdl"
      fi

      # [Welcome Message]
      if [[ $- == *i* ]]; then
        welcome-msg
      fi
    '';
  };
}

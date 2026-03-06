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
      # SSH 접속 여부 확인 함수
      function is_ssh() {
        [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" || -n "$SSH_CONNECTION" ]] || \
        [[ "$(ps -o comm= -p $PPID 2>/dev/null)" == "sshd" ]]
      }

      # SSH 접속 시 Starship 전용 설정 적용
      if is_ssh; then
        export STARSHIP_CONFIG="$HOME/.config/starship-ssh.toml"
      fi

      # [Welcome Message]
      if [[ $- == *i* ]]; then
        welcome-msg
      fi
    '';
  };
}

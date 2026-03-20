{ config, pkgs, lib, ... }:

{
  programs.bash = {
    enable = true;
    
    # [Bash 초기화] - 표준 initExtra 사용
    initExtra = ''
      ${builtins.readFile ./shell-common.sh}

      # [Welcome Message]
      if [[ $- == *i* ]]; then welcome-msg; fi

      # [External Tools (fnm)]
      if command -v fnm &>/dev/null; then eval "$(fnm env --use-on-cd --shell bash)"; fi
    '';
  };
}

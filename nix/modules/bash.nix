{ config, pkgs, lib, ... }:

{
  programs.bash = {
    enable = true;
    
    # [Bash 에일리어스] - 공통 에일리어스는 shell-utils.nix에서 관리됨
    shellAliases = { };

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

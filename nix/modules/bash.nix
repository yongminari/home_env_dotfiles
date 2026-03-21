{ config, pkgs, lib, ... }:

{
  programs.bash = {
    enable = true;
    
    # [Bash 에일리어스] - Bash 전용 (Nushell은 native ls 사용 권장)
    shellAliases = {
      ls = "eza";
      ll = "eza -l --icons --git -a";
      lt = "eza --tree --level=2 --long --icons --git";
      cat = "bat";
    };

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

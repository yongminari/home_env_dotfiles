{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = false;
    syntaxHighlighting.enable = false;

    # 1. 환경 감지 및 공통 환경 변수
    envExtra = ''
      export PATH=$HOME/.local/bin:$PATH
    '';

    # 2. 쉘 초기화 (최신 표준 initContent 사용)
    initContent = ''
      # [Locale Settings for SSH/Zellij]
      export LANG="en_US.UTF-8"
      export LC_ALL="en_US.UTF-8"

      # [Zsh 핵심 렌더링 방해 요소 제거]
      unsetopt flowcontrol
      unsetopt beep

      # [Zsh Autosuggestions Fix]
      # SSH/Zellij 환경에서 문자 중복 입력(Double typing) 방지
      export ZSH_AUTOSUGGEST_MANUAL_REBIND=1
      export ZSH_AUTOSUGGEST_USE_ASYNC=1
      export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

      ${builtins.readFile ./shell-common.sh}

      # [Welcome Message]
      if [[ $- == *i* ]]; then welcome-msg; fi

      # [External Tools (fnm, pyenv)]
      if command -v fnm &>/dev/null; then eval "$(fnm env --use-on-cd --shell zsh)"; fi
      if command -v pyenv &>/dev/null; then eval "$(pyenv init -)"; eval "$(pyenv virtualenv-init -)"; fi

      # [Keybindings]
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "virtualenv" "history-substring-search" ];
    };


    # [Zsh 에일리어스] - Zsh 전용 (Nushell은 native ls 사용 권장)
    shellAliases = {
      ls = "eza";
      ll = "eza -l --icons --git -a";
      lt = "eza --tree --level=2 --long --icons --git";
      cat = "bat";
    };
  };
}

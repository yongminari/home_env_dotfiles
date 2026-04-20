{ config, pkgs, lib, ... }:

{
  # [전역 환경 변수] - 쉘 외에도 모든 프로세스에서 참조 가능
  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # [Zsh 전용 지역 변수] - Zsh가 시작될 때 자동으로 선언됨
    localVariables = {
      ZSH_AUTOSUGGEST_MANUAL_REBIND = "1";
      ZSH_AUTOSUGGEST_USE_ASYNC = "1";
      ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE = "20";
    };

    # [경로 설정] - .zshenv에 들어감
    envExtra = ''
      export PATH=$HOME/.local/bin:$PATH
    '';

    # [쉘 초기화 스크립트] - .zshrc 구성 (최신 표준 initContent 사용)
    initContent = ''
      # 공통 쉘 스크립트 로드
      ${builtins.readFile ./shell-common.sh}

      # [Welcome Message]
      if [[ $- == *i* ]]; then welcome-msg; fi

      # [External Tools (fnm)]
      if command -v fnm &>/dev/null; then eval "$(fnm env --use-on-cd --shell zsh)"; fi

      # [Keybindings]
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "history-substring-search" ];
    };

    shellAliases = { };
  };
}

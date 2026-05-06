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

    # [Zsh Performance Tuning]
    localVariables = {
      ZSH_AUTOSUGGEST_USE_ASYNC = "1";
      ZSH_AUTOSUGGEST_MANUAL_REBIND = "1";
      ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE = "20";
      ZSH_DISABLE_COMPFIX = "true"; # Distrobox/Nix 권한 경고 방지
    };

    # [경로 설정] - .zshenv에 들어감
    envExtra = ''
      export PATH=$HOME/.local/bin:$PATH
      export ZSH_DISABLE_COMPFIX="true"
    '';

    # [쉘 초기화 스크립트] - .zshrc 구성 (최신 표준 initContent 사용)
    initContent = ''
      # 공통 쉘 스크립트 로드
      source ${./shell-common.sh}

      # [SSH/Zellij Specific Fixes]
      if [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
        bindkey "^?" backward-delete-char
        bindkey "^H" backward-delete-char
      fi

      # [Welcome Message]
      if [[ $- == *i* ]] && command -v welcome-msg &>/dev/null; then welcome-msg; fi

      # [External Tools (fnm)]
      if command -v fnm &>/dev/null; then eval "$(fnm env --use-on-cd --shell zsh)"; fi

      # [Keybindings]
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down

      # [Final Cleanup for Containers]
      if is_container; then
        if [[ -n "$chpwd_functions" ]]; then
          chpwd_functions=(''${chpwd_functions:#__zoxide_hook})
        fi
        if [[ -n "$precmd_functions" ]]; then
          precmd_functions=(''${precmd_functions:#_atuin_precmd})
        fi
        unalias ls ll lt cat v vi vim g z cd 2>/dev/null
        unset -f z zi cd __zoxide_hook _atuin_precmd 2>/dev/null
      fi
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "history-substring-search" ];
    };

    shellAliases = { };
  };
}

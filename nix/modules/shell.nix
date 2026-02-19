{ config, pkgs, lib, ... }:

{
  # 1. Starship 프롬프트 (테마 파일 로드)
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = lib.importTOML ./starship.toml;
  };

  # 2. Eza (ls 대체) 설정
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "auto";     # 아이콘 표시 (auto, always, never)
    git = true;         # Git 상태 표시
    
    # [옵션] 추가적인 플래그를 원하면 extraOptions 사용
    # extraOptions = [ "--group-directories-first" "--header" ];
  };

  # 3. Zoxide (cd 대체) 설정
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    
    # [핵심] cd 명령어를 zoxide로 대체 (--cmd cd)
    # 이제 'cd 폴더명'을 입력하면 자동으로 'z 폴더명'처럼 동작합니다.
    options = [ "--cmd cd" ];
  };

  # 4. Zsh 설정
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "virtualenv" "history-substring-search" ];
    };

    # [Alias 설정] ls 관련 명령어를 eza로 매핑
    shellAliases = {
      ls = "eza";                               # ls -> eza
      ll = "eza -l --icons --git -a";           # ll -> 자세히 + 아이콘 + Git + 숨김파일
      lt = "eza --tree --level=2 --long --icons --git"; # lt -> 트리 뷰
      
      # 기존 Alias 유지
      hms = "home-manager switch --flake ~/dotfiles/#yongminari";
      hms-wsl = "home-manager switch --flake ~/dotfiles/#yongminari-wsl";
      vi = "nvim";
      vim = "nvim";
    };

    initContent = ''
      export PATH=$HOME/.local/bin:$PATH

      # History Search 키바인딩
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down

      # [Tmux 자동 실행] (VSCode 제외)
      if [[ $- == *i* ]] && [[ -z "$TMUX" ]] && [[ "$TERM_PROGRAM" != "vscode" ]]; then
        exec tmux
      fi
    '';
  };
}

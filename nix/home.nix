{ config, pkgs, lib, isWSL, ... }:

{
  # [사용자 정보]
  home.username = "yongminari";
  home.homeDirectory = "/home/yongminari";
  home.stateVersion = "25.11"; 

  # [환경 변수 설정] NPM Global 경로
  home.sessionVariables = {
    NPM_CONFIG_PREFIX = "${config.home.homeDirectory}/.npm-global";
  };
  home.sessionPath = [
    "${config.home.homeDirectory}/.npm-global/bin"
    "${config.home.homeDirectory}/.local/bin"
  ];

  # [패키지 설치 목록]
  home.packages = with pkgs; [
    # 1. 시스템 유틸
    neofetch htop fzf ripgrep fd unzip
    
    # 2. 개발 언어 및 도구
    nodejs          # 최신 LTS 자동 추적 (nodejs_24 대신 사용)
    # corepack      # nodejs에 포함될 수 있으므로 충돌 시 주석 처리
    clang-tools cmake gnumake go gopls

    # 3. 폰트
    maple-mono.NF nerd-fonts.ubuntu-mono 

  # [조건부 설치] WSL이 아닐 때만 Ghostty 설치
  ] ++ (lib.optionals (!isWSL) [
    ghostty
  ]);

  # [Activation Script] NPM 패키지 자동 설치 (Fix: 권한 에러 해결)
  home.activation.installGeminiCli = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # NPM 글로벌 설치 경로 설정
    npm_global_dir="${config.home.homeDirectory}/.npm-global"
    mkdir -p "$npm_global_dir"
    
    # PATH에 임시로 추가하여 gemini 명령어 확인
    export PATH="$npm_global_dir/bin:$PATH"

    if ! command -v gemini &> /dev/null; then
      echo "Installing @google/gemini-cli..."
      # --prefix 옵션으로 설치 경로를 강제 지정
      ${pkgs.nodejs}/bin/npm install -g --prefix "$npm_global_dir" @google/gemini-cli
    else
      echo "@google/gemini-cli is already installed."
    fi
  '';

  # [Shell] Starship
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = { add_newline = false; };
  };

  # [Shell] Zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;       
    autosuggestion.enable = true;  
    syntaxHighlighting.enable = true; 

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "virtualenv" "history-substring-search" ];
    };

    initContent = ''
      alias ll="ls -al"
      alias hms="home-manager switch --flake ~/dotfiles/#yongminari" 
      alias hms-wsl="home-manager switch --flake ~/dotfiles/#yongminari-wsl"
      alias vi="nvim"
      alias vim="nvim"

      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down
    '';
  };

  # [Terminal] Tmux
  programs.tmux = {
    enable = true;
    prefix = "C-g";
    mouse = true;
    baseIndex = 1;
    escapeTime = 0;
    keyMode = "vi";
    customPaneNavigationAndResize = true;

    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.vim-tmux-navigator
      {
        plugin = tmuxPlugins.power-theme;
        extraConfig = "set -g @tmux_power_theme 'coral'";
      }
    ];
    extraConfig = ''
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
    '';
  };

  # [Editor] Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true; vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      vim-tmux-navigator which-key-nvim nvim-web-devicons
      {
        plugin = lualine-nvim;
        config = "require('lualine').setup { options = { theme = 'auto' } }"; 
        type = "lua";
      }
      {
        plugin = neo-tree-nvim;
        config = "vim.keymap.set('n', '<C-n>', ':Neotree toggle<CR>', { silent = true })";
        type = "lua";
      }
      nui-nvim plenary-nvim
      {
        plugin = telescope-nvim;
        config = ''
          local builtin = require('telescope.builtin')
          vim.keymap.set('n', '<leader>f', builtin.find_files, {})
          vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
        '';
        type = "lua";
      }
      {
        plugin = nvim-treesitter.withAllGrammars;
        config = "require('nvim-treesitter.configs').setup { highlight = { enable = true } }";
        type = "lua";
      }
    ];

    # [Fix] extraLuaConfig -> initLua 로 이름 변경
    initLua = ''
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.tabstop = 4
      vim.opt.shiftwidth = 4
      vim.opt.expandtab = true
      vim.g.mapleader = " "         
      vim.opt.clipboard = "unnamedplus"
    '';
  };

  # [Git] 설정
  programs.git = {
    enable = true;
    settings = {
      user = { name = "yongminari"; email = "easyid21c@gmail.com"; };
      init.defaultBranch = "master";
    };
  };

  programs.home-manager.enable = true;
}

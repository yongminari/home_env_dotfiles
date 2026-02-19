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
    nodejs_24 corepack clang-tools cmake gnumake go gopls

    # 3. 폰트
    maple-mono.NF nerd-fonts.ubuntu-mono 

  # [조건부 설치] WSL이 아닐 때만 Ghostty 터미널 설치
  ] ++ (lib.optionals (!isWSL) [
    ghostty
  ]);

  # [Activation Script] NPM 패키지 자동 설치
  home.activation.installGeminiCli = lib.hm.dag.entryAfter ["writeBoundary"] ''
    PATH="${config.home.homeDirectory}/.npm-global/bin:$PATH"
    if ! command -v gemini &> /dev/null; then
      echo "Installing @google/gemini-cli..."
      ${pkgs.nodejs_24}/bin/npm install -g @google/gemini-cli
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
      # (중요) 환경에 맞게 alias 분기 처리는 어렵지만, 주로 쓰는 명령어로 통일 가능
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

    extraLuaConfig = ''
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

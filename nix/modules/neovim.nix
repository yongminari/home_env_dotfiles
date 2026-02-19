{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true; vimAlias = true;

    # 1. 플러그인 목록
    plugins = with pkgs.vimPlugins; [
      # [Theme] 가장 인기 있는 파스텔톤 테마
      catppuccin-nvim

      # [UI & Icons]
      vim-tmux-navigator 
      which-key-nvim 
      nvim-web-devicons
      lualine-nvim
      neo-tree-nvim
      nui-nvim 
      plenary-nvim
      telescope-nvim
      
      # [Syntax]
      nvim-treesitter.withAllGrammars
    ];

    # 2. Lua 설정
    initLua = ''
      -- [기본 설정]
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.tabstop = 4
      vim.opt.shiftwidth = 4
      vim.opt.expandtab = true
      vim.g.mapleader = " "         
      vim.opt.clipboard = "unnamedplus"
      vim.opt.termguicolors = true  -- 24비트 컬러 활성화 (테마 필수 설정)

      -- [테마 설정]
      local status_ok, catppuccin = pcall(require, "catppuccin")
      if status_ok then
        catppuccin.setup({
          flavour = "mocha", -- latte, frappe, macchiato, mocha
          transparent_background = true, -- 배경 투명 (터미널 배경과 맞춤)
        })
        vim.cmd.colorscheme "catppuccin"
      end

      -- [플러그인 설정]
      -- Lualine (상태바)
      local status_ok, lualine = pcall(require, "lualine")
      if status_ok then
        lualine.setup { options = { theme = 'catppuccin' } }
      end

      -- Neo-tree (Ctrl+n으로 켜고 끄기)
      vim.keymap.set('n', '<C-n>', ':Neotree toggle<CR>', { silent = true })

      -- Telescope (파일 찾기)
      local status_ok, telescope_builtin = pcall(require, "telescope.builtin")
      if status_ok then
        vim.keymap.set('n', '<leader>f', telescope_builtin.find_files, {})
        vim.keymap.set('n', '<leader>g', telescope_builtin.live_grep, {})
      end

      -- Treesitter
      local status_ok, configs = pcall(require, "nvim-treesitter.configs")
      if status_ok then
        configs.setup {
          highlight = { enable = true },
          indent = { enable = true },
        }
      end
    '';
  };
}

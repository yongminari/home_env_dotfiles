{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true; 
    vimAlias = true;
    # wrapRc = true;  <-- 이 줄을 삭제하거나 주석 처리하세요.

    # 1. 플러그인 목록
    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      vim-tmux-navigator 
      which-key-nvim 
      nvim-web-devicons
      lualine-nvim
      neo-tree-nvim
      nui-nvim 
      plenary-nvim
      telescope-nvim
      nvim-treesitter.withAllGrammars 
    ];

    # 2. Lua 설정
    initLua = ''
      -- 안전한 설정을 위한 헬퍼 함수
      local function safe_require(module, config_fn)
        local ok, mod = pcall(require, module)
        if ok then config_fn(mod) end
      end

      -- [기본 옵션]
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.tabstop = 4
      vim.opt.shiftwidth = 4
      vim.opt.expandtab = true
      vim.g.mapleader = " "         
      vim.opt.clipboard = "unnamedplus"
      vim.opt.termguicolors = true

      -- [테마 설정]
      safe_require("catppuccin", function(catppuccin)
        catppuccin.setup({
          flavour = "mocha",
          transparent_background = true,
        })
        vim.cmd.colorscheme "catppuccin"
      end)

      -- [Lualine 설정]
      safe_require("lualine", function(lualine)
        lualine.setup { options = { theme = 'catppuccin' } }
      end)

      -- [Neo-tree 키맵]
      vim.keymap.set('n', '<C-n>', ':Neotree toggle<CR>', { silent = true })

      -- [Telescope 키맵]
      safe_require("telescope.builtin", function(builtin)
        vim.keymap.set('n', '<leader>f', builtin.find_files, {})
        vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
      end)

      -- [Treesitter 설정]
      safe_require("nvim-treesitter.configs", function(configs)
        configs.setup {
          highlight = { enable = true },
          indent = { enable = true },
        }
      end)
    '';
  };
}

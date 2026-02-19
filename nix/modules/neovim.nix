{ config, pkgs, ... }:

{
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
}

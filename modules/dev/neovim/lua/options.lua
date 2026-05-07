local utils = require('utils')

-- 테마 설정용
local theme_style = utils.is_remote and "day" or "moon"
local is_transparent = true

-- [기본 옵션]
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.ignorecase = true     -- Case insensitive searching
vim.opt.smartcase = true      -- Smart case
vim.opt.updatetime = 300      -- Faster completion and highlight
vim.g.mapleader = " "         

-- [테마 배경색 설정]
-- 투명 배경 사용 시 텍스트 가독성을 위해 항상 dark 모드 사용
vim.opt.background = "dark"

-- [클립보드 설정]
if utils.is_remote or utils.is_multiplexer then
  vim.g.clipboard = {
    name = 'osc52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
      ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
      ['+'] = function() return { vim.fn.getreg('"', 1, true), vim.fn.getregtype('"') } end,
      ['*'] = function() return { vim.fn.getreg('"', 1, true), vim.fn.getregtype('"') } end,
    },
  }
end

vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.opt.conceallevel = 2
vim.opt.laststatus = 3
vim.opt.cmdheight = 1

-- [환경 구분을 위한 UI 설정]
-- 원격지일 경우 커서라인을 활성화하고 눈에 띄는 색상으로 설정
if utils.is_remote then
  vim.opt.cursorline = true
  vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2d333f" }) -- Mirage 배경보다 약간 밝은 색
end

return {
  theme_style = theme_style,
  is_transparent = is_transparent,
}

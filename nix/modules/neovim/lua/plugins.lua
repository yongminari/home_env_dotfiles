local utils = require('utils')
local options = require('options')
local safe_require = utils.safe_require

-- [테마 설정]
if utils.is_remote then
  vim.g.ayucolor = "mirage"
else
  vim.g.ayucolor = "dark"
end
vim.cmd.colorscheme "ayu"

-- [기본 UI 컴포넌트]
safe_require("lualine", function(lualine) lualine.setup { options = { theme = 'ayu' } } end)
safe_require("bufferline", function(bufferline) bufferline.setup{} end)
safe_require("gitsigns", function(gitsigns) gitsigns.setup() end)
safe_require("ibl", function(ibl) ibl.setup() end)
safe_require("Comment", function(comment) comment.setup() end)
safe_require("nvim-autopairs", function(autopairs) autopairs.setup() end)
safe_require("mini.icons", function(icons) icons.setup(); icons.mock_nvim_web_devicons() end)

-- [파일 탐색기 & 관리]
safe_require("oil", function(oil)
  oil.setup()
  vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
end)

safe_require("neo-tree", function(neotree)
  neotree.setup({
    close_if_last_window = true,
    filesystem = { follow_current_file = { enabled = true }, use_libuv_file_watcher = true },
    window = { width = 30, mappings = { ["<space>"] = "none" } }
  })
  vim.keymap.set('n', '<C-n>', ':Neotree toggle<CR>', { silent = true })
end)

-- [검색 & 유틸리티]
safe_require("telescope.builtin", function(builtin)
  vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = "Find files" })
  vim.keymap.set('n', '<leader>g', builtin.live_grep, { desc = "Live grep" })
  vim.keymap.set('n', '<leader>s', builtin.lsp_document_symbols, { desc = "Outline" })
  vim.keymap.set('n', '<leader>d', builtin.lsp_definitions, { desc = "Definition" })
  vim.keymap.set('n', '<leader>r', builtin.lsp_references, { desc = "References" })
end)

safe_require("toggleterm", function(toggleterm)
  toggleterm.setup({ open_mapping = [[<C-/>]], direction = 'float', float_opts = { border = 'curved' } })
  vim.keymap.set({'n', 't'}, '<C-/>', '<cmd>ToggleTerm<cr>')
  vim.keymap.set({'n', 't'}, '<C-_>', '<cmd>ToggleTerm<cr>')
end)

safe_require("trouble", function(trouble)
  trouble.setup({})
  vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>")
end)

safe_require("lazygit", function(lazygit)
  vim.keymap.set("n", "<leader>G", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
end)

-- [Git 고급 도구]
safe_require("neogit", function(neogit)
  neogit.setup {}
  vim.keymap.set("n", "<leader>ng", "<cmd>Neogit<cr>", { desc = "Neogit" })
end)

safe_require("diffview", function(diffview)
  diffview.setup {}
  vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Diffview Open" })
  vim.keymap.set("n", "<leader>gq", "<cmd>DiffviewClose<cr>", { desc = "Diffview Close" })
end)

safe_require("git-conflict", function(git_conflict)
  git_conflict.setup()
end)

-- [Obsidian 설정]
safe_require("obsidian", function(obsidian)
  local vault_path = vim.fn.expand("~/Documents/obsidian_personal_note")
  if vim.fn.isdirectory(vault_path) == 1 then
    obsidian.setup({
      workspaces = { { name = "notes", path = vault_path } },
      ui = { enable = true, concealcursor = "nv" },
      checkboxes = {
        [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
        ["x"] = { char = "", hl_group = "ObsidianDone" },
        ["v"] = { char = "", hl_group = "ObsidianCheck" },
      },
      legacy_commands = false, -- 경고 제거
    })
  end
  vim.keymap.set("n", "<leader>on", "<cmd>Obsidian new<cr>")
  vim.keymap.set("n", "<leader>os", "<cmd>Obsidian search<cr>")
end)

-- [LSP & 자동완성]
local cmp_ok, cmp = pcall(require, "cmp")
if cmp_ok then
  cmp.setup({
    snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end },
    mapping = cmp.mapping.preset.insert({
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({ { name = 'nvim_lsp' }, { name = 'luasnip' } }, { { name = 'buffer' }, { name = 'path' } })
  })
end

-- Treesitter Config
safe_require("nvim-treesitter.configs", function(configs) configs.setup { highlight = { enable = true }, indent = { enable = true } } end)

-- [LSP Config (Neovim 0.11+ Modern Way)]
local capabilities = {}
local cmp_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if cmp_lsp_ok then capabilities = cmp_nvim_lsp.default_capabilities() end

local servers = { 'gopls', 'nil_ls' }

-- Neovim 0.11에서 새로 도입된 vim.lsp.config API를 우선 사용합니다.
if vim.lsp.config then
  for _, lsp in ipairs(servers) do
    vim.lsp.config(lsp, { capabilities = capabilities })
    vim.lsp.enable(lsp)
  end
  -- clangd 전용 안전 설정
  vim.lsp.config('clangd', {
    capabilities = capabilities,
    cmd = { "clangd", "--offset-encoding=utf-16" }
  })
  vim.lsp.enable('clangd')
else
  -- 구 버전(0.10 이하) 호환성을 위한 nvim-lspconfig Fallback
  local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
  if lspconfig_ok then
    for _, lsp in ipairs(servers) do lspconfig[lsp].setup { capabilities = capabilities } end
    lspconfig.clangd.setup { capabilities = capabilities, cmd = { "clangd", "--offset-encoding=utf-16" } }
  end
end

-- [LSP 단어 하이라이트 설정]
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method('textDocument/documentHighlight') then
      local group = vim.api.nvim_create_augroup('lsp_document_highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = group,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = group,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

-- 하이라이트 스타일: 배경색을 채우지 않고 언더라인만 사용하여 터미널에서 깔끔하게 보이도록 함
local hl_color = "#ffcc66" -- ayu 테마와 어울리는 골드 계열 색상
vim.api.nvim_set_hl(0, "LspReferenceText", { underline = true, sp = hl_color })
vim.api.nvim_set_hl(0, "LspReferenceRead", { underline = true, sp = hl_color })
vim.api.nvim_set_hl(0, "LspReferenceWrite", { underline = true, bold = true, sp = hl_color })

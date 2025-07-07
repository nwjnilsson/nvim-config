local lsp = require("lsp-zero")

lsp.preset("recommended")

-- lsp.ensure_installed({
--   'clangd',
--   'pylsp',
--   'yamlls',
--   'lua_ls',
--   'glsl_analyzer',
-- })

lsp.set_preferences({
  suggest_lsp_servers = false,
  sign_icons = {
    error = 'E',
    warn = 'W',
    hint = 'H',
    info = 'I'
  }
})

lsp.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }
  local format = function()
    -- nil_ls can't format, use alejandra
    if client.name == 'nil_ls' then
      vim.cmd '%!alejandra -qq'
    else
      vim.lsp.buf.format({})
    end
  end

  lsp.default_keymaps({ buffer = bufnr })

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
  --vim.keymap.set({ 'n', 'x' }, 'gq', format, opts)
  vim.keymap.set({ 'n', 'x' }, '<leader>f', format, opts)
end)



--local util = require 'lspconfig.util'
local lspconf = require('lspconfig')

lspconf.nil_ls.setup({})
lspconf.yamlls.setup({})
lspconf.pylsp.setup({})
lspconf.clangd.setup({})
lspconf.lua_ls.setup({
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
})

require('mason-lspconfig').setup({
  handlers = {
    clangd = function()
      vim.cmd [[ autocmd BufRead,BufNewFile *.mpp set filetype=mpp ]]
      vim.cmd [[ autocmd BufRead,BufNewFile *.ixx set filetype=ixx ]]
      vim.cmd [[ autocmd BufRead,BufNewFile *.cppm set filetype=cppm ]]
      lspconf.clangd.setup({
        filetypes = { "h", "hpp", "c", "cpp", "cxx", "cppm", "mpp", "ixx" },
        cmd = { "clangd", "--header-insertion=never" }
      })
    end,
  }
})

lsp.setup({})

vim.diagnostic.config({
  virtual_text = true,
  --float = {
  --  border = 'single',
  --},
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
  ['<C-Space>'] = cmp.mapping.complete(),
})
cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
  mapping = cmp_mappings,
})

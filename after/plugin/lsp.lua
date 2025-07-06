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

local function allow_format(servers)
  return function(client) return vim.tbl_contains(servers, client.name) end
end

lsp.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }
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
  vim.keymap.set({ 'n', 'x' }, 'gq', function()
    vim.lsp.buf.format({
      async = false,
      timeout_ms = 10000,
      filter = allow_format({ 'clangd', 'yamlls', 'pylsp', 'nil'})
    })
  end, opts)
end)



--local util = require 'lspconfig.util'
local lspconf = require('lspconfig')

lspconf.nil_ls.setup {}
lspconf.pylsp.setup {}
lspconf.clangd.setup {}


require('mason-lspconfig').setup({
  handlers = {
    -- this first function is the "default handler"
    -- it applies to every language server without a "custom handler"
    function(server_name)
      lspconf[server_name].setup({})
    end,

    clangd = function()
      vim.cmd [[ autocmd BufRead,BufNewFile *.mpp set filetype=mpp ]]
      vim.cmd [[ autocmd BufRead,BufNewFile *.ixx set filetype=ixx ]]
      vim.cmd [[ autocmd BufRead,BufNewFile *.cppm set filetype=cppm ]]
      lspconf.clangd.setup({
        filetypes = { "h", "hpp", "c", "cpp", "cxx", "cppm", "mpp", "ixx" },
        cmd = {"clangd", "--header-insertion=never" }
      })
    end,
  }
})

lsp.setup()

vim.diagnostic.config({
  virtual_text = true
})

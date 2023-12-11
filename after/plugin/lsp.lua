--require('lspconfig').clangd.setup{
--    cmd={"clangd"},
--    filetypes={ "c", "cpp", "objc", "objcpp", "cuda", "proto" },
--}

--require("mason").setup()
--require("mason-lspconfig").setup({
--    ensure_installed = {"lua_ls"}
--})

--local lspconfig = require('lspconfig')

--lspconfig.lua_ls.setup {}

--local lsp = require('lsp-zero').preset({
--  name = 'minimal',
--  set_lsp_keymaps = true,
--  manage_nvim_cmp = true,
--  suggest_lsp_servers = false,
--})
local lsp = require("lsp-zero")
lsp.preset("recommended")

--lsp.setup_servers({'tsserver', 'eslint', 'lua_ls'})
lsp.ensure_installed({'tsserver', 'eslint', 'lua_ls', 'rust_analyzer'})

-- Fix Undefined global 'vim'
lsp.nvim_workspace()

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
	['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
	['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
	['<C-y>'] = cmp.mapping.confirm({select = true}),
	['<C-Space>'] = cmp.mapping.complete(),
})


lsp.setup_nvim_cmp({
	mapping = cmp_mappings
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hing = 'H',
        info = 'I'
    }
})

lsp.on_attach(function(client, bufnr)
	local opts = {buffer = bufnr, remap = false}
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
end)


--lsp.configure('clangd', {
--    filetypes={ "c", "cpp", "objc", "objcpp", "cuda", "proto" },
--    root_dir=lspconfig.util.root_pattern(
--          '.clangd',
--          '.clang-tidy',
--          '.clang-format',
--          'compile_commands.json',
--          'compile_flags.txt',
--          'configure.ac',
--          '.git'
--          ),
--    single_file_support=true
--})

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})


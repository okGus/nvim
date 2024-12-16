local lsp = require("lsp-zero")

local lspconfig = require("lspconfig")
local configs = require("lspconfig.configs")

-- Enable debug logging
--vim.lsp.set_log_level("debug")
vim.lsp.set_log_level("off")

lsp.preset("recommended")

--lsp.setup_servers({'tsserver', 'eslint', 'lua_ls'})
--tsserver changed to ts_ls
lsp.ensure_installed({'ts_ls', 'eslint', 'lua_ls', 'rust_analyzer', 'pylsp'})

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

-- TODO: fix this 
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


-- Finalize LSP setup
lsp.setup()

lspconfig.pylsp.setup{
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {
                    ignore = {'W391', 'E302', 'E305', 'E265'},
                    maxLineLength = 100
                }
            }
        }
    }
}

-- Add debug commands 

vim.api.nvim_create_user_command("LLMDebug", function ()
    -- Check LSP status
    local clients = vim.lsp.get_active_clients()
    print("Active LSP clients:")
    for _, client in ipairs(clients) do
        print(string.format("- %s (id: %d)", client.name, client.id))
    end

    -- Check Ollama connection
    --local curl = require("plenary.curl")
    --local response = curl.post("http://127.0.0.1:11434/api/generate", {
    --    body = vim.fn.json_encode({
    --        model = "qwen2.5-coder:7b",
    --        prompt = "test"
    --    }),
    --    headers = {
    --        content_type = "application/json",
    --    },
    --})
    --print("\nOllama test response:", vim.inspect(response))

    -- Check llm-ls executable 
    local llm_ls_path = vim.fn.stdpath("data") .. "/mason/bin/llm-ls"
    print("\nllm-ls path:", llm_ls_path)
    print("llm-ls executable:", vim.fn.executable(llm_ls_path) == 1)

    -- Print LSP logs location
    print("\nLSP logs location:", vim.lsp.get_log_path())
end, {})

vim.api.nvim_create_user_command("LLMStatus", function ()
    local clients = vim.lsp.get_active_clients()
    for _, client in ipairs(clients) do
        -- changed to llm-ls from llm_ls
        if client.name == "llm-ls" then
            print("LLM LSP is active")
            print("Server capabilities:", vim.inspect(client.server_capabilities))
            return
        end
    end
    print("LLM LSP is not active")
end, {})

vim.api.nvim_create_user_command("ReloadLLM", function()
    -- Stop the LSP client
    local clients = vim.lsp.get_active_clients()
    for _, client in ipairs(clients) do
        -- changed to llm-ls from llm_ls
        if client.name == "llm-ls" then
            vim.lsp.stop_client(client.id, true) -- Force stop
        end
    end

    -- Clear existing LSP state
    vim.schedule(function()
        -- Restart the LSP
        -- changed to llm-ls from llm_ls
        vim.cmd("LspStart llm-ls")

        -- Wait a bit before enabling suggestions
        vim.defer_fn(function ()
            vim.cmd("LLMToggleAutoSuggest")
            vim.cmd("LLMToggleAutoSuggest") -- Ensure its on
            print("LLM reloaded and suggestions enabled")
        end, 1000) -- Wait 1 second
    end)
end, {})

-- Diagnostic configuration
vim.diagnostic.config({
    virtual_text = true
})


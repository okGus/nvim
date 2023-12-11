-- This file can be loaded by calling `lua require('plugins')` from your init.vim



-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.1',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }
  use({
	  'rose-pine/neovim',
	  as = 'rose-pine',
	  config = function()
		  vim.cmd('colorscheme rose-pine')
	  end
  })
  use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
  use('nvim-treesitter/playground')
  use('ThePrimeagen/harpoon')
  use('mbbill/undotree')
  use('tpope/vim-fugitive')

  use {
	  'VonHeikemen/lsp-zero.nvim',
	  branch = 'v1.x',
	  requires = {
		  -- LSP Support
		  {'neovim/nvim-lspconfig'},             -- Required
		  {'williamboman/mason.nvim'},           -- Optional
		  {'williamboman/mason-lspconfig.nvim'}, -- Optional

		  -- Autocompletion
		  {'hrsh7th/nvim-cmp'},         -- Required
		  {'hrsh7th/cmp-nvim-lsp'},     -- Required
		  {'hrsh7th/cmp-buffer'},       -- Optional
		  {'hrsh7th/cmp-path'},         -- Optional
		  {'saadparwaiz1/cmp_luasnip'}, -- Optional
		  {'hrsh7th/cmp-nvim-lua'},     -- Optional

		  -- Snippets
		  {'L3MON4D3/LuaSnip'},             -- Required
		  {'rafamadriz/friendly-snippets'}, -- Optional
	  }
  }

  use {
      'nvim-tree/nvim-tree.lua',
      requires = {
        'nvim-tree/nvim-web-devicons',
    },
  }

--    use ('huggingface/llm.nvim')
--  use {
--      'huggingface/llm.nvim',
--      config = function()
--          require('llm').setup({
--               api_token = nil,
--               model = "Phind/Phind-CodeLlama-34B-v2",
--               tokens_to_clear = { "<|endoftext|>" },
--               query_params = {
--                 max_new_tokens = 60,
--                 temperature = 0.2,
--                 top_p = 0.95,
--                 stop_tokens = nil,
--               },
--               fim = {
--                   enabled = true,
--                   prefix = "<fim_prefix> ",
--                   middle = "<fim_middle>",
--                   suffix = "<fim_suffix>",
--               },
--               debounce_ms = 150,
--               accept_keymap = "<Tab>",
--               dismiss_keymap = "<S-Tab>",
--               tls_skip_verify_insecure = false,
--               lsp = {
--                   bin_path = nil,
--                   version = "0.2.1",
--               },
--               tokenizer = nil,
--               context_window = 8192,
--               enable_suggestions_on_startup = true,
--               enable_suggestions_on_files = "*",
--           })
--       end
--   }

end)

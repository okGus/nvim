vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", "\"_dP")

-- to comment or uncomment, Ctrl-c to Esc instead of using Esc
vim.keymap.set("i", "<C-c>", "<Esc>")

--Nvimtree
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<cr>")

vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.swapfile = false
vim.o.clipboard = "unnamedplus"

vim.g.mapleader = " "

vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
vim.keymap.set('n', '<leader>pu', vim.pack.update)
vim.keymap.set('n', '<leader>gs', function()
	vim.cmd('Git status')
end)

vim.pack.add({
	"https://github.com/Mofiqul/vscode.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/tpope/vim-fugitive",
	"https://github.com/nvim-lua/plenary.nvim",
	-- "https://github.com/nvim-telescope/telescope.nvim",
})

require("oil").setup()

vim.o.background = 'light'
vim.cmd("colorscheme vscode")

vim.lsp.enable({ "lua_ls", "lemminx" })

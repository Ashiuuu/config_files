vim.o.winborder = "rounded"
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.swapfile = false
vim.o.clipboard = "unnamedplus"
--vim.o.ac = true

vim.g.mapleader = " "

vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
vim.keymap.set('n', '<leader>ls', vim.lsp.buf.signature_help)
vim.keymap.set('n', '<leader>pu', vim.pack.update)
-- Remove all inactive plugins
vim.keymap.set('n', '<leader>pr', function()
	local plugins = vim.pack.get()
	for k, v in ipairs(plugins) do
		if v.active == "false" then
			vim.pack.del(v.spec.name)
		end
	end
end)

-- rust maps
vim.keymap.set('n', '<leader>cr', ':!cargo run<CR>')

vim.pack.add({
	"https://github.com/Mofiqul/vscode.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/tpope/vim-fugitive",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/nvim-mini/mini.pick",
	"https://github.com/nvim-mini/mini.extra",
})

require("oil").setup()
require("mason").setup()
require("mini.pick").setup()
require("mini.extra").setup()

-- ============================
-- Plugin keymaps

-- fugitive
vim.keymap.set('n', '<leader>gg', ':Git<CR>')
vim.keymap.set('n', '<leader>ga', ':Git add *<CR>')
vim.keymap.set('n', '<leader>gs', ':Git status<CR>')
vim.keymap.set('n', '<leader>gp', ':Git push<CR>')
vim.keymap.set('n', '<leader>gi', ':Gcd<CR>')
vim.keymap.set('n', '<leader>gc', function()
	local buf = vim.api.nvim_create_buf(true, true)
	local opts = {
		relative = 'cursor',
		width = 30,
		height = 1,
		col = 0,
		row = 1,
		anchor = 'NW',
		style = 'minimal',
		border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
		title =
		"Commit Message",
		title_pos = "center"
	}
	local win = vim.api.nvim_open_win(buf, 0, opts)
	vim.keymap.set('i', '<CR>', function()
		local msg = table.concat(vim.api.nvim_buf_get_lines(buf, 0, vim.api.nvim_buf_line_count(0), false), "\n")
		vim.cmd('stopinsert')
		vim.api.nvim_win_close(win, true)
		vim.cmd(string.format("Git commit -m '%s'", msg))
	end, { buffer = buf })
	vim.api.nvim_input('i')
end)

-- mini.pick
vim.keymap.set('n', '<leader>pf', ':Pick files<CR>')

vim.o.background = 'light'
vim.cmd("colorscheme vscode")

vim.lsp.enable({ "lua_ls", "lemminx", "rust_analyzer" })
vim.lsp.inlay_hint.enable()
-- fix the diagnostics for vim global variable
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true)
			}
		}
	}
})

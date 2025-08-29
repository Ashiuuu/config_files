vim.o.winborder = "rounded"
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

-- Git fugitive shortcuts
vim.keymap.set('n', '<leader>gg', ':Git<CR>')
vim.keymap.set('n', '<leader>gs', ':Git status<CR>')
vim.keymap.set('n', '<leader>gp', ':Git push<CR>')
vim.keymap.set('n', '<leader>gc', function()
	local buf = vim.api.nvim_create_buf(true, true)
	vim.api.nvim_create_autocmd('BufLeave', { buffer = buf, callback = function(ev)
		local msg = table.concat(vim.api.nvim_buf_get_lines(ev.buf, 0, vim.api.nvim_buf_line_count(0), false), "\n")
		vim.api.nvim_echo({{string.format('dir: %s', vim.fn.getcwd())}}, false, {})
		vim.cmd(string.format("Git commit -m '%s'", msg))
	end})
	local opts = {relative='cursor', width=30, height=1, col=0, row=1, anchor='NW', style='minimal', border={"╔", "═" ,"╗", "║", "╝", "═", "╚", "║"}, title="Commit Message", title_pos="center"}
	local win = vim.api.nvim_open_win(buf, 0, opts)
	 
	--vim.cmd('Git commit')
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

-- Set git directory as pwd
vim.api.nvim_create_autocmd('BufEnter', { command = 'Gcd' })

vim.o.background = 'light'
vim.cmd("colorscheme vscode")

vim.lsp.enable({ "lua_ls", "lemminx" })

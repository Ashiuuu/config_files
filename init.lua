if vim.loop.os_uname().sysname == "Windows_NT" then
	vim.o.shell = "powershell"
	vim.o.shellquote = ""
	vim.o.shellpipe = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
	vim.o.shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
	vim.o.shellxquote = ""
	vim.o.shellcmdflag = '-command'
end

vim.o.winborder = "rounded"
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.swapfile = false
vim.o.clipboard = "unnamedplus"
vim.o.splitright = true
vim.o.completeopt = "menuone,noselect,popup"

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
vim.keymap.set('n', '<leader>cb', ':!cargo build<CR>')

vim.pack.add({
	"https://github.com/Mofiqul/vscode.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/tpope/vim-fugitive",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/nvim-mini/mini.pick",
	"https://github.com/nvim-mini/mini.extra",
	"https://github.com/nvim-mini/mini.icons",
	"https://github.com/tree-sitter-grammars/tree-sitter-markdown",
	"https://github.com/MeanderingProgrammer/render-markdown.nvim",
	"https://github.com/Saecki/crates.nvim",
})

require("oil").setup()
require("mason").setup()
require("mini.pick").setup()
require("mini.extra").setup()
require("mini.icons").setup()
require("render-markdown").setup({ render_modes = true })
require("crates").setup()

-- ============================
-- Plugin keymaps

-- Oil
vim.keymap.set('n', '<leader>oo', ':Oil<CR>')
vim.keymap.set('n', '<leader>os', function()
	vim.cmd('vsplit | wincmd l | vertical resize -10')
	require("oil").open()
end)

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

-- LSP config
vim.lsp.config['rust_analyzer'] = {
	cmd = { "rustup", "run", "stable", "rust-analyzer" },
	on_attach = function(client, bufnr)
		vim.lsp.completion.enable(true, client.id, bufnr, {
			autotrigger = true,
			convert = function(item)
				return { abbr = item.label:gsub("%b()", "") }
			end,
		})
		vim.keymap.set("i", "<C-space>", vim.lsp.completion.get, { desc = "trigger autocompletion" })
	end
}

vim.lsp.enable({ "lua_ls", "lemminx", "rust_analyzer" })
vim.lsp.inlay_hint.enable()
vim.keymap.set('n', '<leader>lh', vim.lsp.buf.hover)

-- Show diagnostic popup on cursor hover
vim.opt.updatetime = 500
local diag_float_grp = vim.api.nvim_create_augroup("DiagnosticFloat", { clear = true })
vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		vim.diagnostic.open_float(nil, { focusable = false })
	end,
})

-- lsp autocomplete
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		else
			print('No autocompletion')
		end
	end,
})

-- inline diagnostics
vim.diagnostic.config({ virtual_text = true })

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

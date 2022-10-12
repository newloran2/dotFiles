require("toggleterm").setup()

local Terminal = require("toggleterm.terminal").Terminal 
local lazygit = Terminal:new({
	cmd = "lazygit",
	dir = "git_dir",
	direction = "float",
	float_opts = {
		border = "double",
	},
	close_on_exit = true
})

function _lazygit_toggle()
	lazygit:toggle()
end


lmap('tg', 'lua _lazygit_toggle()')
lmap('tt', 'ToggleTerm direction="float"')
lmap('tt', 'ToggleTerm direction="float"', 't')


local opts = {buffer = 0}
vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)

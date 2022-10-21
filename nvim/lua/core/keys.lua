map = vim.api.nvim_set_keymap
vim.g.mapleader = " " 

function lmap(key, command, mode, other) 
	map(mode or 'n', '<leader>'..key, ":"..command.."<cr>", other or {})
end

lmap('bd', 'bdelete')
lmap('fw', 'HopChar2')

map('i', 'jk', '<Esc>', {})
map('i', '<C-s>', '<Esc> :w<cr>i', {}) 
map('n', '<C-s>', '<Esc> :w<cr>', {}) 

map('n', ',', '`', {})
--mapeamentos de terminal 
map('t', '<Esc>', '<c-\\><c-n>', {})

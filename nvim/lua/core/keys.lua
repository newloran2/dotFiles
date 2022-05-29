map = vim.api.nvim_set_keymap
vim.g.mapleader = " " 

function lmap(key, command, mode, other) 
	map(mode or 'n', '<leader>'..key, ":"..command.."<cr>", other or {})
end

lmap('bd', 'bdelete')
lmap('tt', 'ToggleTerm')
map('i', 'jk', '<Esc>', {})
lmap('fw', 'HopChar2')

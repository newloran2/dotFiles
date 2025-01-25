map = vim.api.nvim_set_keymap
vim.g.mapleader = " " 

function lmap(key, command, mode, other) 
	map(mode or 'n', '<leader>'..key, ":"..command.."<cr>", other or {})
end



require ('config.lazy')
require ('core/keys')
require ('core/option')
-- require ('plug_config')

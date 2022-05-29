require'telescope'.setup{
	defaults = {
		mappings = {
			i = {
			}, 
		}
	}
}
--keys
lmap('ff', 'Telescope find_files')
lmap('fh', 'Telescope oldfiles')
lmap('bb', 'Telescope buffers')

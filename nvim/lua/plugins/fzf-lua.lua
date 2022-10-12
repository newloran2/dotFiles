function fzf(key, command)
	lmap(key, 'FzfLua '..command)
end


fzf('ff', 'files')
fzf('fl', 'blines')
fzf('fh', 'oldfiles')
fzf('bb', 'buffers')

local opt = vim.opt 
cmd = vim.api.nvim_command

vim.wo.wrap = false
-- Treesitter folding 
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'

opt.tabstop = 3
opt.shiftwidth = 3
opt.expandtab = true
opt.relativenumber = true
opt.cursorline = true
opt.cursorcolumn = true
opt.background=dark
opt.lazyredraw = true
opt.guifont="Fira Code:h12"
opt.syntax = "ON" 		-- ativar a colocaração de syntaxe
opt.termguicolors = true 	-- fica mais bonito o tema pois ativa o tema gui
cmd('colorscheme aurora')	-- colorscheme
-- cmd('highlight Normal ctermbg=NONE guibg=NONE') -- removendo a cor de fund para uma rendereização mais rapida em conexões lentas (via ssh)

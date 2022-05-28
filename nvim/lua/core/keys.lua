local map = vim.api.nvim_set_keymap
vim.g.mapleader = " " 

map('n', '<leader>ff', [[:Telescope find_files<CR>]], {})
map('n', '<leader>fh', [[:Telescope oldfiles<CR>]], {})
map('n', '<leader>bb', [[:Telescope buffers<CR>]], {})
map('n', '<leader>bd', [[:bdelete<CR>]], {})
map('n', '<leader>tt', [[:FloatermToggletCR>]], {})
map('i', 'jk', '<Esc>', {})

map('n', '<leader>fw', [[:HopChar2<cr>]],{})
